## SmaCC Directives
%left "*" "/";
%right "^";
%annotate_tokens;
%root Expression;
%prefix AST;
%suffix Node;
%ignore_variables leftParenToken rightParenToken;
	"Parse an statement."

	^ (self on: (ReadStream on: aString))
		setStartingState: self startingStateForstatement;
		parse
%prefix RB;
%suffix Node;
%left "*" "/";
%right "^";