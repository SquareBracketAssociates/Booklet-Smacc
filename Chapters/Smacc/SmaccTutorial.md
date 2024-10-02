## A First SmaCC Tutorial
	"By default, eat the whitespace"

	self resetScanner.
	^ self scanForToken
	comments add: (Array with: start + 1 with: matchEnd).
	^ self whitespace
	: Expression "+" Number
	| Number
	;
Number 
	: <number>
	;
	: Expression "+" Number {'1' + '3'}
	| Number {'1'}
	;
Number 
	: <number> {'1' value asNumber}
	;
	: Expression 'expression' "+" Number 'number' {expression + number}
	| Number 'number' {number}
	;
Number 
	: <number> 'numberToken' {numberToken value asNumber}
	;
	: Expression 'expression' "+" Number 'number' {expression + number}
	| Expression 'expression' "-" Number 'number' {expression - number}
	| Number 'number' {number}
	;
Number 
	: <number> 'numberToken' {numberToken value asNumber}
	;
	: Expression 'expression' "+" Number 'number' {expression + number}
	| Expression 'expression' "-" Number 'number' {expression - number}
	| Expression 'expression' "*" Number 'number' {expression * number}
	| Expression 'expression' "/" Number 'number' {expression / number}
	| Number 'number' {number}
	;
Number 
	: <number> 'numberToken' {numberToken value asNumber}
	;
	: Term 'term' {term}
	| Expression 'expression' "+" Term 'term' {expression + term}
	| Expression 'expression' "-" Term 'term' {expression - term}
	;
Term 
	: Number 'number' {number}
	| Term 'term' "*" Number 'number' {term * number}
	| Term 'term' "/" Number 'number' {term / number}
	;
Number 
	: <number> 'numberToken' {numberToken value asNumber}
	;
%left "*" "/";

Expression 
	: Expression 'exp1' "+" Expression 'exp2' {exp1 + exp2}
	| Expression 'exp1' "-" Expression 'exp2' {exp1 - exp2}
	| Expression 'exp1' "*" Expression 'exp2' {exp1 * exp2}
	| Expression 'exp1' "/" Expression 'exp2' {exp1 / exp2}
	| Number 'number' {number}
	;
Number 
	: <number> 'numberToken' {numberToken value asNumber}
	;
<whitespace> : \s+;
%left "+" "-";
%left "*" "/";
%right "^";

Expression 
	: Expression 'exp1' "+" Expression 'exp2' {exp1 + exp2}
	| Expression 'exp1' "-" Expression 'exp2' {exp1 - exp2}
	| Expression 'exp1' "*" Expression 'exp2' {exp1 * exp2}
	| Expression 'exp1' "/" Expression 'exp2' {exp1 / exp2}
	| Expression 'exp1' "^" Expression 'exp2' {exp1 raisedTo: exp2}
	| "(" Expression 'expression' ")" {expression}
	| Number 'number' {number}
	;
Number 
	: <number> 'numberToken' {numberToken value asNumber}
	;