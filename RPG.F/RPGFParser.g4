/**
 * Antlr4 parser for IBM RPG Language's File Specification
 */
parser grammar RPGFParser;

 options {
 	tokenVocab = RPGFLexer;
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
 	F_SPEC recordName = FS_RECORD_NAME type = FS_TYPE FS_DESIGNATION FS_EOF
 	FS_ADDUTION FS_SEQUENCE FS_FORMAT FS_RECORD_LENGTH FS_LIMITS FS_LENGTH_OF_KEY
 	FS_RECORD_ADDRESS_TYPE FS_ORGANIZATION device =
 	(
 		FS_DEVICE_DISK
 		| FS_DEVICE_PRINTER
 		| FS_DEVICE_SPECIAL
 		| FS_DEVICE_WORKSTN
 	) FS_RESERVED? keyword*
 	(
 		EOL
 		| EOF
 	)
 ;

 keyword
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
 keyword_datfmt: KEYWORD_DATFMT OPEN_PAREN (simpleExpression | symbolicConstants) (dateSeparator)? CLOSE_PAREN;
 keyword_devid: KEYWORD_DEVID (OPEN_PAREN simpleExpression CLOSE_PAREN);
 keyword_extind: KEYWORD_EXTIND OPEN_PAREN simpleExpression CLOSE_PAREN;
 keyword_formlen: KEYWORD_FORMLEN OPEN_PAREN number CLOSE_PAREN;
 keyword_formofl: KEYWORD_FORMOFL OPEN_PAREN number CLOSE_PAREN;
 keyword_ignore: KEYWORD_IGNORE OPEN_PAREN simpleExpression (COLON simpleExpression)* CLOSE_PAREN;
 keyword_include: KEYWORD_INCLUDE OPEN_PAREN simpleExpression (COLON simpleExpression)* CLOSE_PAREN;
 keyword_infds: KEYWORD_INFDS OPEN_PAREN simpleExpression CLOSE_PAREN;
 keyword_infsr: KEYWORD_INFSR OPEN_PAREN subrName=simpleExpression CLOSE_PAREN;
 keyword_keyloc: KEYWORD_KEYLOC OPEN_PAREN number CLOSE_PAREN;
 keyword_maxdev: KEYWORD_MAXDEV OPEN_PAREN (SPLAT_FILE | SPLAT_ONLY) CLOSE_PAREN;
 keyword_oflind: KEYWORD_OFLIND OPEN_PAREN simpleExpression CLOSE_PAREN;
 keyword_pass: KEYWORD_PASS OPEN_PAREN symbolicConstants CLOSE_PAREN;
 keyword_pgmname: KEYWORD_PGMNAME OPEN_PAREN programName=simpleExpression CLOSE_PAREN;
 keyword_plist:	KEYWORD_PLIST OPEN_PAREN plistName=simpleExpression CLOSE_PAREN;
 keyword_prefix: KEYWORD_PLIST OPEN_PAREN prefixName=simpleExpression CLOSE_PAREN;
 keyword_prtctl:	KEYWORD_PRTCTL OPEN_PAREN dataStruct=simpleExpression (COLON symbolicConstants)? CLOSE_PAREN;
 keyword_rafdata: KEYWORD_RAFDATA OPEN_PAREN fileName=simpleExpression CLOSE_PAREN;
 keyword_recno: KEYWORD_RECNO OPEN_PAREN fieldName=simpleExpression CLOSE_PAREN;
 keyword_rename: KEYWORD_RENAME OPEN_PAREN externalFormat=simpleExpression COLON internalFormat=simpleExpression CLOSE_PAREN;
 keyword_saveds: KEYWORD_SAVEDS OPEN_PAREN simpleExpression CLOSE_PAREN;
 keyword_saveind: KEYWORD_SAVEIND OPEN_PAREN number CLOSE_PAREN;
 keyword_sfile: KEYWORD_SFILE OPEN_PAREN recordFormat=simpleExpression COLON relativeRecordNumberField=simpleExpression CLOSE_PAREN;
 keyword_sln: KEYWORD_SLN OPEN_PAREN number CLOSE_PAREN;
 keyword_timfmt: KEYWORD_TIMFMT OPEN_PAREN (simpleExpression | symbolicConstants) (timeSeparator)? CLOSE_PAREN;
 keyword_usropn: KEYWORD_USROPN;
 
 number: NUMBER ;
 
 dateSeparator: AMPERSAND | MINUS | DIV | DOT | COMMA;
 
 timeSeparator: COLON | DOT | COMMA | AMPERSAND;

 simpleExpression
 :
 ;
 
 symbolicConstants: SPLAT_ALL
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
