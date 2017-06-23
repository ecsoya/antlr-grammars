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
F_OPEN_PAREN: OPEN_PAREN -> type(OPEN_PAREN);
F_CLOSE_PAREN: CLOSE_PAREN -> type(CLOSE_PAREN);
F_COLON: COLON -> type(COLON);

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

EXTIND_INUX: '*'[iI][nN][uU][1-8];

OFLIND_INXX: '*'[iI][nN][0][a-gA-GvV];
OFLIND_INXY: '*'[iI][nN][0-9][1-9];

AMPERSAND: '&';
MINUS : '-' ;
DOT: '.';
DIV: '/';
COMMA: ',';

FREE_ID: ID -> type(ID);
StringLiteralStart: ['] -> pushMode(InStringMode);
FREE_WS: [ \t] {getCharPositionInLine()>6}? [ \t]* -> skip;
F_FREE_NEWLINE: NEWLINE {_modeStack.peek() == FileSpecMode}? -> type(EOL),popMode,popMode;

fragment WORD5 : ~[\r\n]~[\r\n]~[\r\n]~[\r\n]~[\r\n];
fragment NAME5: NAMECHAR NAMECHAR NAMECHAR NAMECHAR NAMECHAR;
//valid characters in symbolic names.
fragment NAMECHAR: [A-Za-z0-9$#@_ ];
//name can not start with _ or numbers.
fragment INITNAMECHAR: [A-Za-z$#@];
fragment WORD_WCOLON: ~[\r\n]; //[a-zA-Z0-9 :*];
fragment WORD5_W_COLON: WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON;
