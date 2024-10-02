## SmaCC Abstract Syntax Trees
<whitespace> : \s+;

%left "+" "-";
%left "*" "/";
%right "^";

Expression 
	: Expression "+" Expression 
	| Expression "-" Expression
	| Expression "*" Expression
	| Expression "/" Expression
	| Expression "^" Expression
	| "(" Expression ")"
	| Number
	;
Number 
	: <number>
	;
<whitespace> : \s+;

%left "+" "-";
%left "*" "/";
%right "^";

Expression 
	: Expression "+" Expression {{Binary}}
	| Expression "-" Expression {{Binary}}
	| Expression "*" Expression {{Binary}}
	| Expression "/" Expression {{Binary}}
	| Expression "^" Expression {{Binary}}
	| "(" Expression ")" {{}}
	| Number
	;
Number 
	: <number> {{Number}}
	;
<whitespace> : \s+;

%left "+" "-";
%left "*" "/";
%right "^";
%annotate_tokens;

Expression 
	: Expression 'left' "+" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "-" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "*" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "/" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "^" 'operator' Expression 'right' {{Binary}}
	| "(" Expression ")" {{}}
	| Number
	;
Number 
	: <number> {{Number}}
	;
<whitespace> : \s+;

%left "+" "-";
%left "*" "/";
%right "^";

%annotate_tokens;
%root Expression;
%prefix AST;
%suffix Node;

Expression 
	: Expression 'left' "+" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "-" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "*" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "/" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "^" 'operator' Expression 'right' {{Binary}}
	| "(" Expression ")" {{}}
	| Number
	;
Number 
	: <number> {{Number}}
	;
<name> : [a-zA-Z]\w*;
<whitespace> : \s+;

%left "+" "-";
%left "*" "/";
%right "^";
%annotate_tokens;
%root Expression;
%prefix AST;
%suffix Node;

Expression 
	: Expression 'left' "+" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "-" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "*" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "/" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "^" 'operator' Expression 'right' {{Binary}}
	| "(" Expression ")" {{}}
	| Number
	| Function
	;
Number 
	: <number> {{Number}}
	;
Function
	: <name> "(" 'leftParen' (Expression 'argument' ("," Expression 'argument')* )? ")" 'rightParen' {{}}
	;
<name> : [a-zA-Z]\w*;
<whitespace> : \s+;

%left "+" "-";
%left "*" "/";
%right "^";
%annotate_tokens;
%root Expression;
%prefix AST;
%suffix Node;
%ignore_variables leftParenToken rightParenToken;

Expression 
	: Expression 'left' "+" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "-" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "*" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "/" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "^" 'operator' Expression 'right' {{Binary}}
	| "(" Expression ")" {{}}
	| Number
	| Function
	;
Number 
	: <number> {{Number}}
	;
Function
	: <name> "(" 'leftParen' (Expression 'argument' ("," Expression 'argument')* )? ")" 'rightParen' {{}}
	;
	instanceVariableNames: 'functions'
	classVariableNames: ''
	package: 'SmaCC-Tutorial'.
	^functions
		ifNil: 
			[functions := (Dictionary new)
						at: 'Add' put: [:a :b | a + b];
						yourself ].
	| left right operation |
	left := self acceptNode: aBinary left.
	right := self acceptNode: aBinary right.
	operation := aBinary operator value.
	operation = '^' ifTrue: [ ^left ** right ].
	^left perform: operation asSymbol with: right.
	| function arguments |
	function := self functions at: aFunction nameToken value
				ifAbsent: 
					[self error: 'Function ' , 
						aFunction nameToken value , 
						' is not defined' ].
	arguments := aFunction arguments collect: [ :each | self acceptNode: each ].
	^function valueWithArguments: arguments asArray.
	^ aNumber numberToken value asNumber.