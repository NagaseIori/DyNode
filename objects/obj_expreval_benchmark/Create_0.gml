/// @description

#macro TRIES 3

// create expression
var eval = expreval_create();

// load expression (this loads it but does not run it yet
expreval_load(eval, "x=(-b+sqrt(b^2-4*a*c))/(2*a)")

// time expreval
var tick1 = get_timer();
for(var i=0; i<TRIES; i++) {
	expreval_write_variable(eval, "a", 1.0);
	expreval_write_variable(eval, "b", i*2);
	expreval_write_variable(eval, "c", i);
	expreval_run(eval);
	var retval = expreval_read_variable(eval, "x");
	show_debug_message(retval);
	retval = retval; // prevents compiler optimazation
}
var tock1 = get_timer();

// benchmark native
var tick2 = get_timer();
for(var i=0; i<TRIES; i++) {
	var a = 1.0;
	var b = i*2;
	var c = i;
	
	var retval = (-b + sqrt(power(b,2)-4*a*c))/(2*a);
	show_debug_message(retval);
	retval = retval; // prevents compiler optimazation
}
var tock2 = get_timer();

show_debug_message("Expreval: " + string((tock1-tick1)/TRIES));
show_debug_message("Native: " + string((tock2-tick2)/TRIES));

expreval_destroy(eval);

