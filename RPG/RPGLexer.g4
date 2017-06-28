/**
 * Antlr4 Lexer for IBM RPG III.
 */
lexer grammar RPGLexer;

@members {
	public boolean isEndOfToken() {
		return " (;".indexOf(_input.LA(1)) >=0;
	}
	int lastTokenType = 0;
	public void emit(Token token) {
		super.emit(token);
		lastTokenType = token.getType();
	}
	protected int getLastTokenType(){
		return lastTokenType;
	}
} 
//Ignore 1-5 columns with white spaces
LEAD_WS5: '     ' {getCharPositionInLine() == 5}? -> skip;
LEAD_WS5_COMMENTS: WORD5 {getCharPositionInLine() == 5}? -> channel(HIDDEN);

//Column 6th.
//*? is comments
COMMENT_SPEC: {getCharPositionInLine() == 5}? .'*' -> pushMode(Comment), channel(HIDDEN);
//[D F O C I H]? is specifications.
RPG_D: [dD] {getCharPositionInLine() == 6}? -> pushMode(Definition);
RPG_F: [fF] {getCharPositionInLine() == 6}? -> pushMode(File);
RPG_O: [oO] {getCharPositionInLine() == 6}? -> pushMode(Output);
RPG_C: [cC] {getCharPositionInLine() == 6}? -> pushMode(Calculation), pushMode(OnOffIndicator), pushMode(Indicator);
RPG_I: [iI] {getCharPositionInLine() == 6}? -> pushMode(Input);
RPG_H: [hH] {getCharPositionInLine() == 6}? -> pushMode(Header);
//Empty? 
BLACK_LINE: [ ] {getCharPositionInLine() == 6}? [ ]* NEWLINE -> skip;
BLACK_SPEC_LINE1: . NEWLINE {getCharPositionInLine() == 7}? -> skip;
BLACK_SPEC_LINE: .[ ] {getCharPositionInLine() == 7}? [ ]* NEWLINE -> skip;

//Comments, 7th is *
COMMENTS: [ ] {getCharPositionInLine() >= 6}? [ ]*? '//' -> pushMode(Comment), channel(HIDDEN);

//Empty line
EMPTY_LINE: '                                                                           ' {getCharPositionInLine() >= 80}? -> pushMode(Comment), channel(HIDDEN);

//Most used characters
OPEN_PAREN: '(';
CLOSE_PAREN: ')';
SEMI: ';';
COLON: ':';

//Keywords
KEYWORD_ALTSEQ: [aA][lL][tT][sS][eE][qQ];
KEYWORD_CURSYM: [cC][uU][rR][sS][yY][mM];
KEYWORD_DATEDIT: [dD][aA][tT][eE][dD][iI][tT];
KEYWORD_DATFMT: [dD][aA][tT][fF][mM][tT];
KEYWORD_DEBUG: [dD][eE][bB][uU][gG];
KEYWORD_DECEDIT: [dD][eE][cC][eE][dD][iI][tT];
KEYWORD_DFTNAME: [dD][fF][tT][nN][aA][mM][eE];
KEYWORD_FORMSALIGN: [fF][oO][rR][mM][sS][aA][lL][iI][gG][nN];
KEYWORD_FTRANS: [fF][tT][rR][aA][nN][sS];
KEYWORD_TIMFMT: [tT][iI][mM][fF][mM][tT];
KEYWORD_COMMIT : [cC][oO][mM][mM][iI][tT]; 
KEYWORD_DEVID : [dD][eE][vV][iI][dD]; 
KEYWORD_EXTIND  : [eE][xX][tT][iI][nN][dD]; 
KEYWORD_FORMLEN : [fF][oO][rR][mM][lL][eE][nN];
KEYWORD_FORMOFL : [fF][oO][rR][mM][oO][fF][lL];
KEYWORD_IGNORE : [iI][gG][nN][oO][rR][eE];
KEYWORD_INCLUDE : [iI][nN][cC][lL][uU][dD][eE];
KEYWORD_INFDS : [iI][nN][fF][dD][sS];
KEYWORD_INFSR : [iI][nN][fF][sS][rR];
KEYWORD_KEYLOC : [kK][eE][yY][lL][oO][cC];
KEYWORD_MAXDEV : [mM][aA][xX][dD][eE][vV];
KEYWORD_OFLIND : [oO][fF][lL][iI][nN][dD];
KEYWORD_PASS : [pP][aA][sS][sS];
KEYWORD_PGMNAME : [pP][gG][mM][nN][aA][mM][eE];
KEYWORD_PLIST : [pP][lL][iI][sS][tT];
KEYWORD_PREFIX: [pP][rR][eE][fF][iI][xX];
KEYWORD_PRTCTL : [pP][rR][tT][cC][tT][lL];
KEYWORD_RAFDATA : [rR][aA][fF][dD][aA][tT][aA];
KEYWORD_RECNO : [rR][eE][cC][nN][oO];
KEYWORD_RENAME : [rR][eE][nN][aA][mM][eE];
KEYWORD_SAVEDS : [sS][aA][vV][eE][dD][sS];
KEYWORD_SAVEIND : [sS][aA][vV][eE][iI][nN][dD];
KEYWORD_SFILE : [sS][fF][iI][lL][eE];
KEYWORD_SLN : [sS][lL][nN];
KEYWORD_USROPN : [uU][sS][rR][oO][pP][nN];
KEYWORD_ALT : [Aa][Ll][Tt];
KEYWORD_ASCEND : [Aa][Ss][Cc][Ee][Nn][Dd];
KEYWORD_BASED : [Bb][Aa][Ss][Ee][Dd];
KEYWORD_CONST : [Cc][Oo][Nn][Ss][Tt];
KEYWORD_CTDATA : [Cc][Tt][Dd][Aa][Tt][Aa];
KEYWORD_DESCEND : [Dd][Ee][Ss][Cc][Ee][Nn][Dd];
KEYWORD_DIM : [Dd][Ii][Mm];
KEYWORD_DTAARA : [Dd][Tt][Aa][Aa][Rr][Aa];
KEYWORD_EXPORT : [Ee][Xx][Pp][Oo][Rr][Tt];
KEYWORD_EXTFLD : [Ee][Xx][Tt][Ff][Ll][Dd];
KEYWORD_EXTFMT : [Ee][Xx][Tt][Ff][Mm][Tt];
KEYWORD_EXTNAME : [Ee][Xx][Tt][Nn][Aa][Mm][Ee];
KEYWORD_FROMFILE : [Ff][Rr][Oo][Mm][Ff][Ii][Ll][Ee];
KEYWORD_IMPORT : [Ii][Mm][Pp][Oo][Rr][Tt];
KEYWORD_INZ : [Ii][Nn][Zz];
KEYWORD_LIKE : [Ll][Ii][Kk][Ee];
KEYWORD_NOOPT : [Nn][Oo][Oo][Pp][Tt];
KEYWORD_OCCURS : [Oo][Cc][Cc][Uu][Rr][Ss];
KEYWORD_OVERLAY : [Oo][Vv][Ee][Rr][Ll][Aa][Yy];
KEYWORD_PACKEVEN : [Pp][Aa][Cc][Kk][Ee][Vv][Ee][Nn];
KEYWORD_PERRCD : [Pp][Ee][Rr][Rr][Cc][Dd];
KEYWORD_PROCPTR : [Pp][Rr][Oo][Cc][Pp][Tt][Rr];
KEYWORD_TOFILE : [Tt][Oo][Ff][Ii][Ll][Ee];

