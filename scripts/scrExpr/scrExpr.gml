enum ExprSymbolTypes {
	NUMBER,
	STRING,
	FUNCTION
}

function ExprSymbol(_name="zero", _typ=ExprSymbolTypes.NUMBER, _val=0) constructor {
	name = _name;
	symType = _typ;
	value = undefined;
	
	static get_type = function () {
		return symType;
	}
	static get_value = function () {
		return value;
	}
	static set_value = function (_val) {
		if(is_struct(_val))
			_val = _val.get_value();
		
		// Value type check
		
		
		if(symType == ExprSymbolTypes.NUMBER) {
			if(is_string(_val) || is_int32(_val) || is_int64(_val))
				_val = real(_val);
			if(!is_real(_val))
				throw $"Symbol {name} is a number, which cannot be set to {_val}";
		}
		if(symType == ExprSymbolTypes.FUNCTION && !is_method(_val))
			throw $"Symbol {name} is a method, which cannot be set to {_val}";
		if(symType == ExprSymbolTypes.STRING && !is_method(_val))
			throw $"Symbol {name} is a string, which cannot be set to {_val}";
		
		value = _val;
	}
	
	set_value(_val);
}

function expr_init() {
	if(variable_global_exists("__expr_symbols"))
		delete global.__expr_symbols;
	global.__expr_symbols = {};
}

function expr_set_var(name, val) {
	variable_struct_set(global.__expr_symbols, name, new ExprSymbol(name, ExprSymbolTypes.NUMBER, val));
}

function expr_get_var(name) {
	if(!variable_struct_exists(global.__expr_symbols, name))
		throw $"Variable {name} was not defined before reading.";
	return variable_struct_get(global.__expr_symbols, name).value;
}

function expr_get_sym(name) {
	if(!variable_struct_exists(global.__expr_symbols, name))
		throw $"Variable {name} was not defined before reading.";
	return variable_struct_get(global.__expr_symbols, name);
}

function expr_cac(_opt, _a, _b=new ExprSymbol()) {
	show_debug_message_safe($"EXPR CAC {_opt}, {_a}, {_b}")
	var _va = _a.get_value(), _vb = _b.get_value();
	var _res = new ExprSymbol();
	switch(_opt) {
		case "=":
			_a.set_value(_b);
			_res = _a;
			break;
		case "+":
			_res = _va + _vb;
			break;
		case "-":
			_res = _va - _vb;
			break;
		case "*":
			_res = _va * _vb;
			break;
		case "/":
			_res = _va / _vb;
			break;
		case "<<":
			_res = _va << _vb;
			break;
		case ">>":
			_res = _va >> _vb;
			break;
		case "%":
			_res = _va % _vb;
			break;
		case "!":
			_res = real(!bool(_va));
			break;
		case ">":
			_res = _va > _vb;
			break;
		case ">=":
			_res = _va >= _vb;
			break;
		case "<":
			_res = _va < _vb;
			break;
		case "<=":
			_res = _va <= _vb;
			break;
		case "==":
			_res = _va == _vb;
			break;
		case "!=":
			_res = _va != _vb;
			break;
		case "&":
			_res = _va & _vb;
			break;
		case "|":
			_res = _va | _vb;
			break;
		case "^":
			_res = _va ^ _vb;
			break;
		case "&&":
			_res = real(bool(_va) && bool(_vb));
			break;
		case "||":
			_res = real(bool(_va) || bool(_vb));
			break;
		default:
			show_debug_message("Warning: unknow operation " + _opt);
			break;
	}
	if(!is_struct(_res))
		_res = new ExprSymbol("TempSymbol", ExprSymbolTypes.NUMBER, _res)
	else
		_res = SnapDeepCopy(_res);
	return _res;
}

