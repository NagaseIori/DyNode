//! A [Future] is method of organising asynchronous code in a more manageable
//! way compared to nested callbacks. This library contains methods of
//! creating and combining new futures.

//# feather use syntax-errors

/// The different progress states of a [Future].
enum FutureState {
    UNRESOLVED,
    ACCEPTED,
    REJECTED,
}

/// Constructs a new future, allowing for deferred execution of code depending
/// on whether it was accepted or rejected.
function Future() constructor {
    self.state = FutureState.UNRESOLVED;
    self.result = undefined;
    self.thenFuncs = [];
    self.catchFuncs = [];
    self.finallyFuncs = [];
    self.__futureFlag__ = true;

    /// Accepts this future with the supplied argument.
    ///
    /// @param {Any} [value]
    ///   The value to reject.
    static accept = function(value) {
        __resolve(FutureState.ACCEPTED, value);
        var thenCount = array_length(thenFuncs);
        for (var i = 0; i < thenCount; i += 2) {
            // call then callbacks
            var callback = thenFuncs[i + 0];
            var nextFuture = thenFuncs[i + 1];
            var result = callback(value);
            if (is_future(result)) {
                // if the result returned from the callback is another future,
                // delay the next future until the result future has been
                // resolved
                result.andFinally(method(nextFuture, function(future) {
                    if (future.state == FutureState.ACCEPTED) {
                        accept(future.result);
                    } else {
                        reject(future.result);
                    }
                }));
            } else {
                nextFuture.accept(result);
            }
        }
        var catchCount = array_length(catchFuncs);
        for (var i = 0; i < catchCount; i += 2) {
            // accept catch futures
            var nextFuture = catchFuncs[i + 1];
            nextFuture.accept(value);
        }
        var finallyCount = array_length(finallyFuncs);
        for (var i = 0; i < finallyCount; i += 2) {
            // accept finally futures and call their callbacks
            var callback = finallyFuncs[i + 0];
            var nextFuture = finallyFuncs[i + 1];
            callback(self);
            nextFuture.accept(value);
        }
    };

    /// Rejects this future with the supplied argument.
    ///
    /// @param {Any} [value]
    ///   The value to reject.
    static reject = function(value) {
        __resolve(FutureState.REJECTED, value);
        var thenCount = array_length(thenFuncs);
        for (var i = 0; i < thenCount; i += 2) {
            // reject then futures
            var nextFuture = thenFuncs[i + 1];
            nextFuture.reject(value);
        }
        var catchCount = array_length(catchFuncs);
        for (var i = 0; i < catchCount; i += 2) {
            // call catch callbacks
            var callback = catchFuncs[i + 0];
            var nextFuture = catchFuncs[i + 1];
            var result = callback(value);
            if (is_future(result)) {
                // if the result returned from the callback is another future,
                // delay the next future until the result future has been
                // resolved
                result.andFinally(method(nextFuture, function(future) {
                    if (future.state == FutureState.ACCEPTED) {
                        accept(future.result);
                    } else {
                        reject(future.result);
                    }
                }));
            } else {
                nextFuture.accept(result);
            }
        }
        var finallyCount = array_length(finallyFuncs);
        for (var i = 0; i < finallyCount; i += 2) {
            // reject finally futures and call their callbacks
            var callback = finallyFuncs[i + 0];
            var nextFuture = finallyFuncs[i + 1];
            callback(self);
            nextFuture.reject(value);
        }
    };

    /// Returns whether this future has been resolved. A resolved future
    /// may be the result of being accepted OR rejected.
    ///
    /// @return {Bool}
    static resolved = function() {
        return state != FutureState.UNRESOLVED;
    };

    /// Sets the callback function to invoke once the process is complete.
    ///
    /// @param {Function} callback
    ///   The function to invoke.
    ///
    /// @return {Struct.Future}
    static andThen = function(callback) {
        var future;
        if (state == FutureState.UNRESOLVED) {
            future = new Future();
            array_push(thenFuncs, callback, future);
        } else if (state == FutureState.ACCEPTED) {
            future = future_ok(callback(result));
        }
        return future;
    };

    /// Sets the callback function to invoke if an error occurrs whilst the
    /// process is running.
    ///
    /// @param {Function} callback
    ///   The function to invoke.
    ///
    /// @return {Struct.Future}
    static andCatch = function(callback) {
        var future;
        if (state == FutureState.UNRESOLVED) {
            future = new Future();
            array_push(catchFuncs, callback, future);
        } else if (state == FutureState.REJECTED) {
            future = future_ok(callback(result));
        }
        return future;
    };

    /// Sets the callback function to invoke if this promise is resolved.
    ///
    /// @param {Function} callback
    ///   The function to invoke.
    ///
    /// @return {Struct.Future}
    static andFinally = function(callback) {
        var future;
        if (state == FutureState.UNRESOLVED) {
            future = new Future();
            array_push(finallyFuncs, callback, future);
        } else {
            future = future_ok(callback(self));
        }
        return future;
    };

    /// @ignore
    static __resolve = function(newState, value) {
        if (state != FutureState.UNRESOLVED) {
            show_error(
                    "future has already been resolved with a value of " +
                    "'" + string(result) + "'", false);
            return;
        }
        result = value;
        state = newState;
    };
}

