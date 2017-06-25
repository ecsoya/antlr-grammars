/**
 * Antlr4 parser for IBM RPG Language's Input Specification
 */
parser grammar RPGIParser;

 options {
 	tokenVocab = RPGILexer;
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

 //Input Specification

 specification
 :
 	RPG_I (isRecordSpec | isFieldSpec | isExternalRecordSpec | isExternalFieldSpec) (EOL | EOF);
 
 isRecordSpec: IS_FILE_NAME IS_SEQUENCE IS_NUMBER IS_OPTION recordIdIndicator IS_RECORD_ID_CODE; 
 
 isFieldSpec: ISFLD_DATE_FMT_EXT ISFLD_DATE_SEPARATOR ISFLD_DATE_FMT ISFLD_FIELD_LOCATION ISFLD_DECIMAL_POSITIONS ISFLD_FIELD_NAME ISFLD_CONTROL_LEVEL ISFLD_MATCHING_FIELDS fieldRecordRelation fieldIndicator fieldIndicator fieldIndicator ISFLD_COMMENETS?;
 
 isExternalRecordSpec: IS_FILE_NAME IS_EXTERNAL_RECORE_RESERVED resultIndicator WS?;
 
 isExternalFieldSpec: ISEXTFLD_NAME ISEXTFLD_FIELD_NAME controlLevelIndicator matchingFieldsIndicator resultIndicator resultIndicator resultIndicator;
 
 recordIdIndicator:INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_HALT | INDICATOR_CONTROL_LEVEL | INDICATOR_LAST_RECORD | INDICATOR_EXTERNAL | INDICATOR_RETURN;
 
 fieldIndicator: INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_CONTROL_LEVEL | INDICATOR_HALT | INDICATOR_EXTERNAL | INDICATOR_RETURN;
 
 resultIndicator: INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_CONTROL_LEVEL | INDICATOR_FUNC_KEY | INDICATOR_LAST_RECORD | INDICATOR_MATCHING_RECORD | INDICATOR_HALT | INDICATOR_EXTERNAL | INDICATOR_OVERFLOW | INDICATOR_RETURN;
 
 fieldRecordRelation: INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_CONTROL_LEVEL | INDICATOR_MATCHING_RECORD | INDICATOR_EXTERNAL | INDICATOR_HALT | INDICATOR_RETURN;
 
 controlLevelIndicator: INDICATOR_BLACK | INDICATOR_CONTROL_LEVEL;
 
 matchingFieldsIndicator: INDICATOR_BLACK | INDICATOR_MATCHING_RECORD;