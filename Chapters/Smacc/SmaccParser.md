## SmaCC Parser
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
<whitespace>: \s+ ;

ParameterList
	: Parameter
	| ParameterList Parameter
	;
	
Parameter
	: <name>
	;
<whitespace>: \s+ ;

ParameterList
	: Parameter +
	;
	
Parameter
	: <name>
	;