//Options
OPTION_NONE: '*'[nN][oO][nN][eE];
OPTION_SRC: '*'[sS][rR][cC];
OPTION_EXT: '*'[eE][xX][tT];
OPTION_NO: '*'[nN][oO];
OPTION_YES: '*'[yY][eE][sS];
OPTION_FILE: '*'[fF][iI][lL][eE];
OPTION_ONLY: '*'[oO][nN][lL][yY];
OPTION_NOIND: '*'[nN][oO][nN][iI][dD];
OPTION_COMPAT: '*'[cC][oO][mM][pP][aA][tT];

//Date and time format
DMY: '*'[dD][mM][yY];
MDY: '*'[mM][dD][yY];
YMD: '*'[yY][mM][dD];
JUL: '*'[jJ][uU][lL];
ISO: '*'[iI][sS][oO];
USA: '*'[uU][sS][aA];
EUR: '*'[eE][uU][rR];
JIS: '*'[jJ][iI][sS];
HMS: '*'[hH][mM][sS];

AMPERSAND: '&';
DOT: '.';
COMMA: ',';

//Reversed words
UDATE : [uU] [dD] [aA] [tT] [eE] ;
DATE : '*' [dD] [aA] [tT] [eE] ;
UMONTH : [uU] [mM] [oO] [nN] [tT] [hH] ;
MONTH : '*' [mM] [oO] [nN] [tT] [hH] ;
UYEAR : [uU] [yY] [eE] [aA] [rR] ;
YEAR : '*' [yY] [eE] [aA] [rR] ;
UDAY : [uU] [dD] [aA] [yY] ;
DAY : '*' [dD] [aA] [yY] ;
PAGE : [pP] [aA] [gG] [eE] [1-7]? ;

// Boolean operators
AND : [aA] [nN] [dD] ;
OR : [oO] [rR] ;
NOT : [nN] [oO] [tT] ;

// Arithmetical Operators
PLUS : '+' ;
MINUS : '-' ;
EXP : '**' ;
ARRAY_REPEAT: {_input.LA(2) == ')' && _input.LA(-1) == '('}? '*' ;
MULT_NOSPACE: {_input.LA(2) != 32}? '*';
MULT: {_input.LA(2) == 32}? '*' ;
DIV : '/' ;

// Assignment Operators
CPLUS : '+=' ;
CMINUS : '-=' ;
CMULT : '*=' ;
CDIV : '/=' ;
CEXP : '**=' ;

// Comparison Operators
GT : '>' ;
LT : '<' ;
GE : '>=' ;
LE : '<=' ;
NE : '<>' ;

//Build-in Functions
BIF_ADDR: '%'[aA][dD][dD][rR];
BIF_ELEM: '%'[eE][lL][eE][mM];
BIF_PADDR: '%'[pP][aA][dD][dD][rR];
BIF_SIZE: '%'[sS][iI][zZ][eE];
BIF_SUBST: '%'[sS][uU][bB][sS][tT];
BIF_TRIM: '%'[tT][rR][iI][mM];
BIF_TRIML: '%'[tT][rR][iI][mM][lL];
BIF_TRIMR: '%'[tT][rR][iI][mM][rR];

