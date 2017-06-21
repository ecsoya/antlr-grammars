/**
 * Antlr4 Lexer for IBM RPG Language's Define Specification
 */
lexer grammar RPGDLexer;

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
D_SPEC: [dD] {getCharPositionInLine() == 6}? -> pushMode(DS_MODE);

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

mode DS_MODE;
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
DS_RESERVED: ' ' {getCharPositionInLine() == 43}? -> pushMode(FREE);
DS_WS: [ \t] {getCharPositionInLine() >= 81}? [ \t]* -> skip; //skip spaces, tabs, newlines
DS_COMMENTS80: ~[\r\n] {getCharPositionInLine() >= 81}? ~[\r\n] -> channel(HIDDEN); //skip comments after 80
EOL: NEWLINE -> popMode;

mode FREE;

//Define Specification Keywords
KEYWORD_ALT : [Aa][Ll][Tt];
KEYWORD_ASCEND : [Aa][Ss][Cc][Ee][Nn][Dd];
KEYWORD_BASED : [Bb][Aa][Ss][Ee][Dd];
KEYWORD_CONST : [Cc][Oo][Nn][Ss][Tt];
KEYWORD_CTDATA : [Cc][Tt][Dd][Aa][Tt][Aa];
KEYWORD_DATFMT : [Dd][Aa][Tt][Ff][Mm][Tt];
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
KEYWORD_PREFIX : [Pp][Rr][Ee][Ff][Ii][Xx];
KEYWORD_PROCPTR : [Pp][Rr][Oo][Cc][Pp][Tt][Rr];
KEYWORD_TIMFMT : [Tt][Ii][Mm][Ff][Mm][Tt];
KEYWORD_TOFILE : [Tt][Oo][Ff][Ii][Ll][Ee];

EXTFMT_OPTION_S: [sS];
EXTFMT_OPTION_P: [pP];
EXTFMT_OPTION_B: [bB];
EXTFMT_OPTION_L: [lL];
EXTFMT_OPTION_R: [rR];

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
