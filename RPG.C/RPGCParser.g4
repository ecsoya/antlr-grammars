/**
 * Antlr4 parser for IBM RPG Language's Calculation Specification
 */
parser grammar RPGCParser;

 options {
 	tokenVocab = RPGCLexer;
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

 specification: RPG_C controlLevel indicatorOff = onOffIndicatorsFlag indicators factor1 = factor (calcStandardParts | calcExtendedFactor2Parts);
  
 onOffIndicatorsFlag: BLACK_FLAG | NO_FLAG;
 
 calcStandardParts: csACQ | (operation = CS_OPERATION_EXTENDER  operationExtender? calcFactor2Parts);
 
 csACQ: operation=OP_ACQ operationExtender? ;
 
 calcFactor2Parts: factor2 = factor result = resultType length = CS_FIELD_LENGTH decimalPositions = CS_DECIMAL_POSITIONS hi = resultIndicator lo = resultIndicator eq = resultIndicator csComments? (EOL | EOF);
 
 resultType: CS_FACTOR_CONTENT (COLON (constant = symbolicConstants))? | CS_BLACK_FACTOR;
 
 csComments: CS_FIXED_COMMENTS;
 
 calcExtendedFactor2Parts: operationExtender? expression ;
 
 resultIndicator: INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_FUNC_KEY | INDICATOR_HALT | INDICATOR_CONTROL_LEVEL | INDICATOR_LAST_RECORD | INDICATOR_OVERFLOW | INDICATOR_RETURN;
 
 controlLevel: INDICATOR_BLACK | INDICATOR_CONTROL_LEVEL_0 | INDICATOR_CONTROL_LEVEL | INDICATOR_LAST_RECORD | INDICATOR_SUBROUTINE | INDICATOR_AND | INDICATOR_OR;
 
 indicators: INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_FUNC_KEY | INDICATOR_CONTROL_LEVEL | INDICATOR_LAST_RECORD | INDICATOR_MATCHING_RECORD | INDICATOR_HALT | INDICATOR_RETURN | INDICATOR_EXTERNAL | INDICATOR_OVERFLOW;
 
 factor: content = factorContent (COLON (content2 = factorContent | constant2 = symbolicConstants))? | CS_BLACK_FACTOR | constant = symbolicConstants literal?;
 
 factorContent: CS_FACTOR_CONTENT | literal;
 
 operationExtender: OPEN_PAREN CS_OPERATION_EXTENDER CLOSE_PAREN;
 
 symbolicConstants: SPLAT_ALL | SPLAT_YMD;
 
 literal: StringLiteralStart
	content=(StringContent | StringEscapedQuote )* StringLiteralEnd;
	
 expression:;
 