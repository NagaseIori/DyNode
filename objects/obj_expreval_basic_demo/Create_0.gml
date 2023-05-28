/// @description Example expreval usage

// create expression
var eval = expreval_create();

// set up variables
expreval_write_variable(eval, "a", 123);

// evaluate expression (intermediate variables are created automatically
expreval_evaluate(eval, "b=2*a;c=sin(b)")

// grab output variables
var retval = expreval_read_variable(eval, "c");
show_debug_message("Returned value: " + string(retval));

expreval_destroy(eval);








