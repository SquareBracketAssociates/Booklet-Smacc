## Grammar Idioms@cha:idiomsIn this chapter, we share some coding idioms for grammars that help create morecompact ASTs.### Managing ListsSmacc automatically determines if the production rules contain a recursion that represents a list.In such case, it adds an `s` to the name of the generated instance variable and manages it as a list.Let us take an example.```<a> : a;
<whitespace> : \s+;

%root Line;
%prefix SmaccTutorial;

Line 
	: <a> 'line' {{}}
	| Line <a> 'line' {{}}
	;```Here we see that Line is recursive. Smacc will generate a class `SmaccTutorialLine` with an instance variable `lines` initialized as an ordered collection.Note that, if the right-hand-side of a rule is completely empty, SmaCC does not recognise the list.```Line 
	:
	| Line <a> 'line' {{}}
	;```To avoid the empty right-hand-side, you should write this as follows:```Line
	: {{}}
	| Line <a> 'line' {{}}
	;```### Using ShortcutsYou may prefer to define your lists using the shortcuts question mark \(`?`\) for 0 or 1 occurrences, star \(`*`\) for 0 or more, and plus \(`+`\) for 1 or more, rather than with recursion.Let's compare the two approaches.Let's look at a grammar that defines a parameter list recursively.```<name> :  [a-zA-Z] [a-zA-Z0-9_']*;
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
    ;```If the above grammar is used to parse a list of three names, it will generate an AST node class called `SmaccTutorialParameterList` with a `params` instance variable that holds an ordered collection.However, the contents of the ordered collection will _not_ be the three parameters.Instead, the collection will have _two_ elements: a parameter list \(which will contain an ordered collection of two parameters\), and a parameter that contains the third.Why? Because that's what the grammar specifies!There is a trick that will instead generate a collection of three elements: remove the name `'param'` from after the recursive appearace of the non-terminal `ParameterList` in the second alternative for `ParameterList`:```ParameterList
    : Parameter 'param' {{}}
    | ParameterList Parameter 'param' {{}}
    ;```Now you will get a collection `params` containing _all_ the parameters.You can also specify the same language using `+`, like this:```<name> :  [a-zA-Z]  ([a-zA-Z]  | [0-9] | _ | ')*;
<whitespace>:  (\x20|\xA0|\r)* ;

%root Root;
%prefix SmaccTutorial;
%annotate_tokens;

ParameterList
    : Parameter 'params' + {{}}
    ;

Parameter
    : <name> {{}}
    ;```Not only is this grammar easier to read, but the generated AST will contain a single collection of parameters.If you parse three names, the result will be a `SmaccTutorialParameterList` object that contains an instance variable `params` that will be initialized to be an `OrderedCollection` of three `SmaCCTutorialParameter` nodes.In a similar way, if you use a `*`, you will get an ordered collection containing zero or more items.However, if you use a `?`, you don't get a collection: you get either `nil` \(if the item was absent\), or the generated node \(if it was present\).### Expressing Optional FeaturesOften, lists contain separators, which makes specifying them a little more complex.Here is a grammar in which lists of names can be of arbitrary length, but the list items must be separated with commas.It expresses this with the `?` shortcut.```<name> :  [a-zA-Z]  ([a-zA-Z]  | [0-9] | _ | ')*;
<whitespace>:  (\x20|\xA0|\r)* ;

%root Root;
%prefix SmaccTutorial;
%annotate_tokens;

NameList
	: ( Name 'n' ( ","  Name 'n' ) *)? {{}}
	;

Name
	: <name>
	;```SmaCC recognizes this idiom, and will generate an ordered collection of zero or more names.If you want this behaviour, it is important to use the same instance variable name \(here `n`\) for both the base case and the `*` repetition.If you use different names,```NameList
	: ( Name 'n1' ( ","  Name 'n2' ) *)? {{}}
	;```then the generated node will have two instance variables:  `n1` will be either `nil` \(if the input list is empty\) or will contain the first `Name` \(if it is not\), while `n2s` will be a collection containing the remaining Names \(zero when the input list has length one\).If you prefer not to use the `*` and `?` shortcuts \(or are using a verison of SmaCC that does not support them\), you can get the same effect using recursion:```NameList
	:    {{}}
	|  NonEmptyNameList 
	;
	
NonEmptyNameList	
	: Name 'name' {{}}
	| NonEmptyNameList  "," Name 'name' {{}} 
	;

Name
	: <name> {{ }}
	;```Once again, note that no name is given to the recursive use of `NonEmptyNameList`.In general, empty alternatives will be represented as `nil`.This avoids generating many useless objects.```NameList
	:  
	|  NonEmptyNameList 
	;````NameList` will return nil when it matches the empty input.If instead you want an empty `NameList` node, use `{{}}` for the empty alternative:```NameList
	:    {{}}
	|  NonEmptyNameList 
	;```