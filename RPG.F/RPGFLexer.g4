/**
 * Antlr4 Lexer for IBM RPG Language's File Specification
 */
lexer grammar RPGFLexer;

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

//Parser Rules
//End Source. No more parsing after this
END_SOURCE: '**' {getCharPositionInLine() == 2}? ~[\r\n]~[\r\n]~[\r\n]~[\r\n*]~[\r\n]* EOL -> pushMode(EndOfSourceMode);
//Ignore or skip leading 5 white space
LEAD_WS5: '     ' {getCharPositionInLine() == 5}? -> skip;
LEAD_WS5_COMMENTS: WORD5 {getCharPositionInLine() == 5}? -> channel(HIDDEN);
//Column 6 * means comment
COMMENT_SPEC_FIXED: {getCharPositionInLine() == 5}? .'*' -> pushMode(CommentMode), channel(HIDDEN);

//Specifications
D_SPEC: [dD] {getCharPositionInLine() == 6}? -> pushMode(DefSpecMode);
F_SPEC: [fF] {getCharPositionInLine() == 6}? -> pushMode(FileSpecMode);

BLACK_LINE: [ ] {getCharPositionInLine() == 6}? [ ]* NEWLINE -> skip;
BLACK_SPEC_LINE1: . NEWLINE {getCharPositionInLine() == 7}? ->skip;
BLACK_SPEC_LINE: .[ ] {getCharPositionInLine() == 7}? [ ]* NEWLINE -> skip;
COMMENTS: [ ] {getCharPositionInLine() >= 6}? [ ]*? '//' -> pushMode(CommentMode), channel(HIDDEN);
EMPTY_LINE: '                                                                           ' 
	{getCharPositionInLine() >= 80}? -> pushMode(CommentMode), channel(HIDDEN);
	
OPEN_PAREN: '(';
CLOSE_PAREN: ')';
NUMBER: ([0-9]+([.][0-9]*)?) | [.][0-9]+;
SEMI: ';';
COLON: ':';
ID: ('*' {getCharPositionInLine() > 7}? '*'? [a-zA-Z])?
		[#@%$a-zA-Z] {getCharPositionInLine() > 7}? [#@$a-zA-Z0-9_]*;
NEWLINE : ('\r'? '\n') -> skip;
WS: [ \t] {getCharPositionInLine() > 6}? [ \t]* -> skip; //skip spaces, tabs

StringLiteralStart: ['] -> pushMode(InStringMode);

mode CommentMode;
BLACK_COMMENT_TEXT: [ ]+ -> skip;
COMMENT_TEXT: ~[\r\n]+ {setText(getText().trim());} -> channel(HIDDEN);
COMMNET_EOL: NEWLINE -> popMode, skip;


mode InStringMode;
//Any char except + - ', or a + or - followed by more than just whitespace
StringContent: (~['\r\n+-] 
	| [+-] [ ]* {_input.LA(1) != ' ' && _input.LA(1) != '\r' && _input.LA(1) != '\n'}? // Plus is ok as long as it's not the last char
)+; //space or not
StringEscapedQuote: [']['] {setText("'");};
StringLiteralEnd: ['] -> popMode;

mode EndOfSourceMode;
EOS_Text: ~[\r\n]+;
EOS_EOL: NEWLINE -> type(EOL);

mode DefSpecMode;
BLACK_SPEC: '                                                                           ' 
	{getCharPositionInLine()==81}?;
EOL: NEWLINE -> popMode;


mode FileSpecMode;
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
FS_RESERVED: [ ] {getCharPositionInLine() == 43}? -> pushMode(FREE);
FS_WS: [ \t] {getCharPositionInLine() > 80}? [ \t]* -> skip; //skip spaces, tabs, newlines
FS_EOL: NEWLINE -> type(EOL), popMode;

mode FREE;

//Symbolic Constants
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

// File spec keywords
KEYWORD_COMMIT : [cC][oO][mM][mM][iI][tT]; 
KEYWORD_DATFMT : [Dd][Aa][Tt][Ff][Mm][Tt];
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
KEYWORD_TIMFMT: [tT][iI][mM][fF][mM][tT];
KEYWORD_USROPN : [uU][sS][rR][oO][pP][nN];

AMPERSAND: '&';
MINUS : '-' ;
DOT: '.';
DIV: '/';
COMMA: ',';

fragment WORD5 : ~[\r\n]~[\r\n]~[\r\n]~[\r\n]~[\r\n];
fragment NAME5: NAMECHAR NAMECHAR NAMECHAR NAMECHAR NAMECHAR;
//valid characters in symbolic names.
fragment NAMECHAR: [A-Za-z0-9$#@_ ];
//name can not start with _ or numbers.
fragment INITNAMECHAR: [A-Za-z$#@];
fragment WORD_WCOLON: ~[\r\n]; //[a-zA-Z0-9 :*];
fragment WORD5_W_COLON: WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON;
