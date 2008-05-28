module sendero.view.expression.Compile;

import sendero_base.Core;
import sendero.vm.Expression2;

import sendero_base.util.collection.Stack;
import Integer = tango.text.convert.Integer;
import Float = tango.text.convert.Float;

debug import tango.io.Stdout;

void error(char[] msg)
{
	throw new Exception(msg);
}

%%{
machine sendero_view_compile;

access fsm.;

action emit { Stdout(fc).newline; }

action do_start_token {fsm.tokenStart = fpc;}
action do_start_string {fsm.tokenStart = fpc + 1;}

action do_end_id {
	Op op;
	op.key = fsm.tokenStart[0 .. fpc - fsm.tokenStart];
	
	if(fsm.opSt.empty || fsm.opSt.top != OpT.Dot) {
		op.op = Op.Root;
	}
	else {
		op.op = Op.Key;
	}
	fsm.expr ~= op;
	
	fsm.opSt.pop;
	
	debug Stdout.formatln("Found identifier: {}", op.key);
}

action do_end_number {
	Stdout.formatln("Found number: {}", fsm.tokenStart[0 .. fpc - fsm.tokenStart]);
}

action do_end_string {
	Stdout.formatln("Found string: {}", fsm.tokenStart[0 .. fpc - fsm.tokenStart]);
}


action do_dot_step {
	fsm.opSt.push(OpT.Dot);
	debug Stdout("Found dot step").newline;
}
action do_index_step { Stdout("Found index step").newline; }
action do_function_call {
	fsm.opSt.push(OpT.Paren);
	Stdout("Found function call").newline;
}

action do_open_paren {
	fsm.opSt.push(OpT.Paren);
}
action do_close_paren {
	while(!fsm.opSt.empty && fsm.opSt.top != OpT.Paren) {
		fsm.expr ~= Op(fsm.opSt.top);
		fsm.opSt.pop;
	}
	//fgoto end_call;
}

action do_comma {
	while(!fsm.opSt.empty && fsm.opSt.top != OpT.Paren) {
		fsm.expr ~= Op(fsm.opSt.top);
		fsm.opSt.pop;
	}
}

action do_add {	doOp(fsm, OpT.Add); }
action do_sub {	doOp(fsm, OpT.Sub); }

action do_mul {	doOp(fsm, OpT.Mul); }
action do_div {	doOp(fsm, OpT.Div); }
action do_mod {	doOp(fsm, OpT.Mod); }

c_comment = ( any )* :>> '*/' @{ debug Stdout("Found comment.").newline; };

Expression = 
		
start:(
	[a-zA-Z_] @do_start_token -> identifier |
	[0-9] @do_start_token -> number |
	
	"(" @do_open_paren -> start |
	
	["] @do_start_string -> dquote_str |
	['] @do_start_string -> squote_str |
	[`] @do_start_string -> backtick_str |
	
	'/*' c_comment -> start |
	
	space+ -> start
),

div: (
	"*" c_comment -> operator |
	[^*] @do_div @{ fhold; } -> start
)

operator: (
	"]" -> end_call |
	
	")" @do_close_paren -> end_call |
	
	"," @do_comma -> start |
	
	"+" @do_add -> start |
	"-" @do_sub -> start |
	"/"  -> div |
	"*" @do_mul -> start |
	"%" @do_mod -> start |
	
	"<" -> start |
	"<=" -> start |
	"=>" -> start |
	">" -> start |
	
	"==" -> start |
	"!=" -> start |
	
	"&&" -> start |
	"||" -> start |
	
	space+ -> operator
),

identifier: (
	[a-zA-Z_0-9] -> identifier |
	
	[^a-zA-Z_0-9] @do_end_id @{fhold;} -> end_call
),

end_call: (
	"." @do_dot_step -> start |
	
	"[" @do_index_step -> start |
	
	"(" @do_function_call -> start |
	
	[^\.[(] @{fhold;} -> operator
),

number: (
	[0-9\.] -> number |
	[^0-9\.] @do_end_number @{fhold;} -> operator
),

dquote_str: (
	[^"\\] -> dquote_str |
	[\\] @{ ++fpc; } -> dquote_str |
	["] @do_end_string -> operator
	
),

squote_str: (
	[^\'\\] -> squote_str |
	[\\] @{ ++fpc; } -> squote_str |
	['] @do_end_string -> operator
	
),

backtick_str: (
	[^`] -> backtick_str |
	[`] @do_end_string -> operator
	
)
;

main := Expression;
	
	
}%%

%% write data;

/+
struct ExprState
{
	enum { None = 0, Access, Binary };
	int state = None;
	
	union
	{
		VarAccess acc;
		BinaryExpression binary;
	}
}
alias ExprState State;
+/

enum OpT {
	Add = Op.Add,
	Sub = Op.Sub,
	Mul = Op.Mul,
	Div = Op.Div,
	Mod = Op.Mod,
	
	//ExprParen,
	//FuncParen,
	Paren,
	Dot,
	Index
};

void doOp(Fsm fsm, OpT op)
{
	debug Stdout.formatln("Found operator: {}", op);
	if(!fsm.opSt.empty && fsm.opSt.top <= precedence.length) {
		if(precedence[fsm.opSt.top] < precedence[op]) {
			fsm.opSt.push(OpT.Add);
		}
		else {
			fsm.expr ~= Op(fsm.opSt.top);
			fsm.opSt.pop;
			fsm.opSt.push(op);
		} 
	}
	else fsm.opSt.push(op);
}


class Fsm
{
	this()
	{
		opStack = new Stack!(OpT);
	}

	int cs = 0;
	int* stack;
	int top;
	char* tokenStart;
	
	Expr expr;
	Stack!(OpT) opStack;
	alias opStack opSt;
}

size_t parse(char[] src)
{
	auto fsm = new Fsm;
	char* p = src.ptr;
	char* pe = p + src.length + 1;
	char* eof = pe;
	%% write init;
	%% write exec;
	
	return p - src.ptr;
}

debug(SenderoUnittest)
{

unittest
{
	parse("x + y");
	
	Stdout.newline;
	
	parse("test.one[/* a comment */ test2] + test3(param1) /*another comment*/ - test4[step](param2)[5]['a str'] ");
	
	Stdout.newline;
	
	parse("`test1` + \"test \\\"2\" + 'test3'");
	
	Stdout.newline;
	
	bool caught = false;
	try
	{
		parse(" test)");
	}
	catch(Exception ex)
	{
		caught = true;
	}
//	assert(caught);

	assert(parse("test; STRING") == 4);
}

}

/+

+ -
* /

5 + 7 * 3 / 7 + 1

lhs mhs rhs
if(lhs) {
	if(lhs.op.precedence < cur.precendence) {
		*pRhs = curAtom;
		lhs = new BinaryExpression(cur)(lhs, null);
		pRhs = &lhs.rhs;
	}
	else {
		if(pRhs.op.precendence < cur.precedence) {
			*pRhs = new BinaryExpression(curAtom, null);
		}
		else {
			pRhs = &lhs.rhs.rhs;
		}
	}
}
else {
	lhs = new BinaryExpression(curAtom, null);
	pRhs = &lhs.rhs;
}


+/