/**
 * Antlr4 Lexer for IBM RPG Language's Control Specification
 */
lexer grammar RPGHLexer;

//Parser Rules
//Ignore or skip leading 5 white space
LEAD_WS5: '     ' {getCharPositionInLine() == 5}? -> skip;
LEAD_WS5_COMMENTS: WORD5 {getCharPositionInLine() == 5}? -> channel(HIDDEN);

//Column 6 * means comment
COMMENT_SPEC_FIXED: {getCharPositionInLine() == 6}? .'*' -> pushMode(M_COMMENT), channel(HIDDEN);

RPG_HS: [hH] {getCharPositionInLine() == 6}? -> pushMode(M_HS);

BLACK_LINE: [ ] {getCharPositionInLine() == 6}? [ ]* NEWLINE -> skip;
BLACK_SPEC_LINE1: . NEWLINE {getCharPositionInLine() == 7}? ->skip;
BLACK_SPEC_LINE: .[ ] {getCharPositionInLine() == 7}? [ ]* NEWLINE -> skip;
COMMENTS: [ ] {getCharPositionInLine() >= 6}? [ ]*? '//' -> pushMode(M_COMMENT), channel(HIDDEN);
EMPTY_LINE: '                                                                           ' 
	{getCharPositionInLine() >= 80}? -> pushMode(M_COMMENT), channel(HIDDEN);

OPEN_PAREN: '(';
CLOSE_PAREN: ')';
NUMBER: ([0-9]+([.][0-9]*)?) | [.][0-9]+;
SEMI: ';';
COLON: ':';
EOL: NEWLINE;
ID : ('*' {getCharPositionInLine()>7}? '*'? [a-zA-Z])?
        [#@$a-zA-Z]{getCharPositionInLine()>7}? [#@$a-zA-Z0-9_]* ;
NEWLINE : ('\r'? '\n') -> skip;
WS: [ \t] {getCharPositionInLine() > 6}? [ \t]* -> skip; //skip spaces, tabs

mode M_COMMENT;
BLACK_COMMENT_TEXT: [ ]+ -> skip;
COMMENT_TEXT: ~[\r\n]+ {setText(getText().trim());} -> channel(HIDDEN);
COMMNET_EOL: NEWLINE -> popMode, skip;

mode M_HS;
HS_OPEN_PAREN: OPEN_PAREN -> type(OPEN_PAREN);
HS_CLOSE_PAREN: CLOSE_PAREN -> type(CLOSE_PAREN);
HS_ID: ID -> type(ID);
HS_CURSYM: '\''~[ *&.,0-]'\'';

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

//DECEDIT value
DECEDIT_1: ['][.]['];
DECEDIT_2: ['][,]['];
DECEDIT_3: ['][0][.]['];
DECEDIT_4: ['][0][,]['];

//Options
OPTION_NONE: '*'[nN][oO][nN][eE];
OPTION_SRC: '*'[sS][rR][cC];
OPTION_EXT: '*'[eE][xX][tT];
OPTION_NO: '*'[nN][oO];
OPTION_YES: '*'[yY][eE][sS];

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

DIV : '/' ;
AMPERSAND: '&';
MINUS : '-' ;
DOT: '.';
COMMA: ',';

fragment WORD5 : ~[\r\n]~[\r\n]~[\r\n]~[\r\n]~[\r\n];
fragment NAME5: NAMECHAR NAMECHAR NAMECHAR NAMECHAR NAMECHAR;
//valid characters in symbolic names.
fragment NAMECHAR: [A-Za-z0-9$#@_ ];
//name can not start with _ or numbers.
fragment INITNAMECHAR: [A-Za-z$#@];
fragment WORD_WCOLON: ~[\r\n]; //[a-zA-Z0-9 :*];
fragment WORD5_W_COLON: WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON;

