/**
 * Antlr4 parser for IBM RPG III.
 */
parser grammar RPGParser;

 options {
 	tokenVocab = RPGLexer;
 }

 r: (dspec | fspec | hspec | ospec | cspec | ispec | comments)*;
 
 comments: (COMMENT_SPEC COMMENTS_TEXT?) | (COMMENTS COMMENTS_TEXT) ;
 
 //Definition
 dspec: RPG_D DS_NAME DS_EXTERNAL_DESCRIPTION DS_DATA_STRUCT_TYPE defintType =
 	(
 		DS_DEF_TYPE_DS
 		| DS_DEF_TYPE_C
 		| DS_DEF_TYPE_S
 		| DS_DEF_TYPE_BLACK
 	) DS_FROM_POSITION DS_TO_POSITION DS_INTERNAL_DATA_TYPE DS_DECIMAL_POSITIONS
 	DS_RESERVED dspecKeyword*
 	(
 		EOL
 		| EOF
 	);
 
 dspecKeyword:
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
 //Keywords
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
 
 //File Specification
 fspec: RPG_F recordName = FS_RECORD_NAME type = FS_TYPE FS_DESIGNATION FS_EOF
 	FS_ADDUTION FS_SEQUENCE FS_FORMAT FS_RECORD_LENGTH FS_LIMITS FS_LENGTH_OF_KEY
 	FS_RECORD_ADDRESS_TYPE FS_ORGANIZATION device =
 	(
 		FS_DEVICE_DISK
 		| FS_DEVICE_PRINTER
 		| FS_DEVICE_SPECIAL
 		| FS_DEVICE_WORKSTN
 	) FS_RESERVED? fspecKeyword*
 	(
 		EOL
 		| EOF
 	)
 ;
 fspecKeyword
 :
 	keyword_commit
 	| keyword_datfmt
 	| keyword_devid
 	| keyword_extind 
 	| keyword_formlen
 	| keyword_formofl
 	| keyword_ignore
 	| keyword_include
 	| keyword_infds
 	| keyword_infsr
 	| keyword_keyloc
 	| keyword_maxdev
 	| keyword_oflind
 	| keyword_pass
 	| keyword_pgmname
 	| keyword_plist
 	| keyword_prefix
 	| keyword_prtctl
 	| keyword_rafdata
 	| keyword_recno
 	| keyword_rename
 	| keyword_saveds
 	| keyword_saveind
 	| keyword_sfile
 	| keyword_sln
 	| keyword_timfmt
 	| keyword_usropn
 ;
 keyword_commit: KEYWORD_COMMIT (OPEN_PAREN programName = simpleExpression CLOSE_PAREN)?;
 keyword_devid: KEYWORD_DEVID (OPEN_PAREN simpleExpression CLOSE_PAREN);
 keyword_extind: KEYWORD_EXTIND OPEN_PAREN EXTIND_INUX CLOSE_PAREN;
 keyword_formlen: KEYWORD_FORMLEN OPEN_PAREN number CLOSE_PAREN;
 keyword_formofl: KEYWORD_FORMOFL OPEN_PAREN number CLOSE_PAREN;
 keyword_ignore: KEYWORD_IGNORE OPEN_PAREN recoreFormat = simpleExpression (COLON recoreFormat = simpleExpression)* CLOSE_PAREN;
 keyword_include: KEYWORD_INCLUDE OPEN_PAREN recoreFormat = simpleExpression (COLON recoreFormat = simpleExpression)* CLOSE_PAREN;
 keyword_infds: KEYWORD_INFDS OPEN_PAREN dsName = simpleExpression CLOSE_PAREN;
 keyword_infsr: KEYWORD_INFSR OPEN_PAREN subrName = simpleExpression CLOSE_PAREN;
 keyword_keyloc: KEYWORD_KEYLOC OPEN_PAREN number CLOSE_PAREN;
 keyword_maxdev: KEYWORD_MAXDEV OPEN_PAREN (OPTION_ONLY | OPTION_FILE) CLOSE_PAREN;
 keyword_oflind: KEYWORD_OFLIND OPEN_PAREN (OFLIND_INXX | OFLIND_INXY) CLOSE_PAREN;
 keyword_pass: KEYWORD_PASS OPEN_PAREN OPTION_NOIND CLOSE_PAREN;
 keyword_pgmname: KEYWORD_PGMNAME OPEN_PAREN programName=simpleExpression CLOSE_PAREN;
 keyword_plist:	KEYWORD_PLIST OPEN_PAREN plistName=simpleExpression CLOSE_PAREN;
 keyword_prtctl:	KEYWORD_PRTCTL OPEN_PAREN dataStruct=simpleExpression (COLON OPTION_COMPAT)? CLOSE_PAREN;
 keyword_rafdata: KEYWORD_RAFDATA OPEN_PAREN fileName=simpleExpression CLOSE_PAREN;
 keyword_recno: KEYWORD_RECNO OPEN_PAREN fieldName=simpleExpression CLOSE_PAREN;
 keyword_rename: KEYWORD_RENAME OPEN_PAREN externalFormat=simpleExpression COLON internalFormat=simpleExpression CLOSE_PAREN;
 keyword_saveds: KEYWORD_SAVEDS OPEN_PAREN simpleExpression CLOSE_PAREN;
 keyword_saveind: KEYWORD_SAVEIND OPEN_PAREN number CLOSE_PAREN;
 keyword_sfile: KEYWORD_SFILE OPEN_PAREN recordFormat=simpleExpression COLON relativeRecordNumberField=simpleExpression CLOSE_PAREN;
 keyword_sln: KEYWORD_SLN OPEN_PAREN number CLOSE_PAREN;
 keyword_usropn: KEYWORD_USROPN;

 // Header Specification
 hspec:(
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
 	);
 parameter
 :
 	ID
 	| string
 	| symbolicConstants
 ;

 string
 :
 	STRING_LITERAL_START
 	(
 		STRING_CONTENT
 		| STRING_ESCAPED_QUOTE
 	)* STRING_LITERAL_END
 ;

 //Output Specification
 ospec: RPG_O (((OS_RECORD_NAME OS_TYPE (osProgramDesc1 | osProgramDesc2)) | osProgramField) | osProgramCompoundDesc) OS_COMMENTS? (EOL | EOF);
 
 osProgramDesc1: OS_FETCH_OVERFLOW outputConditioningOnOffIndicator outputConditioningOnOffIndicator outputConditioningOnOffIndicator OS_EXCEPT_NAME OS_SPACE3 OS_SPACE3 OS_SPACE3 OS_SPACE3 OS_REMAINING_SPACE;
 
 osProgramDesc2: OS_ADD_DEL outputConditioningOnOffIndicator outputConditioningOnOffIndicator outputConditioningOnOffIndicator OS_EXCEPT_NAME OS_REMAINING_SPACE;
 
 osProgramField: OS_FIELD_RESERVED outputConditioningOnOffIndicator outputConditioningOnOffIndicator outputConditioningOnOffIndicator OS_FIELD_NAME OS_EDIT_NAMES OS_BLACK_AFTER OS_END_POSITION OS_DATA_FMT literal?;
 
 osProgramCompoundDesc: OS_AND_OR outputConditioningOnOffIndicator outputConditioningOnOffIndicator outputConditioningOnOffIndicator OS_EXCEPT_NAME OS_REMAINING_SPACE;
 
 outputConditioningOnOffIndicator: onOffIndicatorsFlag outputConditioningIndicator;
 
 onOffIndicatorsFlag: BLACK_FLAG | NO_FLAG;
 
 outputConditioningIndicator: INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_FUNC_KEY | INDICATOR_CONTROL_LEVEL | INDICATOR_HALT | INDICATOR_EXTERNAL | INDICATOR_OVERFLOW | INDICATOR_MATCHING_RECORD | INDICATOR_RETURN | INDICATOR_FIRST_PAGE;
 
 //Calculation Specification
 cspec:RPG_C controlLevel indicatorOff = onOffIndicatorsFlag indicators factor1 = factor (calcStandardParts | calcExtendedFactor2Parts);
   
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
 
 //Input Specification
 ispec:RPG_I (isRecordSpec | isFieldSpec | isExternalRecordSpec | isExternalFieldSpec) (EOL | EOF);
 
 isRecordSpec: IS_FILE_NAME IS_SEQUENCE IS_NUMBER IS_OPTION recordIdIndicator IS_RECORD_ID_CODE; 
 
 isFieldSpec: ISFLD_DATE_FMT_EXT ISFLD_DATE_SEPARATOR ISFLD_DATE_FMT ISFLD_FIELD_LOCATION ISFLD_DECIMAL_POSITIONS ISFLD_FIELD_NAME ISFLD_CONTROL_LEVEL ISFLD_MATCHING_FIELDS fieldRecordRelation fieldIndicator fieldIndicator fieldIndicator ISFLD_COMMENETS?;
 
 isExternalRecordSpec: IS_FILE_NAME IS_EXTERNAL_RECORE_RESERVED resultIndicator WS?;
 
 isExternalFieldSpec: ISEXTFLD_NAME ISEXTFLD_FIELD_NAME controlLevelIndicator matchingFieldsIndicator inputResultIndicator inputResultIndicator inputResultIndicator;
 
 recordIdIndicator:INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_HALT | INDICATOR_CONTROL_LEVEL | INDICATOR_LAST_RECORD | INDICATOR_EXTERNAL | INDICATOR_RETURN;
 
 fieldIndicator: INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_CONTROL_LEVEL | INDICATOR_HALT | INDICATOR_EXTERNAL | INDICATOR_RETURN;
 
 inputResultIndicator: INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_CONTROL_LEVEL | INDICATOR_FUNC_KEY | INDICATOR_LAST_RECORD | INDICATOR_MATCHING_RECORD | INDICATOR_HALT | INDICATOR_EXTERNAL | INDICATOR_OVERFLOW | INDICATOR_RETURN;
 
 fieldRecordRelation: INDICATOR_BLACK | INDICATOR_GENERAL | INDICATOR_CONTROL_LEVEL | INDICATOR_MATCHING_RECORD | INDICATOR_EXTERNAL | INDICATOR_HALT | INDICATOR_RETURN;
 
 controlLevelIndicator: INDICATOR_BLACK | INDICATOR_CONTROL_LEVEL;
 
 matchingFieldsIndicator: INDICATOR_BLACK | INDICATOR_MATCHING_RECORD;
 
 literal: STRING_LITERAL_START
	content=(STRING_CONTENT | STRING_ESCAPED_QUOTE )* STRING_LITERAL_END;
	
 extfmtCode: EXTFMT_OPTION_S | EXTFMT_OPTION_P | EXTFMT_OPTION_B | EXTFMT_OPTION_L EXTFMT_OPTION_R;
 
 number: NUMBER ;
 
 dateFormatEdit: DMY | MDY | YMD;
 dateFormat: DMY | EUR | ISO | JIS | JUL | MDY | USA | YMD;
 dateSeparator: DIV | AMPERSAND | MINUS | DOT | COMMA;

 timeFormat: HMS | ISO | USA | EUR | JIS;
 timeSeparator: SEMI | DOT | COMMA | AMPERSAND;
 
 expression:;
 
 simpleExpression
 :
 	ID
 ;
 
 symbolicConstants:
  SPLAT_ALL
   | SPLAT_NONE
   | SPLAT_NO
   | SPLAT_YES
   | SPLAT_ILERPG
   | SPLAT_COMPAT
   | SPLAT_CRTBNDRPG
   | SPLAT_CRTRPGMOD
   | SPLAT_VRM
   | SPLAT_ALLG
   | SPLAT_ALLU
   | SPLAT_ALLTHREAD
   | SPLAT_ALLX
   | SPLAT_BLANKS
   | SPLAT_CANCL
   | SPLAT_CYMD
   | SPLAT_CMDY
   | SPLAT_CDMY
   | SPLAT_MDY
   | SPLAT_DMY
   | SPLAT_DFT
   | SPLAT_YMD
   | SPLAT_JUL
   | SPLAT_INPUT
   | SPLAT_OUTPUT
   | SPLAT_ISO
   | SPLAT_KEY
   | SPLAT_NEXT
   | SPLAT_USA
   | SPLAT_EUR
   | SPLAT_JIS
   | SPLAT_JAVA
   | SPLAT_DATE
   | SPLAT_DAY
   | SPlAT_DETC
   | SPLAT_DETL
   | SPLAT_DTAARA
   | SPLAT_END
   | SPLAT_ENTRY
   | SPLAT_EQUATE
   | SPLAT_EXTDFT
   | SPLAT_EXT
   | SPLAT_FILE
   | SPLAT_GETIN
   | SPLAT_HIVAL
   | SPLAT_INIT
   | SPLAT_INDICATOR
   | SPLAT_INZSR
   | SPLAT_IN
   | SPLAT_JOBRUN
   | SPLAT_JOB
   | SPLAT_LDA
   | SPLAT_LIKE
   | SPLAT_LONGJUL
   | SPLAT_LOVAL
   | SPLAT_MONTH
   | SPLAT_NOIND
   | SPLAT_NOKEY
   | SPLAT_NULL
   | SPLAT_OFL
   | SPLAT_ON
   | SPLAT_ONLY
   | SPLAT_OFF
   | SPLAT_PDA
   | SPLAT_PLACE
   | SPLAT_PSSR
   | SPLAT_ROUTINE
   | SPLAT_START
   | SPLAT_SYS
   | SPLAT_TERM
   | SPLAT_TOTC
   | SPLAT_TOTL
   | SPLAT_USER
   | SPLAT_VAR
   | SPLAT_YEAR
   | SPLAT_ZEROS
   | SPLAT_HMS
   | SPLAT_INLR
   | SPLAT_INOF
   | SPLAT_DATA
   | SPLAT_ASTFILL
   | SPLAT_CURSYM
   | SPLAT_MAX
   | SPLAT_LOCK
   | SPLAT_PROGRAM
   //Durations
   | SPLAT_D
   | SPLAT_DAYS
   | SPLAT_H
   | SPLAT_HOURS
   | SPLAT_M
   | SPLAT_MINUTES
   | SPLAT_MONTHS
   | SPLAT_MN
   | SPLAT_MS
   | SPLAT_MSECONDS
   | SPLAT_S
   | SPLAT_SECONDS
   | SPLAT_Y
   | SPLAT_YEARS
   | SPLAT_EXTDESC
   ;
 