//Operations
OP_ACQ: [aA][cC][qQ];
OP_ADD: [aA][dD][dD];
OP_ADDDUR: OP_ADD [dD][uU][rR];
OP_ANDxx: [aA][nN][dD][0-9][0-9];
OP_BEGSR: [bB][eE][gG][sS][rR];
OP_BITOFF: [bB][iI][tT][oO][fF][fF];
OP_BITON: [bB][iI][tT][oO][nN];
OP_CABxx: [cC][aA][bB][0-9][0-9];
OP_CALL: [Cc][Aa][Ll][Ll];
OP_CALLB: OP_CALL [bB];
OP_CASxx: [cC][aA][sS][0-9][0-9];
OP_CAT: [cC][aA][tT];
OP_CHAIN: [cC][hH][aA][iI][nN];
OP_CHECK: [cC][hH][eE][cC][kK];
OP_CHECKR: [cC][hH][eE][cC][kK][rR];
OP_COMP: [cC][oO][mM][pP];
OP_CLEAR: [cC][lL][eE][aA][rR];
OP_CLOSE: [cC][lL][oO][sS][eE];
OP_COMMIT: [cC][oO][mM][mM][iI][tT];
OP_DEFINE: [dD][eE][fF][iI][nN][eE];
OP_DELETE: [dD][eE][lL][eE][tT][eE];
OP_DIV: [dD][iI][vV];
OP_DO: [dD][oO];
OP_DOUxx: [dD][oO][uU][0-9][0-9];
OP_DOWxx: [dD][oO][wW][0-9][0-9];
OP_DSPLY: [dD][sS][pP][lL][yY];
OP_DUMP: [dD][uU][mM][pP];
OP_ELSE: [eE][lL][sS][eE];
OP_END: [eE][nN][dD];
OP_ENDCS: [eE][nN][dD][cC][sS];
OP_ENDDO: [eE][nN][dD][dD][oO];
OP_ENDIF: [eE][nN][dD][iI][fF];
OP_ENDSL: [eE][nN][dD][sS][lL];
OP_ENDSR: [eE][nN][dD][sS][rR];
OP_EVAL: [eE][vV][aA][lL];
OP_EXCEPT: [eE][xX][cC][eE][pP][tT];
OP_EXFMT: [eE][xX][fF][mM][tT];
OP_EXSR: [eE][xX][sS][rR];
OP_EXTRCT: [eE][xX][tT][rR][cC][tT];
OP_FEOD: [fF][eE][oO][dD];
OP_FORCE: [fF][oO][rR][cC][eE];
OP_GOTO: [gG][oO][tT][oO];
OP_IF: [iI][fF];
OP_IFxx: [iI][fF][0-9][0-9];
OP_IN: [iI][nN];
OP_INER: [iI][nN][eE][rR];
OP_KFLD: [kK][fF][lL][dD];
OP_KLIST: [kK][lL][iI][sS][tT];
OP_LOOKUP: [lL][oO][oO][kK][uU][pP];
OP_MHHZO: [mM][hH][hH][zZ][oO];
OP_MHLZO: [mM][hH][lL][zZ][oO];
OP_MLHZO: [mM][lL][hH][zZ][oO];
OP_MLLZO: [mM][lL][lL][zZ][oO];
OP_MOVE: [mM][oO][vV][eE];
OP_MOVEA: [mM][oO][vV][eE][aA];
OP_MOVEL: [mM][oO][vV][eE][lL];
OP_MULT: [mM][uU][lL][tT];
OP_MVR: [mM][vV][rR];
OP_NEXT: [nN][eE][xX][tT];
OP_OCCUR: [oO][cC][cC][uU][rR];
OP_ORxx: [oO][rR][0-9][0-9];
OP_OTHER: [oO][tT][hH][eE][rR];
OP_OUT: [oO][uU][tT];
OP_PARM: [pP][aA][rR][mM];
OP_PLIST: [pP][lL][iI][sS][tT];
OP_POST: [pP][oO][sS][tT];
OP_READ: [rR][eE][aA][dD];
OP_READC: [rR][eE][aA][dD][cC];
OP_READE: [rR][eE][aA][dD][eE];
OP_READP: [rR][eE][aA][dD][pP];
OP_READPE: [rR][eE][aA][dD][pP][eE];
OP_REL:[rR][eE][lL];
OP_RESET: [rR][eE][sS][eE][tT];
OP_RETURN: [rR][eE][tT][uU][rR][nN];
OP_ROLBK: [rR][oO][lL][bB][kK];
OP_SETON: [sS][eE][tT][oO][nN];
OP_SHTDN: [sS][hH][tT][dD][nN];
OP_SQRTA: [sS][qQ][rR][tT][aA];
OP_SQRT: [sS][qQ][rR][tT];
OP_SUB: [sS][uU][bB];
OP_SUBDUR: [sS][uU][bB][dD][uU][rR];
OP_SUBST: [sS][uU][bB][sS][tT];
OP_TAG: [tT][aA][gG];
OP_TEST: [tT][eE][sS][tT];
OP_TESTB: [tT][eE][sS][tT][bB];
OP_TESTN: [tT][eE][sS][tT][nN];
OP_TESTZ: [tT][eE][sS][tT][zZ];
OP_TIME: [tT][iI][mM][eE];
OP_UNLOCK: [uU][nN][lL][oO][cC][kK];
OP_UPDATE: [uU][pP][dD][aA][tT][eE];
OP_WHEN: [wW][hH][eE][nN];
OP_WHENxx: [wW][hH][eE][nN][0-9][0-9];
OP_WRITE: [wW][rR][iI][tT][eE];
OP_XFOOT: [xX][fF][oO][oO][tT];
OP_XLATE: [xX][lL][aA][tT][eE];
OP_Z_ADD: [zZ]'-'[aA][dD][dD];
OP_Z_SUB: [zZ]'-'[sS][uU][bB];

