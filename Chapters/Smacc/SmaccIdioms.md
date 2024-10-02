## Grammar Idioms
<whitespace> : \s+;

%root Line;
%prefix SmaccTutorial;

Line 
	: <a> 'line' {{}}
	| Line <a> 'line' {{}}
	;
	:
	| Line <a> 'line' {{}}
	;
	: {{}}
	| Line <a> 'line' {{}}
	;
<whitespace>:  (\x20|\xA0|\r)* ;

%root Root;
%prefix SmaccTutorial;
%annotate_tokens;

ParameterList
    : Parameter 'param' {{}}
    | ParameterList 'param' Parameter 'param' {{}}
    ;

Parameter
    : <name> {{}}
    ;
    : Parameter 'param' {{}}
    | ParameterList Parameter 'param' {{}}
    ;
<whitespace>:  (\x20|\xA0|\r)* ;

%root Root;
%prefix SmaccTutorial;
%annotate_tokens;

ParameterList
    : Parameter 'params' + {{}}
    ;

Parameter
    : <name> {{}}
    ;
<whitespace>:  (\x20|\xA0|\r)* ;

%root Root;
%prefix SmaccTutorial;
%annotate_tokens;

NameList
	: ( Name 'n' ( ","  Name 'n' ) *)? {{}}
	;

Name
	: <name>
	;
	: ( Name 'n1' ( ","  Name 'n2' ) *)? {{}}
	;
	:    {{}}
	|  NonEmptyNameList 
	;
	
NonEmptyNameList	
	: Name 'name' {{}}
	| NonEmptyNameList  "," Name 'name' {{}} 
	;

Name
	: <name> {{ }}
	;
	:  
	|  NonEmptyNameList 
	;
	:    {{}}
	|  NonEmptyNameList 
	;