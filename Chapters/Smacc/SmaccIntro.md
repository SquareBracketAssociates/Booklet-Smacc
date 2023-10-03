## About this Booklet


This booklet describes SmaCC, the Smalltalk Compiler-Compiler originally developed by John Brant. 

### Contents

It contains:
- A tutorial originally written by John Brant and Don Roberts and adapted to Pharo.
- Syntax to declare Syntax trees.
- Details about the directives.
- Scanner and Parser details.
- Support for transformations.
- Idioms: Often we have recurring patterns and it is nice to document them.


SmaCC was ported to Pharo by Thierry Goubier, who maintains the SmaCC Pharo port.
SmaCC is used in production systems; for example, it supports the automatic conversion from Delphi to C#. 

SmaCC is a really strong and stable library that is used in production for many years.
It is an essential asset for dealing with languages. Smacc offers speed and traditional parsing technology.


### Obtaining SmaCC

 
If you haven't already done so, you will need to load SmaCC.  Execute this code in a Pharo playground:

```
Metacello new
	baseline: 'SmaCC';
	repository: 'github://j-brant/Smacc';
	load
```


### Basics

The compilation process comprises of two phases: scanning \(sometimes called lexing or lexical analysis\) and parsing \(which usually covers syntax analysis and semantic analysis\).
Scanning converts an input stream of characters into a stream of _tokens_.
These tokens form the input to the parsing phase.
Parsing converts the stream of tokens into some object: exactly _what_ object is determined by you, the user of SmaCC.
