/**
 * Antlr4 parser for IBM RPG Language's Define Specification
 */
parser grammar RPGDParser;

 options {
 	tokenVocab = RPGDLexer;
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
 	D_SPEC DS_NAME DS_EXTERNAL_DESCRIPTION DS_DATA_STRUCT_TYPE defintType =
 	(
 		DS_DEF_TYPE_DS
 		| DS_DEF_TYPE_C
 		| DS_DEF_TYPE_S
 		| DS_DEF_TYPE_BLACK
 	) DS_FROM_POSITION DS_TO_POSITION DS_INTERNAL_DATA_TYPE DS_DECIMAL_POSITIONS
 	DS_RESERVED keyword*
 	(
 		EOL
 		| EOF
 	)
 ;

 keyword
 :
 	keyword_alt
 	| keyword_ascend
 	| keyword_based
 	| keyword_const
 	| keyword_ctdata
 	| keyword_datfmt
 	| keyword_descend
 	| keyword_dim
 	| keyword_dtaara
 	| keyword_export
 	| keyword_extfld
 	| keyword_extfmt
 	| keyword_extname
 	| keyword_fromfile
 	| keyword_import
 	| keyword_inz
 	| keyword_like
 	| keyword_noopt
 	| keyword_occurs
 	| keyword_overlay
 	| keyword_packeven
 	| keyword_perrcd
 	| keyword_prefix
 	| keyword_procptr
 	| keyword_timfmt
 	| keyword_tofile
 ;

 keyword_alt: KEYWORD_ALT OPEN_PAREN arrayName = simpleExpression CLOSE_PAREN;
 keyword_ascend: KEYWORD_ASCEND;
 keyword_based: KEYWORD_BASED OPEN_PAREN basingPointerName = simpleExpression CLOSE_PAREN;
 keyword_const: KEYWORD_CONST OPEN_PAREN constant = simpleExpression CLOSE_PAREN;
 keyword_ctdata: KEYWORD_CTDATA;
 keyword_datfmt: KEYWORD_DATFMT OPEN_PAREN fmt = dateFormat (dateSeparator)? CLOSE_PAREN;
 keyword_descend: KEYWORD_DESCEND;
 keyword_dim: KEYWORD_DIM OPEN_PAREN numericConstant = simpleExpression CLOSE_PAREN;
 keyword_dtaara: KEYWORD_DTAARA (OPEN_PAREN name = simpleExpression CLOSE_PAREN)?;
 keyword_export: KEYWORD_EXPORT;
 keyword_extfld: KEYWORD_EXTFLD OPEN_PAREN fieldName = simpleExpression CLOSE_PAREN;
 keyword_extfmt: KEYWORD_EXTFMT OPEN_PAREN code = extfmtCode CLOSE_PAREN;
 keyword_extname: KEYWORD_EXTNAME OPEN_PAREN fileName = simpleExpression (COLON formatName = simpleExpression)? CLOSE_PAREN;
 keyword_fromfile: KEYWORD_FROMFILE OPEN_PAREN fileName = simpleExpression CLOSE_PAREN;
 keyword_import: KEYWORD_IMPORT;
 keyword_inz: KEYWORD_INZ (OPEN_PAREN constants = simpleExpression)? CLOSE_PAREN;
 keyword_like: KEYWORD_LIKE OPEN_PAREN rpgName = simpleExpression CLOSE_PAREN;
 keyword_noopt: KEYWORD_NOOPT;
 keyword_occurs: KEYWORD_OCCURS OPEN_PAREN numericConstant = simpleExpression CLOSE_PAREN;
 keyword_overlay: KEYWORD_OVERLAY OPEN_PAREN name = simpleExpression (COLON position = simpleExpression)? CLOSE_PAREN;
 keyword_packeven: KEYWORD_PACKEVEN;
 keyword_perrcd: KEYWORD_PERRCD OPEN_PAREN numericConstant = simpleExpression CLOSE_PAREN;
 keyword_prefix: KEYWORD_PREFIX OPEN_PAREN prefix = simpleExpression CLOSE_PAREN;
 keyword_procptr: KEYWORD_PROCPTR;
 keyword_timfmt: KEYWORD_TIMFMT OPEN_PAREN fmt = timeFormat (timeSeparator)? CLOSE_PAREN;
 keyword_tofile: KEYWORD_TOFILE OPEN_PAREN fileName = simpleExpression CLOSE_PAREN;
 
 extfmtCode: EXTFMT_OPTION_S | EXTFMT_OPTION_P | EXTFMT_OPTION_B | EXTFMT_OPTION_L EXTFMT_OPTION_R;
 
 number: NUMBER ;
 
 dateFormatEdit: DMY | MDY | YMD;
 dateFormat: DMY | EUR | ISO | JIS | JUL | MDY | USA | YMD;
 dateSeparator: DIV | AMPERSAND | MINUS | DOT | COMMA;

 timeFormat: HMS | ISO | USA | EUR | JIS;
 timeSeparator: SEMI | DOT | COMMA | AMPERSAND;
 
 simpleExpression
 :
 	ID
 ;
 
