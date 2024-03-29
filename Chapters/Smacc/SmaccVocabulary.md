## Vocabulary


This chapter defines some vocabulary used by Smacc. 


### Reference Example 


Let us take the following grammar. 

```
<number> : [0-9]+ (\. [0-9]*) ? ;
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
```



### Metagrammar structure


SmaCC grammars are written in EBNF format \(Extended Backus-Naur Form\) with a syntax resembling closely to the one of GNU Bison.
A grammar is composed of:

- Scanner rules: they define tokens to recognize in the input stream through regex,
- Parser rules: they define the production rules of your grammar,
- Directives: they are additional information for the parsing or for the AST generation.


Note that you can also find the metagrammar of SmaCC described in itself in the `SmaCCDefinitionParser`.


### Elements 



#### Production rule


The following expressions define two production rules. 

```
Expression 
	: Expression 'left' "+" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "-" 'operator' Expression 'right' {{Binary}}
	;

Number 
	: <number> {{Number}}
	;
```


A production rule is defined by a left-hand side and several alternatives.
- Here the first production rule has two alternatives.
- While the second production rule has only one. 


An alternative can be composed of any variation of:
- non-terminals often start with uppercase
- scanner tokens
- keywords \(delimited by `"`\)


In addition, you can use the single curly braces `{}` to define an arbitrary semantic action or the double curly braces `{{}}` to create an AST node instead.
Non terminals and tokens can be annotated with variable names \(delimited by `'`\) which will be the instance variable names of the AST node.


#### Tokens


Tokens are identified by the scanner. 
A token specification is composed of a token name and a token regular expression.

```
<TokenName>    :    RegularExpression ;
```


The following token specification describes a number.
It starts with one or more digits, possibly followed by a decimal point with zero or more digits after it. 
The scanner definition for this token is:

```
<number>        :       [0-9]+ (\. [0-9]*) ? ;
```


Let's go over each part:



`<number>`
Names the token identified by the expression. The name inside the <> must be a legal Pharo variable name.

`:`
Separates the name of the token from the token's definition.

`[0-9]`
Matches any single character in the range `'0'` to `'9'` \(a digit\). We could also use `\d` or `<isDigit>` as these also match digits.

`+`
Matches the previous expression one or more times. In this case, we are matching one or more digits.

`( ... )`
Groups subexpressions. In this case, we are grouping the decimal point and the numbers following the decimal point.

`\.`
Matches the '.' character \(. has a special meaning in regular expressions,  quotes it\).

`*`
Matches the previous expression zero or more times.

`?`
Matches the previous expression zero or one time \(i.e., it is optional\).

`;`
Terminates a token specification.


#### Keywords


Keywords are defined in the production and delimited by `"`. 
Keywords are only defined through static strings, regular expressions cannot be used.
In the following example, `"+"` and `"-"` are considered keywords.

```
Expression 
	: Expression 'left' "+" 'operator' Expression 'right' {{Binary}}
	| Expression 'left' "-" 'operator' Expression 'right' {{Binary}}
	;
```



#### Non Terminal


In the production rule `Expression 'left' "+" 'operator' Expression 'right'`, Expression is a non-terminal.


#### Variables


Variables give name to one element of a production.
For example 

```
Expression 'left' "^" 'operator' Expression 'right'
```


- 'left' and 'right' denote the first and second expressions of the alternative.
- 'operator' denotes the caret token. 

