/**
 * Antlr4 Lexer for IBM RPG Language's Control Specification
 */
lexer grammar RPGHLexer;

//Parser Rules
//End Source. No more parsing after this
END_SOURCE: '**' {getCharPositionInLine() == 2}? ~[\r\n]~[\r\n]~[\r\n]~[\r\n*]~[\r\n]* EOL -> pushMode(EndOfSourceMode);
//Ignore or skip leading 5 white space
LEAD_WS5: '     ' {getCharPositionInLine() == 5}? -> skip;
LEAD_WS5_COMMENTS: WORD5 {getCharPositionInLine() == 5}? -> channel(HIDDEN);
//Column 6 * means comment
COMMENT_SPEC_FIXED: {getCharPositionInLine() == 5}? .'*' -> pushMode(CommentMode), channel(HIDDEN);

HS_INDICATOR: [hH] {getCharPositionInLine() == 6}? -> pushMode(ControlSpecMode);

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
EOL: NEWLINE;
ID: ('*' {getCharPositionInLine() > 7}? '*'? [a-zA-Z])?
		[#@%$a-zA-Z] {getCharPositionInLine() > 7}? [#@$a-zA-Z0-9_]*;
NEWLINE : ('\r'? '\n') -> skip;
WS: [ \t] {getCharPositionInLine() > 6}? [ \t]* -> skip; //skip spaces, tabs

StringLiteralStart: ['] -> pushMode(InStringMode);

mode CommentMode;
BLACK_COMMENT_TEXT: [ ]+ -> skip;
COMMENT_TEXT: ~[\r\n]+ {setText(getText().trim());} -> channel(HIDDEN);
COMMNET_EOL: NEWLINE -> popMode, skip;

mode ControlSpecMode;
CS_OPEN_PAREN: OPEN_PAREN -> type(OPEN_PAREN);
CS_CLOSE_PAREN: CLOSE_PAREN -> type(CLOSE_PAREN);
CS_StringLiteralStart: ['] -> type(StringLiteralStart), pushMode(InStringMode);
CS_COLON: ':' -> type(COLON);
CS_ID: [#@%$*a-zA-Z] [&#@\-$*a-zA-Z0-9_/,.]* -> type(ID);
CS_WhiteSpace: [ \t]+ -> skip; //skip spaces, tabs, newlines
CS_CONTINUATION: NEWLINE WORD5 [hH] ~[*] -> skip;
CS_EOL: NEWLINE -> type(EOL), popMode;

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

fragment WORD5 : ~[\r\n]~[\r\n]~[\r\n]~[\r\n]~[\r\n];
fragment NAME5: NAMECHAR NAMECHAR NAMECHAR NAMECHAR NAMECHAR;
//valid characters in symbolic names.
fragment NAMECHAR: [A-Za-z0-9$#@_ ];
//name can not start with _ or numbers.
fragment INITNAMECHAR: [A-Za-z$#@];
fragment WORD_WCOLON: ~[\r\n]; //[a-zA-Z0-9 :*];
fragment WORD5_W_COLON: WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON;

