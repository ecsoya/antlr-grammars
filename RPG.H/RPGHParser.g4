/**
 * Antlr4 parser for IBM RPG Language's Control Specification
 */
parser grammar RPGHParser;

 options {
 	tokenVocab = RPGHLexer;
 }

 r
 :
 	(
 		statement
 		| blackLine
 		| starComments
 	)* endSource*
 ;

 //End of source, start with ** or EOF

 endSource
 :
 	endSourceHead endSourceLine*
 ;

 endSourceHead
 :
 	END_SOURCE
 ;

 endSourceLine
 :
 	EOS_Text
 	(
 		EOL
 		| EOF
 	)
 ;

 //Black line from column 6

 blackLine
 :
 	BLACK_LINE
 ;

 //Comments begin with *

 starComments
 :
 	COMMENT_SPEC_FIXED comments?
 ;

 comments
 :
 	COMMENT_TEXT
 ;

 statement
 :
 	specification
 ;

 //Control Specification

 specification
 :
 	HS_INDICATOR expression*
 	(
 		EOL
 		| EOF
 	)
 ;

 //Control Specification Expression

 expression
 :
 	(
 		ID
 		(
 			OPEN_PAREN
 			(
 				parameter
 				(
 					COLON parameter
 				)*
 			)? CLOSE_PAREN
 		)?
 	)
 ;

 //Control Specification parameter of expression

 parameter
 :
 	ID
 	| string
 	| symbolicConstants
 ;

 string
 :
 	StringLiteralStart
 	(
 		StringContent
 		| StringEscapedQuote
 	)* StringLiteralEnd
 ;

 symbolicConstants
 :
 	OPTION_EXT
 	| OPTION_NO
 	| OPTION_NONE
 	| OPTION_SRC
 	| OPTION_YES
 ;

