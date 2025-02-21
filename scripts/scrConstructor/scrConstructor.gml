
function sTimingPoint(_time, _beatlength, _beats) constructor {
    time = _time;
    beatLength = _beatlength;
    meter = _beats;             // x/4
}

enum OPERATION_TYPE {
    MOVE,
    ADD,
    REMOVE,
    TPADD,
    TPREMOVE,
    TPCHANGE,
    OFFSET,
    CUT, // special
    ATTACH, // special
    MIRROR, // special
    ROTATE, // special
    PASTE, // special
    SETWIDTH, // special
    SETTYPE, // special
    RANDOMIZE, // special
    DUPLICATE, // special
    EXPR, // special
}

function sOperation(_type, _from, _to) constructor {
    opType = _type;
    fromProp = _from;
    toProp = _to;
}

enum NOTE_TYPE {
    NORMAL,
    CHAIN,
    HOLD,
    SUB
}

function sNote(_type, _side, _time, _width, _pos, _length) constructor {
    type = _type;
    side = _side;
    time = _time;
    width = _width;
    position = _pos;
    length = _length;

    ID = random_id(8);      // Random allocated id.
    inst = undefined;       // Note's binding instance.

    /// @param {Struct.sNote} source_note The copied note.
    static paste = function(source_note) {
        type = source_note.type;
        side = source_note.side;
        time = source_note.time;
        width = source_note.width;
        position = source_note.position;
        length = source_note.length;
        return self;
    }

    static bind_instance = function(_inst) {
        inst = _inst;
    }

    static copy = function() {
        return new sNote(type, side, time, width, position, length);
    }

    static copy_compability = function() {
        return {
        	time : time,
        	side : side,
        	width : width,
        	position : position,
        	lastTime : length,
        	noteType : type,
        	inst : inst
        };
    }
}