// Symbolic Constants
SPLAT_ALL: '*'[aA][lL][lL];
SPLAT_NONE: '*'[nN][oO][nN][eE];
SPLAT_YES: '*'[yY][eE][sS];
SPLAT_NO: '*'[nN][oO];
SPLAT_ILERPG: '*'[iI][lL][eE][rR][pP][gG];
SPLAT_COMPAT: '*'[cC][oO][mM][pP][aA][tT];
SPLAT_CRTBNDRPG: '*'[cC][rR][tT][bB][nN][dD][rR][pP][gG];
SPLAT_CRTRPGMOD: '*'[cC][rR][tT][rR][pP][gG][mM][oO][dD];
SPLAT_VRM: '*'[vV][0-9][rR][0-9][mM][0-9];
SPLAT_ALLG: '*'[aA][lL][lL][gG];
SPLAT_ALLU: '*'[aA][lL][lL][uU];
SPLAT_ALLTHREAD: '*'[aA][lL][lL][tT][hH][rR][eE][aA][dD];
SPLAT_ALLX: '*'[aA][lL][lL][xX];
SPLAT_BLANKS: ('*'[bB][lL][aA][nN][kK][sS] | '*'[bB][lL][aA][nN][kK]);
SPLAT_CANCL: '*'[cC][aA][nN][cC][lL];
SPLAT_CYMD: '*'[cC][yY][mM][dD]('0' | '/' | '-' | '.' | ',' | '&')?;
SPLAT_CMDY: '*'[cC][mM][dD][yY]('0' | '/' | '-' | '.' | ',' | '&')?;
SPLAT_CDMY: '*'[cC][dD][mM][yY]('0' | '/' | '-' | '.' | ',' | '&')?;
SPLAT_MDY: '*'[mM][dD][yY]('0' | '/' | '-' | '.' | ',' | '&')?;
SPLAT_DMY: '*'[dD][mM][yY]('0' | '/' | '-' | '.' | ',' | '&')?;
SPLAT_DFT: '*'[dD][fF][tT];
SPLAT_YMD: '*'[yY][mM][dD]('0' | '/' | '-' | '.' | ',' | '&')?;
SPLAT_JUL: '*'[jJ][uU][lL]('0' | '/' | '-' | '.' | ',' | '&')?;
SPLAT_JAVA: '*'[jJ][aA][vV][aA];
SPLAT_ISO: '*'[iI][sS][oO]('0' | '-')?;
SPLAT_USA: '*'[uU][sS][aA]('0' | '/')?;
SPLAT_EUR: '*'[eE][uU][rR]('0' | '.')?;
SPLAT_JIS: '*'[jJ][iI][sS]('0' | '-')?;
SPLAT_DATE: '*'[dD][aA][tT][eE];
SPLAT_DAY:  '*'[dD][aA][yY];
SPlAT_DETC: '*'[dD][eE][tT][cC];
SPLAT_DETL: '*'[dD][eE][tT][lL];
SPLAT_DTAARA: '*'[dD][tT][aA][aA][rR][aA];
SPLAT_END:  '*'[eE][nN][dD];
SPLAT_ENTRY: '*'[eE][nN][tT][rR][yY];
SPLAT_EQUATE: '*'[eE][qQ][uU][aA][tT][eE];
SPLAT_EXTDFT: '*'[eE][xX][tT][dD][fF][tT];
SPLAT_EXT: '*'[eE][xX][tT];
SPLAT_FILE: '*'[fF][iI][lL][eE];
SPLAT_GETIN: '*'[gG][eE][tT][iI][nN];
SPLAT_HIVAL: '*'[hH][iI][vV][aA][lL];
SPLAT_INIT: '*'[iI][nN][iI][tT];
SPLAT_INDICATOR: ('*'[iI][nN][0-9][0-9] | '*'[iI][nN]'('[0-9][0-9]')');
SPLAT_INZSR: '*'[iI][nN][zZ][sS][rR];
SPLAT_IN: '*'[iI][nN];
SPLAT_INPUT: '*'[iI][nN][pP][uU][tT];
SPLAT_OUTPUT: '*'[oO][uU][tT][pP][uU][tT];
SPLAT_JOBRUN: '*'[jJ][oO][bB][rR][uU][nN];
SPLAT_JOB: '*'[jJ][oO][bB];
SPLAT_LDA: '*'[lL][dD][aA];
SPLAT_LIKE: '*'[lL][iI][kK][eE];
SPLAT_LONGJUL: '*'[lL][oO][nN][gG][jJ][uU][lL];
SPLAT_LOVAL: '*'[lL][oO][vV][aA][lL];
SPLAT_KEY: '*'[kK][eE][yY];
SPLAT_MONTH: '*'[mM][oO][nN][tT][hH];
SPLAT_NEXT: '*'[nN][eE][xX][tT];
SPLAT_NOIND: '*'[nN][oO][iI][nN][dD];
SPLAT_NOKEY: '*'[nN][oO][kK][eE][yY];
SPLAT_NULL: '*'[nN][uU][lL][lL];
SPLAT_OFL: '*'[oO][fF][lL];
SPLAT_ON: '*'[oO][nN];
SPLAT_ONLY: '*'[oO][nN][lL][yY];
SPLAT_OFF: '*'[oO][fF][fF];
SPLAT_PDA: '*'[pP][dD][aA];
SPLAT_PLACE: '*'[pP][lL][aA][cC][eE];
SPLAT_PSSR: '*'[pP][sS][sS][rR];
SPLAT_ROUTINE: '*'[rR][oO][uU][tT][iI][nN][eE];
SPLAT_START: '*'[sS][tT][aA][rR][tT];
SPLAT_SYS: '*'[sS][yY][sS];
SPLAT_TERM: '*'[tT][eE][rR][mM];
SPLAT_TOTC: '*'[tT][oO][tT][cC];
SPLAT_TOTL: '*'[tT][oO][tT][lL];
SPLAT_USER: '*'[uU][sS][eE][rR];
SPLAT_VAR: '*'[vV][aA][rR];
SPLAT_YEAR: '*'[yY][eE][aA][rR];
SPLAT_ZEROS: ('*'[zZ][eE][rR][oO][sS] | '*'[zZ][eE][rR][oO]);
SPLAT_HMS: '*'[hH][mM][sS]('0' | '/' | '-' | '.' | ',' | '&')?;
SPLAT_INLR: '*'[iI][nN][lL][rR];
SPLAT_INOF: '*'[iI][nN][oO][fF];
SPLAT_DATA: '*'[dD][aA][tT][aA];
SPLAT_ASTFILL: '*'[aA][sS][tT][fF][iI][lL];
SPLAT_CURSYM: '*'[cC][uU][rR][sS][yY][mM];
SPLAT_MAX: '*'[mM][aA][xX];
SPLAT_LOCK: '*'[lL][oO][cC][kK];
SPLAT_PROGRAM: '*'[pP][rR][oO][gG][rR][aA][mM];
SPLAT_EXTDESC: '*'[eE][xX][tT][dD][eE][sS][cC];
//Durations
SPLAT_D: '*'{getLastTokenType() == COLON}? [dD];
SPLAT_H: '*'{getLastTokenType() == COLON}? [hH];
SPLAT_HOURS: '*'{getLastTokenType() == COLON}? [hH][oO][uU][rR][sS];
SPLAT_DAYS:  SPLAT_DAY[sS]{getLastTokenType() == COLON}?;
SPLAT_M: '*'{getLastTokenType() == COLON}? [mM];
SPLAT_MINUTES: '*'{getLastTokenType() == COLON}? [mM][iI][nN][uU][tT][eE][sS];
SPLAT_MONTHS: SPLAT_MONTH[sS];
SPLAT_MN: '*'{getLastTokenType() == COLON}? [mM][nN]; //Minutes
SPLAT_MS: '*'{getLastTokenType() == COLON}? [mM][sS]; //Minutes
SPLAT_MSECONDS: '*'{getLastTokenType() == COLON}? [mM][sS][eE][cC][oO][nN][dD][sS];
SPLAT_S: '*'{getLastTokenType() == COLON}? [sS];
SPLAT_SECONDS: '*'{getLastTokenType() == COLON}? [sS][eE][cC][oO][nN][dD][sS];
SPLAT_Y: '*'{getLastTokenType() == COLON}? [yY];
SPLAT_YEARS: SPLAT_YEAR[sS]{getLastTokenType() == COLON}?;

