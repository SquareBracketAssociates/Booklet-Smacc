## SmaCC Transformations



Once you have generated a parser for your language, you can use SmaCC to transform programs written in your language.
Note that the output from the transformation phase is the text of a program \(which may be in the input language or another language\) and not a parse tree.


### Defining Transformations 

Let's add support for transforming the simple expression language of our calculator example.
The basic idea is to define _patterns_ that match subtrees of the grammar and specify how these subtrees should be rewritten.

We start by extending our grammar with two additional lines.

The first line defines how we will write a pattern in our grammar.
SmaCC has a small built-in pattern syntax: it is in fact the language of your grammar plus metavariables.
Metavariables will hold the matching subtree after the pattern-matching part of the transformation.
To identify a metavariable, your scanner should define the `<patternToken>`: SmaCC uses this token to define metavariables.

For our example language, we will define a metavariable as anything enclosed by \`\` characters (e.g., \`\`pattern\`\`).
Note that this token, despite its special behavior, is still valid in the scanner and thus should not conflict with other token definitions.

The second line we need to add tells SmaCC to generate a GLR parser \(`%glr;`\).
This allows SmaCC to parse _all possible_ representations of a pattern expression, rather than just one.

Here is our grammar with these two additions.

```
	<number> : [0-9]+ (\. [0-9]*) ? ;
	<name> : [a-zA-Z]\w*;
	<whitespace> : \s+;

+	<patternToken> : \` [^\`]* \` ;
+	%glr;

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
```


And that is the only two things you need to do to activate the Rewrite Engine for your new language.


### Pattern matching Expressions


Having made these changes, we can now define _rewrite rules_ that specify how certain subtrees in the AST should be matched \(the pattern\) and how their substrings should be replaced \(the transformation\). 
Patterns look like normal code from your language, but may include metavariables that are delimited by the `<patternToken>`. 

For example, `\`a + 1` is a pattern that matches any expression followed by `+ 1`. 
The metavariable is `\`a`. When the pattern matches, `a` will be bound to the AST node of the expression that is followed by `+1`.

To rewrite the matches of the pattern in our program, we must supply a transformation, which can contain the metavariables present in the pattern.
A crucial distinction is that the metavariables are now instantiated with their corresponding to their matched subtree.
After the transformation, a new string is returned with the program appropriately rewritten where the pattern was matched.  

For example, if we are searching for the pattern `\`a + 1`, we can supply a replacement expression like `1 + \`a`.
This pattern will match `(3 + 4) + 1`.
When we perform the replacement we take the literal `1 + ` part of the string and append the source that was parsed into the subtree that matched `a`.
In this case, this is `(3 + 4)`, so the replacement text will be `1 + (3 + 4)`.


### Example


As an example, let's rewrite additions into reverse Polish notation.
Our search pattern is `\`a + \`b` and our replacement expression is `\`a \`b +`.

```
| rewriter compositeRewrite rewrite matcher transformation |
compositeRewrite := SmaCCRewriteFile new.
compositeRewrite parserClass: CalculatorParser.
matcher := SmaCCRewriteTreeMatch new.
matcher source: '`a` + `b`'.
transformation := SmaCCRewriteStringTransformation new.
transformation string: '`a` `b` +'.
rewrite := SmaCCRewrite 
	comment: 'Postfix rewriter' 
	match: matcher
	transformation: transformation.
compositeRewrite addTransformation: rewrite.
rewriter := SmaCCRewriteEngine new.
rewriter rewriteRule: compositeRewrite.
rewriter rewriteTree: (CalculatorParser parse: '(3 + 4) + (4 + 3)')
```

This code rewrites `(3 + 4) + (4 + 3)` in RPN format and returns `3 4 + 4 3 + +`.
The first match that this finds is `a` = `(3 + 4)` and `b` = `(4 + 3)`.

Inside our replacement expression, we refer to `\`a` and `\`b`, so we first process those expressions for more transformations.
Since both contain other additions, we rewrite both expressions to get `a` = `3 4 +` and `b` = `4 3 +`.

Here's the same example, using SmaCC's special, albeit small rewrite syntax.

```
| rewriter rewriteExpression |
rewriteExpression := 
	'Parser: CalculatorParser
		>>>`a` + `b`<<<
		->
		>>>`a` `b` +<<<'.
rewriter := SmaCCRewriteEngine new.
rewriter rewriteRule: (SmaCCRewriteRuleFileParser parse: rewriteExpression).
rewriter rewriteTree: (CalculatorParser parse: '(3 + 4) + (4 + 3)')
```

Note that when you use the same name for multiple metavariables in a pattern, all of these must be equal.
As an example `\`i` + \`i` will only match addition for which the two operands are the same nodes.


### Parametrizing Transformations

Let's extend our RPN rewriter to support other expressions besides addition.
We could do that by providing rewrites for all possible operators \(+, -, *, /, \^\), but it would be better if we could do it with a pattern.
You might think that we could use `\`a \`op \`b`, but patterns like `\`op` will match only expressions corresponding to grammar non-terminals, and not tokens like `(+)`.
We can tell SmaCC to allow `\`op` to  match tokens by using `\`a \`op{beToken} \`b`. Here's the rewrite that works for all arithmetic expressions of the calculator language.

```
Parser: CalculatorParser
>>>`a` `op{beToken}` `b`<<<
->
>>>`a` `b` `op`<<<
```


If we transform `(3 + 4) * (5 - 2) ^ 3`, we'll get `3 4 + 5 2 - 3 ^ *`.
Notice that SmaCC has performed three transformations using the same pattern-matching rule.


### Restrictions and Limitations

At present, SmaCC's rewriting facility can generate only text, not parse trees.
In other words, although you can and should think of SmaCC's rewrites as matching a parse tree,
they cannot produce a modified parse tree, only modified source code.
However, if you want to write node rewrites in Smalltalk, `SmaCCParseNode` has some useful primitives to replace or add nodes to the tree.
