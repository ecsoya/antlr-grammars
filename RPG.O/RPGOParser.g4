/**
 * Antlr4 parser for IBM RPG Language's Output Specification
 */
parser grammar RPGOParser;

 options {
 	tokenVocab = RPGOLexer;
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

 specification: RPG_O (((OS_RECORD_NAME OS_TYPE (osProgramDesc1 | osProgramDesc2)) | osProgramField) | osProgramCompoundDesc) OS_COMMENTS? (EOL | EOF);
 
 osProgramDesc1: OS_FETCH_OVERFLOW outputConditioningOnOffIndicator outputConditioningOnOffIndicator outputConditioningOnOffIndicator OS_EXCEPT_NAME OS_SPACE3 OS_SPACE3 OS_SPACE3 OS_SPACE3 OS_REMAINING_SPACE;
 
 osProgramDesc2: OS_ADD_DEL outputConditioningOnOffIndicator outputConditioningOnOffIndicator outputConditioningOnOffIndicator OS_EXCEPT_NAME OS_REMAINING_SPACE;
 
 osProgramField: OS_FIELD_RESERVED outputConditioningOnOffIndicator outputConditioningOnOffIndicator outputConditioningOnOffIndicator OS_FIELD_NAME OS_EDIT_NAMES OS_BLACK_AFTER OS_END_POSITION OS_DATA_FMT literal?;
 
 osProgramCompoundDesc: OS_AND_OR outputConditioningOnOffIndicator outputConditioningOnOffIndicator outputConditioningOnOffIndicator OS_EXCEPT_NAME OS_REMAINING_SPACE;
 
 outputConditioningOnOffIndicator: onOffIndicatorsFlag outputConditioningIndicator;
 
 onOffIndicatorsFlag: BLACK_FLAG | NO_FLAG;
 
 outputConditioningIndicator: INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_FUNC_KEY | INDICATOR_CONTROL_LEVEL | INDICATOR_HALT | INDICATOR_EXTERNAL | INDICATOR_OVERFLOW | INDICATOR_MATCHING_RECORD | INDICATOR_RETURN | INDICATOR_FIRST_PAGE;
 
 literal: StringLiteralStart
	content=(StringContent | StringEscapedQuote )* StringLiteralEnd;
 
 