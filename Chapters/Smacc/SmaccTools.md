## Debugging and Testing
	((YourParser on: (ReadStream on: str)) setStartingState: YourParser startingStateForexpression) parse.
	"Parse an statement."

	^ (self on: (ReadStream on: aString))
		setStartingState: self startingStateForexpression;
		parse