EXTFMT_OPTION_S: [sS];
EXTFMT_OPTION_P: [pP];
EXTFMT_OPTION_B: [bB];
EXTFMT_OPTION_L: [lL];
EXTFMT_OPTION_R: [rR];

EXTIND_INUX: '*'[iI][nN][uU][1-8];

OFLIND_INXX: '*'[iI][nN][0][a-gA-GvV];
OFLIND_INXY: '*'[iI][nN][0-9][1-9];

NUMBER: ([0-9]+([.][0-9]*)?) | [.][0-9]+;
ID: ('*' {getCharPositionInLine() > 7}? '*'? [a-zA-Z])? [#@%$a-zA-Z] {getCharPositionInLine() > 7}? [#@$a-zA-Z0-9_]*;

STRING_LITERAL_START: ['] -> pushMode(InString) ; 

//Newline
NEWLINE: ('\r'? '\n') -> skip;
//Skip spaces, tabs
WS: [ \t] {getCharPositionInLine() > 6}? [ \t]* -> skip;

mode InString;
//Any char except + - ', or a + or - followed by more than just whitespace
STRING_CONTENT: (~['\r\n+-] 
	| [+-] [ ]* {_input.LA(1) != ' ' && _input.LA(1) != '\r' && _input.LA(1) != '\n'}? // Plus is ok as long as it's not the last char
)+; //space or not
STRING_ESCAPED_QUOTE: [']['] {setText("'");};
STRING_LITERAL_END: ['] -> popMode;

//Definition Specification 
mode Definition;
BLACK_SPEC: '                                                                           ' 
	{getCharPositionInLine()==81}?;
DS_NAME: NAME5 NAME5 NAME5 {getCharPositionInLine() == 21}? {setText(getText().trim());};
DS_EXTERNAL_DESCRIPTION: [eE ] {getCharPositionInLine() == 22}?;
DS_DATA_STRUCT_TYPE: [sSuU ] {getCharPositionInLine() == 23}?;
DS_DEF_TYPE_DS: [dD][sS] {getCharPositionInLine() == 25}?;
DS_DEF_TYPE_C: [cC][ ] {getCharPositionInLine() == 25}?;
DS_DEF_TYPE_S: [sS][ ] {getCharPositionInLine() == 25}?;
DS_DEF_TYPE_BLACK: [ ][ ] {getCharPositionInLine() == 25}?;
DS_FROM_POSITION: WORD5 [a-zA-Z0-9 ][a-zA-Z0-9 ] {getCharPositionInLine() == 32}?;
DS_TO_POSITION: WORD5[a-zA-Z0-9 +-][a-zA-Z0-9 ] {getCharPositionInLine() == 39}?;
DS_INTERNAL_DATA_TYPE: [aAgGtTdDzZpPbBsS* ] {getCharPositionInLine() == 40}?;
DS_DECIMAL_POSITIONS: [0-9 ][0-9 ] {getCharPositionInLine() == 42}?;
DS_RESERVED: ' ' {getCharPositionInLine() == 43}? -> popMode;
DS_WS: [ \t] {getCharPositionInLine() >= 81}? [ \t]* -> skip; //skip spaces, tabs, newlines
DS_COMMENTS80: ~[\r\n] {getCharPositionInLine() >= 81}? ~[\r\n] -> channel(HIDDEN); //skip comments after 80
EOL: NEWLINE -> popMode;

//File Specification 
mode File;
FS_BLACK_SPEC: BLACK_SPEC -> type(BLACK_SPEC);
FS_RECORD_NAME: WORD5 WORD5 {getCharPositionInLine() == 16}?;
FS_TYPE: [iIoOuUcC] {getCharPositionInLine() == 17}?;
FS_DESIGNATION: [pPsSrRtTfF] {getCharPositionInLine() == 18}?;
FS_EOF: [ eE] {getCharPositionInLine() == 19}?;
FS_ADDUTION: [ aA] {getCharPositionInLine() == 20}?;
FS_SEQUENCE: [ aAdD] {getCharPositionInLine() == 21}?;
FS_FORMAT: [eEfF] {getCharPositionInLine() == 22}?;
FS_RECORD_LENGTH: [0-9 ][0-9 ][0-9 ][0-9 ][0-9 ] {getCharPositionInLine() == 27}?;
FS_LIMITS: [ lL] {getCharPositionInLine() == 28}?;
FS_LENGTH_OF_KEY: [0-9 ][0-9 ][0-9 ][0-9 ][0-9 ] {getCharPositionInLine() == 33}?;
FS_RECORD_ADDRESS_TYPE: [ aApPgGkKdDtTzZ] {getCharPositionInLine() == 34}?;
FS_ORGANIZATION: [ iItT] {getCharPositionInLine() == 35}?;
FS_DEVICE_PRINTER: [pP][rR][iI][nN][tT][eE][rR] {getCharPositionInLine() == 42}?;
FS_DEVICE_DISK: [dD][iI][sS][kK][ ][ ][ ] {getCharPositionInLine() == 42}?;
FS_DEVICE_WORKSTN: [wW][oO][rR][kK][sS][tT][nN] {getCharPositionInLine() == 42}?;
FS_DEVICE_SPECIAL: [sS][pP][eE][cC][iI][aA][lL] {getCharPositionInLine() == 42}?;
FS_RESERVED: [ ] {getCharPositionInLine() == 43}? -> popMode;
FS_WS: [ \t] {getCharPositionInLine() > 80}? [ \t]* -> skip; //skip spaces, tabs, newlines
FS_EOL: NEWLINE -> type(EOL), popMode;

//Output Specification 
mode Output;
OS_BLANK_SPEC: BLACK_SPEC -> type(BLACK_SPEC); 
OS_RECORD_NAME: WORD10_WCOLON {getCharPositionInLine() == 16}?;
OS_AND_OR: '         ' ([aA][nN][dD]|[oO][rR] ' ') '  ' -> pushMode(OnOffIndicator), pushMode(OnOffIndicator), pushMode(OnOffIndicator);
OS_FIELD_RESERVED: '              ' {getCharPositionInLine() == 20}? -> pushMode(OutputProgramField), pushMode(OnOffIndicator), pushMode(OnOffIndicator), pushMode(OnOffIndicator);
OS_TYPE: [hHdDtTeE] {getCharPositionInLine() == 17}?;
OS_ADD_DEL: ([aA][dD][dD] | [dD][eE][lL]) {getCharPositionInLine() == 20}? -> pushMode(OutputProgram), pushMode(OnOffIndicator), pushMode(OnOffIndicator), pushMode(OnOffIndicator);
OS_FETCH_OVERFLOW: (' ' | [rR]) '  ' {getCharPositionInLine() == 20}? -> pushMode(OnOffIndicator), pushMode(OnOffIndicator), pushMode(OnOffIndicator);
OS_EXCEPT_NAME: WORD10_WCOLON {getCharPositionInLine() == 39}?;
OS_SPACE3: [ 0-9][ 0-9][ 0-9] {getCharPositionInLine() == 42 || getCharPositionInLine() == 45 || getCharPositionInLine() == 48 || getCharPositionInLine() == 52}?;
OS_REMAINING_SPACE: '                             ' {getCharPositionInLine() == 80}?;
OS_COMMENTS: ~[\r\n] {getCharPositionInLine() > 80}? ~[\r\n]*;
OS_WS: [ \t] {getCharPositionInLine() > 80}? [ \t]* -> type(WS);
OS_EOL: NEWLINE -> type(EOL), popMode;

mode OutputProgram;
OS_PGM_EXCEPT_NAME: WORD10_WCOLON {getCharPositionInLine() == 39}? -> type(OS_EXCEPT_NAME);
OS_PGM_REMAINING_SPACE: '                                         ' {getCharPositionInLine() == 80}? -> type(OS_REMAINING_SPACE);

mode OutputProgramField;
OS_FIELD_NAME: WORD10_WCOLON ~[\r\n] ~[\r\n] ~[\r\n] ~[\r\n] {getCharPositionInLine() == 43}?;
OS_EDIT_NAMES: [ 1-9a-dA-Dj-qJ-QxXyYzZ] {getCharPositionInLine() == 44}?;
OS_BLACK_AFTER: [ bB] {getCharPositionInLine() == 45}?;
OS_REVERSED: [ ] {getCharPositionInLine() == 46}? -> skip;
OS_END_POSITION: WORD5 {getCharPositionInLine() == 51}?;
OS_DATA_FMT: [ pPbBlLrRdDtTzZaAsSgG] {getCharPositionInLine() == 52}? -> popMode;
OS_ANY: . -> popMode;

mode OnOffIndicator;
BLACK_FLAG: [ ] -> popMode, pushMode(Indicator);
NO_FLAG: [nN] -> popMode, pushMode(Indicator);

mode Indicator;
INDICATOR_BLACK: [ ][ ] -> popMode;
INDICATOR_GENERAL: ([0][1-9] | [1-9][0-9]) -> popMode;
INDICATOR_FUNC_KEY: [kK][a-np-yA-NP-Y] -> popMode;
INDICATOR_CONTROL_LEVEL: [lL][1-9] -> popMode;
INDICATOR_CONTROL_LEVEL_0: [lL][0] -> popMode; // Calculation
INDICATOR_LAST_RECORD: [lL][rR] -> popMode;
INDICATOR_MATCHING_RECORD: [mM][rR] -> popMode;
INDICATOR_HALT: [hH][1-9] -> popMode;
INDICATOR_RETURN: [rR][tT] -> popMode;
INDICATOR_EXTERNAL: [uU][1-8] -> popMode;
INDICATOR_OVERFLOW: [oO][A-GVa-gv] -> popMode;
INDICATOR_FIRST_PAGE: [1][pP] -> popMode;
INDICATOR_SUBROUTINE:[sS][rR] -> popMode; // Calculation
INDICATOR_AND: [aA][nN] -> popMode; // Calculation
INDICATOR_OR: [oO][rR] -> popMode; // Calculation

//Calculation Specification 
mode Calculation;
CS_FACTOR1_SPLAT_YMD: SPLAT_YMD {11 + 4 <= getCharPositionInLine() && getCharPositionInLine() <= 24}? -> type(SPLAT_YMD);
CS_FACTOR2_SPLAT_YMD: SPLAT_YMD {35 + 4 <= getCharPositionInLine() && getCharPositionInLine() <= 48}? -> type(SPLAT_YMD);

CS_BLACK_FACTOR: '              ' {(getCharPositionInLine() == 25) || (getCharPositionInLine() == 49) || (getCharPositionInLine() == 63)}?;
CS_BLACK_FACTOR_EOL: '              ' {getCharPositionInLine() == 25}? [ ]* NEWLINE -> type(EOL), popMode;
CS_FACTOR_WS: (' ' {(getCharPositionInLine() >= 12 && getCharPositionInLine() <= 25) || (getCharPositionInLine() >= 36 && getCharPositionInLine() <= 49)}?)+ -> skip;
CS_FACTOR_WS2: (' ' {getCharPositionInLine() >= 50 && getCharPositionInLine() <= 63}?)+ -> skip;
CS_FACTOR_CONTENT: (~[\r\n: '] {(getCharPositionInLine() >=12 && getCharPositionInLine() <= 25) || (getCharPositionInLine() >= 36 && getCharPositionInLine() <= 49)}?)+;
CS_RESULT_CONTENT:(~[\r\n: '] {getCharPositionInLine() >=50 && getCharPositionInLine() <= 63}?)+ -> type(CS_FACTOR_CONTENT);
CS_FACTOR_COLON: ([:] {(getCharPositionInLine() < 12 && getCharPositionInLine() < 25) || (getCharPositionInLine() > 36 && getCharPositionInLine() < 49) || (getCharPositionInLine() > 50 && getCharPositionInLine() < 63)}?) -> type(COLON); 
//Operation & Extender
CS_OPERATION_EXTENDER_BLACK: '          ' {getCharPositionInLine() == 35}?;
CS_OPERATION_EXTENDER_WS: ([ ] {getCharPositionInLine() >= 26 && getCharPositionInLine() <= 36}?)+ -> skip;
CS_OPERATION_EXTENDER: ([a-zA-Z0-9 ] {getCharPositionInLine() >= 26 && getCharPositionInLine() <= 35}?)+;
CS_OPERATION_EXTENDER_OPEN: OPEN_PAREN {getCharPositionInLine() >= 26 && getCharPositionInLine() <= 35}? -> type(OPEN_PAREN);
CS_OPERATION_EXTENDER_CLOSE: CLOSE_PAREN {getCharPositionInLine() >= 26 && getCharPositionInLine() <= 35}? (' ' {getCharPositionInLine() >= 26 && getCharPositionInLine() <= 35}?)* {setText(getText().trim());} -> type(CLOSE_PAREN);

CS_FIELD_LENGTH: [0-9 ][0-9 ][0-9 ][0-9 ][0-9 ] {getCharPositionInLine() == 68}?;
CS_DECIMAL_POSITIONS: [ 0-9][ 0-9] {getCharPositionInLine() == 70}? -> pushMode(Indicator), pushMode(Indicator), pushMode(Indicator); //3 indicators.

CS_WS: [ \t] {getCharPositionInLine() >= 77}? [ \t]* -> skip;
CS_COMMENTS: ~[\r\n] {getCharPositionInLine() > 80}? ~[\r\n]*;
CS_FIXED_COMMENTS: ~[\r\n] {getCharPositionInLine() >= 77}? ~[\r\n]*;
CS_EOL: NEWLINE -> type(EOL), popMode;

//Input Specification
mode Input;
IS_BLANK_SPEC :  
    '                                                                           ' 
    {getCharPositionInLine()==80}? -> type(BLACK_SPEC);
IS_FILE_NAME: WORD5_WCOLON WORD5_WCOLON {getCharPositionInLine() == 16}?;
IS_FIELD_RESERVED: '                        ' {getCharPositionInLine() == 30}? -> pushMode(InputField), skip;
IS_EXTERNAL_FIELD_RESERVED: '              ' {getCharPositionInLine() == 20}? -> pushMode(InputExternalField), skip;
IS_LOGICAL_RELATIONSHIP: ('AND' | 'OR ' | ' OR') {getCharPositionInLine() == 18}?;
IS_EXTERNAL_RECORE_RESERVED: '    ' {getCharPositionInLine() == 20}? -> pushMode(InputExternalRecord), pushMode(Indicator);
IS_SEQUENCE: WORD_WCOLON WORD_WCOLON {getCharPositionInLine() == 18}?;
IS_NUMBER: [ 1nN] {getCharPositionInLine() == 19}?;
IS_OPTION: [ oO] {getCharPositionInLine() == 20}? -> pushMode(Indicator);
IS_RECORD_ID_CODE: WORD10_WCOLON WORD10_WCOLON WORD4_WCOLON {getCharPositionInLine() == 46}?;
IS_WS: [ \t] {getCharPositionInLine() >= 47}? [ \t]* -> type(WS);
IS_COMMENTS: ~[\r\n] {getCharPositionInLine() > 80}? ~[\r\n]* -> channel(HIDDEN);
IS_EOL: NEWLINE -> type(EOL), popMode;

mode InputField;
ISFLD_DATE_FMT_EXT: WORD4_WCOLON {getCharPositionInLine() == 34}?;
ISFLD_DATE_SEPARATOR: ~[\r\n] {getCharPositionInLine() == 35}?;
ISFLD_DATE_FMT: [ pPbBlLrRdDtTzZaAsSgG] {getCharPositionInLine() == 36}?;
ISFLD_FIELD_LOCATION: WORD10_WCOLON {getCharPositionInLine() == 46}?;
ISFLD_DECIMAL_POSITIONS: [0-9][0-9] {getCharPositionInLine() == 48}?;
ISFLD_FIELD_NAME: WORD10_WCOLON WORD4_WCOLON {getCharPositionInLine() == 62}?;
ISFLD_CONTROL_LEVEL: ('L'[1-9] | '  ') {getCharPositionInLine() == 64}?;
ISFLD_MATCHING_FIELDS: ('M'[1-9] | '  ') {getCharPositionInLine() == 66}? -> pushMode(Indicator), pushMode(Indicator), pushMode(Indicator), pushMode(Indicator);
ISFLD_BLACKS: '      ' {getCharPositionInLine() == 80}? -> skip;
ISFLD_COMMENETS: ~[\r\n] {getCharPositionInLine() > 80}? ~[\r\n]* -> channel(HIDDEN);
ISFLD_EOL: NEWLINE -> type(EOL), popMode, popMode;

mode InputExternalField;
ISEXTFLD_NAME: WORD10_WCOLON {getCharPositionInLine() == 30}?;
ISEXTFLD_REVERVED: '                  ' {getCharPositionInLine() == 48}? -> skip;
ISEXTFLD_FIELD_NAME: WORD10_WCOLON WORD4_WCOLON {getCharPositionInLine() == 62}? -> pushMode(Indicator), pushMode(Indicator);
ISEXTFLD_REVERSED_2: '  ' {getCharPositionInLine() == 68}? -> pushMode(Indicator), pushMode(Indicator), pushMode(Indicator), skip; //3 indicators in a row.
ISEXTFLD_WS: [ \t] {getCharPositionInLine() >= 75}? -> type(WS), popMode; 

mode InputExternalRecord;
ISEXTREC_WS: [ \t] {getCharPositionInLine() >= 23}? [ \t]* -> type(WS), popMode;

//Control/Header Specification
mode Header;
HS_OPEN_PAREN: OPEN_PAREN -> type(OPEN_PAREN);
HS_CLOSE_PAREN: CLOSE_PAREN -> type(CLOSE_PAREN);
HS_StringLiteralStart: ['] -> type(STRING_LITERAL_START), pushMode(InString);
HS_COLON: ':' -> type(COLON);
HS_ID: [#@%$*a-zA-Z] [&#@\-$*a-zA-Z0-9_/,.]* -> type(ID);
HS_WS: [ \t]+ -> skip; //skip spaces, tabs, newlines
HS_CONTINUATION: NEWLINE WORD5 [hH] ~[*] -> skip;
HS_EOL: NEWLINE -> type(EOL), popMode;

//Comment mode
mode Comment;
COMMENTS_BLACK: [ ]+ -> skip;
COMMENTS_TEXT: ~[\r\n]+ {setText(getText().trim());} -> channel(HIDDEN);
COMMENTS_EOL: NEWLINE -> popMode, skip; 

fragment WORD5 : ~[\r\n]~[\r\n]~[\r\n]~[\r\n]~[\r\n];
fragment NAME5: NAMECHAR NAMECHAR NAMECHAR NAMECHAR NAMECHAR;
//valid characters in symbolic names.
fragment NAMECHAR: [A-Za-z0-9$#@_ ];
//name can not start with _ or numbers.
fragment INITNAMECHAR: [A-Za-z$#@];
fragment WORD_WCOLON: ~[\r\n]; //[a-zA-Z0-9 :*];
fragment WORD2_WCOLON: WORD_WCOLON WORD_WCOLON;
fragment WORD4_WCOLON: WORD2_WCOLON WORD2_WCOLON;
fragment WORD5_WCOLON: WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON;
fragment WORD10_WCOLON: WORD5_WCOLON WORD5_WCOLON;