/// Creates a new [Future] which is accepted only when all other futures in an
/// array are accepted. If any future in the array is rejected, then the
/// resulting future is rejected with its value. If all futures are accepted,
/// then the resulting future is accepted with an array of their values.
///
/// @param {Array<Struct.Future>} futures
///   The array of futures to await.
///
/// @return {Struct.Future}
function future_all(futures) {
    var count = array_length(futures);
    var newFuture = new Future();
    if (count == 0) {
        newFuture.accept([]);
    } else {
        var joinData = {
            future : newFuture,
            count : count,
            results : array_create(count, undefined),
        };
        for (var i = 0; i < count; i += 1) {
            var future = futures[i];
            future.andThen(method({
                pos : i,
                joinData : joinData,
            }, function(result) {
                var future = joinData.future;
                if (future.resolved()) {
                    return;
                }
                var results = joinData.results;
                results[@ pos] = result;
                joinData.count -= 1;
                if (joinData.count <= 0) {
                    future.accept(results);
                }
            }));
            future.andCatch(method(joinData, function(result) {
                if (future.resolved()) {
                    return;
                }
                future.reject(result);
            }));
        }
    }
    return newFuture;
}

/// Creates a new [Future] which is accepted if any of the futures in an
/// array are accepted. If all futures in the array are rejected, then the
/// resulting future is rejected with an array of their values.
///
/// @param {Array<Struct.Future>} futures
///   The array of futures to await.
///
/// @return {Struct.Future}
function future_any(futures) {
    var count = array_length(futures);
    var newFuture = new Future();
    if (count == 0) {
        newFuture.reject([]);
    } else {
        var joinData = {
            future : newFuture,
            count : count,
            results : array_create(count, undefined),
        };
        for (var i = 0; i < count; i += 1) {
            var future = futures[i];
            future.andThen(method(joinData, function(result) {
                if (future.resolved()) {
                    return;
                }
                future.accept(result);
            }));
            future.andCatch(method({
                pos : i,
                joinData : joinData,
            }, function(result) {
                var future = joinData.future;
                if (future.resolved()) {
                    return;
                }
                var results = joinData.results;
                results[@ pos] = result;
                joinData.count -= 1;
                if (joinData.count <= 0) {
                    future.reject(results);
                }
            }));
        }
    }
    return newFuture;
}

/// Creates a new [Future] which is accepted when all of the futures in an
/// array are either accepted or rejected.
///
/// @param {Array<Struct.Future>} futures
///   The array of futures to await.
///
/// @return {Struct.Future}
function future_settled(futures) {
    var count = array_length(futures);
    var newFuture = new Future();
    if (count == 0) {
        newFuture.accept([]);
    } else {
        var joinData = {
            future : newFuture,
            count : count,
            results : array_create(count, undefined),
        };
        for (var i = 0; i < count; i += 1) {
            var future = futures[i];
            future.andFinally(method({
                pos : i,
                joinData : joinData,
            }, function(thisFuture) {
                var future = joinData.future;
                if (future.resolved()) {
                    return;
                }
                var results = joinData.results;
                results[@ pos] = thisFuture;
                joinData.count -= 1;
                if (joinData.count <= 0) {
                    future.accept(results);
                }
            }));
        }
    }
    return newFuture;
}

/// Creates a new [Future] which is immediately accepted with a value.
/// If the value itself it an instance of [Future], then it is returned
/// instead.
///
/// @param {Any} value
///   The value to create a future from.
///
/// @return {Struct.Future}
function future_ok(value) {
    if (is_future(value)) {
        return value;
    }
    var future = new Future();
    future.accept(value);
    return future;
}

/// Creates a new [Future] which is immediately rejected with a value.
/// If the value itself it an instance of [Future], then it is returned
/// instead.
///
/// @param {Any} value
///   The value to create a future from.
///
/// @return {Struct.Future}
function future_error(value) {
    if (is_future(value)) {
        return value;
    }
    var future = new Future();
    future.reject(value);
    return future;
}

/// Returns whether this value represents a future instance.
///
/// @param {Any} value
///   The value to check.
///
/// @return {Bool}
function is_future(value) {
    gml_pragma("forceinline");
    return is_struct(value) && variable_struct_exists(value, "__futureFlag__");
}