///@desc Expression Evaluator
function expr_eval(_expr) {
	_expr += " ";
	show_debug_message("CAC EXPR "+_expr);
	// Define the priority
	var _prio = ds_map_create();
	_prio[? "!"] = 2;
	_prio[? "*"] = 3;
	_prio[? "/"] = 3;
	_prio[? "%"] = 3;
	_prio[? "+"] = 4;
	_prio[? "-"] = 4;
	_prio[? "<<"] = 5;
	_prio[? ">>"] = 5;
	_prio[? ">" ] = 6;
	_prio[? ">="] = 6;
	_prio[? "<" ] = 6;
	_prio[? "<=" ] = 6;
	_prio[? "==" ] = 7;
	_prio[? "!=" ] = 7;
	_prio[? "&"] = 8;
	_prio[? "^"] = 9;
	_prio[? "|"] = 10;
	_prio[? "&&"] = 11;
	_prio[? "||"] = 12;
	_prio[? "="] = 13;
	
	// Define some ds
	var _stnum = ds_stack_create();
	var _stopt = ds_stack_create();
	
	// start analyze
	var _len = string_length(_expr);
	for(var _i = 1; _i <= _len; _i++) {
		var _ch = string_char_at(_expr, _i);
		if(_ch == " ") continue;
		// If a variable
		if(is_alpha(_ch) || _ch == "_") {
			var _j = _i+1;
			_ch = string_char_at(_expr, _j);
			while(is_alpha(_ch) || _ch == "_" || is_number(_ch) || _ch == ".") {
				_j ++;
				_ch = string_char_at(_expr, _j);
			}
			var _varn = string_copy(_expr, _i, _j - _i);
			ds_stack_push(_stnum, expr_get_sym(_varn));
			_i = _j-1;
		}
		// If a number
		else if(is_number(_ch)) {
			var _j = _i+1;
			_ch = string_char_at(_expr, _j);
			var _subdot = 0;
			while(is_number(_ch) || _ch == ".") {
				_j ++;
				_subdot += (_ch == ".");
				_ch = string_char_at(_expr, _j);
			}
			if(is_alpha(_ch) || _ch == "_")
				throw "Expression error: "+ _expr +" - a variable's name can't start with a number.";
			if(_subdot > 1)
				throw "Expression error: "+ _expr +" - invalid real number."
			var _varn = string_copy(_expr, _i, _j - _i);
			ds_stack_push(_stnum, new ExprSymbol("tempSym", ExprSymbolTypes.NUMBER, _varn));
			_i = _j-1;
		}
		// If a bracket
		else if(_ch == "(") {
			var _j, _now = 1;
			for(_j = _i + 1; _j <= _len; _j ++) {
				_ch = string_char_at(_expr, _j);
				if(_ch == "(") _now++;
				else if(_ch == ")") _now--;
				if(_now==0) break;
			}
			if(_j > _len)
				throw "Expression error: " + _expr + " - Bracket match error.";
			var _nexpr = string_copy(_expr, _i+1, _j-_i-1);
			var _nres = expr_eval(_nexpr);
			ds_stack_push(_stnum, _nres);
			_i = _j;
		}
		// If an operation
		else {
			var _opt = _ch;
			_ch = string_char_at(_expr, _i + 1);
			if(!(is_alpha(_ch) || _ch = "_" || is_number(_ch) || _ch == "(" || _ch == " ")) {
				_i ++ ;
				_opt += _ch;
				_ch = string_char_at(_expr, _i + 1);
				if(!(is_alpha(_ch) || _ch = "_" || is_number(_ch) || _ch == "(" || _ch == " "))	
					throw "Expression error: "+ _expr +" - an unexists operation.";
			}
			if(!ds_map_exists(_prio, _opt))
				throw "Expression error: "+ _expr +" - an unexists operation " + _opt + " .";
				
			
			// Caculation
			while(ds_stack_size(_stopt)>0 && _prio[? _opt] >= _prio[? ds_stack_top(_stopt)]) {
				var _nopt = ds_stack_top(_stopt); ds_stack_pop(_stopt);
				var _na = ds_stack_top(_stnum); ds_stack_pop(_stnum);
				var _ans = new ExprSymbol();
				if(_nopt == "!") {
					_ans = expr_cac(_nopt, _na);
				}
				else {
					var _nb = ds_stack_top(_stnum); ds_stack_pop(_stnum);
					_ans = expr_cac(_nopt, _nb, _na);
				}
				ds_stack_push(_stnum, _ans);
			}
			
			ds_stack_push(_stopt, _opt);
			
		}
	}
	
	while(ds_stack_size(_stopt)>0) {
		var _nopt = ds_stack_top(_stopt); ds_stack_pop(_stopt);
		var _na = ds_stack_top(_stnum); ds_stack_pop(_stnum);
		var _ans = new ExprSymbol();
		if(_nopt == "!") {
			_ans = expr_cac(_nopt, _na);
		}
		else {
			var _nb = ds_stack_top(_stnum); ds_stack_pop(_stnum);
			_ans = expr_cac(_nopt, _nb, _na);
		}
		ds_stack_push(_stnum, _ans);
	}
	
	// Check
	if(ds_stack_size(_stnum)>1)
		throw "Expression error: " + _expr;
	var _res = ds_stack_top(_stnum);
		
	
	// Clean up
	ds_map_destroy(_prio);
	ds_stack_destroy(_stnum);
	ds_stack_destroy(_stopt);
	
	show_debug_message("EXPR " + _expr + " RES "+ string(_res));
	
	return _res;
}

///@desc Execute an expression sequence
function expr_exec(expr_seq) {
	var _seqs = string_split(expr_seq, ";", true);
	var _result = new ExprSymbol();
	for(var i=0, l=array_length(_seqs); i<l; i++) {
		try {
			_result = expr_eval(string_purify(_seqs[i]))
		} catch (e) {
			announcement_error($"表达式执行错误。\n错误信息：{e}\n错误表达式：{_seqs[i]}\n高级操作已中止。");
			return -1;
		}
		// announcement_play($"已执行表达式：${_seqs[i]}");
	}
		
	return 1;
}

function is_alpha(ch) {
	ch=string_lower(ch);
	return in_between(ord(ch), ord("a"), ord("z"))
}

function is_number(ch) {
	return in_between(ord(ch), ord("0"), ord("9"))
}

///@desc Return an string that has no blank in front and end.
function string_purify(_str) {
	while(string_length(_str)>0 && ord(string_char_at(_str, 1))<=32)
		_str = string_delete(_str, 1, 1);
	while(string_length(_str)>0 && ord(string_char_at(_str, string_length(_str)))<=32)
		_str = string_delete(_str, string_length(_str), 1);
	
	//show_debug_message(_str);
	return _str;
}