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
 		| comments
 	)* (EOL | EOF)*
 ;

 //Black line from column 6

 blackLine
 :
 	BLACK_LINE
 ;

 //Comments begin with *
 comments
 :
 	COMMENT_SPEC_FIXED commentText?
 ;

 commentText
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
 	RPG_HS keyword*
 	(
 		EOL
 		| EOF
 	)
 ;

 keyword
 :
 	keyword_altseq
 	| keyword_cursym
 	| keyword_datedit
 	| keyword_datfmt
 	| keyword_debug
 	| keyword_decedit
 	| keyword_dftname
 	| keyword_formsalign
 	| keyword_ftrans
 	| keyword_timfmt
 ;
 
 keyword_altseq: KEYWORD_ALTSEQ (OPEN_PAREN option = (OPTION_NONE | OPTION_SRC | OPTION_EXT) CLOSE_PAREN)?;
 keyword_cursym: KEYWORD_CURSYM OPEN_PAREN HS_CURSYM CLOSE_PAREN;
 keyword_datedit: KEYWORD_DATEDIT OPEN_PAREN fmt = dateFormatEdit (separator = (DIV | AMPERSAND))?  CLOSE_PAREN;
 keyword_datfmt: KEYWORD_DATFMT OPEN_PAREN fmt = dateFormat (dateSeparator)? CLOSE_PAREN;
 keyword_debug: KEYWORD_DEBUG (OPEN_PAREN (OPTION_NO | OPTION_YES) CLOSE_PAREN)?;
 keyword_decedit: KEYWORD_DECEDIT OPEN_PAREN value = (DECEDIT_1 | DECEDIT_2 | DECEDIT_3 | DECEDIT_4) CLOSE_PAREN;
 keyword_dftname: KEYWORD_DFTNAME OPEN_PAREN name = ID CLOSE_PAREN;
 keyword_formsalign: KEYWORD_FORMSALIGN (OPEN_PAREN (OPTION_NO | OPTION_YES)CLOSE_PAREN)?;
 keyword_ftrans: KEYWORD_FTRANS (OPEN_PAREN (OPTION_NONE | OPTION_SRC) CLOSE_PAREN)?;
 keyword_timfmt: KEYWORD_TIMFMT OPEN_PAREN fmt = timeFormat (timeSeparator)? CLOSE_PAREN;
 
 dateFormatEdit: DMY | MDY | YMD;
 dateFormat: DMY | EUR | ISO | JIS | JUL | MDY | USA | YMD;
 dateSeparator: DIV | AMPERSAND | MINUS | DOT | COMMA;

 timeFormat: HMS | ISO | USA | EUR | JIS;
 timeSeparator: SEMI | DOT | COMMA | AMPERSAND;
 
