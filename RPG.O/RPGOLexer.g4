/**
 * Antlr4 Lexer for IBM RPG Language's Output Specification
 */
lexer grammar RPGOLexer;

//Parser Rules
//End Source. No more parsing after this
END_SOURCE: '**' {getCharPositionInLine() == 2}? ~[\r\n]~[\r\n]~[\r\n]~[\r\n*]~[\r\n]* EOL -> pushMode(EndOfSourceMode);
//Ignore or skip leading 5 white space
LEAD_WS5: '     ' {getCharPositionInLine() == 5}? -> skip;
LEAD_WS5_COMMENTS: WORD5 {getCharPositionInLine() == 5}? -> channel(HIDDEN);
//Column 6 * means comment
COMMENT_SPEC_FIXED: {getCharPositionInLine() == 5}? .'*' -> pushMode(CommentMode), channel(HIDDEN);

RPG_O: [oO] {getCharPositionInLine() == 6}? -> pushMode(OutputSpecMode);

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
BLANK_SPEC :  
	'                                                                           ' 
	{getCharPositionInLine()==81}?;
mode CommentMode;
BLACK_COMMENT_TEXT: [ ]+ -> skip;
COMMENT_TEXT: ~[\r\n]+ {setText(getText().trim());} -> channel(HIDDEN);
COMMNET_EOL: NEWLINE -> popMode, skip;

mode OutputSpecMode;
OS_BLANK_SPEC: BLANK_SPEC -> type(BLANK_SPEC); 
OS_RECORD_NAME: WORD10_WCOLON {getCharPositionInLine() == 16}?;
OS_AND_OR: '         ' ([aA][nN][dD]|[oO][rR] ' ') '  ' -> pushMode(OnOffIndicatorMode), pushMode(OnOffIndicatorMode), pushMode(OnOffIndicatorMode);
OS_FIELD_RESERVED: '              ' {getCharPositionInLine() == 20}? -> pushMode(OSpecProgramFieldMode), pushMode(OnOffIndicatorMode), pushMode(OnOffIndicatorMode), pushMode(OnOffIndicatorMode);
OS_TYPE: [hHdDtTeE] {getCharPositionInLine() == 17}?;
OS_ADD_DEL: ([aA][dD][dD] | [dD][eE][lL]) {getCharPositionInLine() == 20}? -> pushMode(OSpecProgramMode), pushMode(OnOffIndicatorMode), pushMode(OnOffIndicatorMode), pushMode(OnOffIndicatorMode);
OS_FETCH_OVERFLOW: (' ' | [rR]) '  ' {getCharPositionInLine() == 20}? -> pushMode(OnOffIndicatorMode), pushMode(OnOffIndicatorMode), pushMode(OnOffIndicatorMode);
OS_EXCEPT_NAME: WORD10_WCOLON {getCharPositionInLine() == 39}?;
OS_SPACE3: [ 0-9][ 0-9][ 0-9] {getCharPositionInLine() == 42 || getCharPositionInLine() == 45 || getCharPositionInLine() == 48 || getCharPositionInLine() == 52}?;
OS_REMAINING_SPACE: '                             ' {getCharPositionInLine() == 80}?;
OS_COMMENTS: ~[\r\n] {getCharPositionInLine() > 80}? ~[\r\n]*;
OS_WS: [ \t] {getCharPositionInLine() > 80}? [ \t]* -> type(WS);
OS_EOL: NEWLINE -> type(EOL), popMode;

mode OSpecProgramMode;
OS_PGM_EXCEPT_NAME: WORD10_WCOLON {getCharPositionInLine() == 39}? -> type(OS_EXCEPT_NAME);
OS_PGM_REMAINING_SPACE: '                                         ' {getCharPositionInLine() == 80}? -> type(OS_REMAINING_SPACE);

mode OSpecProgramFieldMode;
OS_FIELD_NAME: WORD10_WCOLON ~[\r\n] ~[\r\n] ~[\r\n] ~[\r\n] {getCharPositionInLine() == 43}?;
OS_EDIT_NAMES: [ 1-9a-dA-Dj-qJ-QxXyYzZ] {getCharPositionInLine() == 44}?;
OS_BLACK_AFTER: [ bB] {getCharPositionInLine() == 45}?;
OS_REVERSED: [ ] {getCharPositionInLine() == 46}? -> skip;
OS_END_POSITION: WORD5 {getCharPositionInLine() == 51}?;
OS_DATA_FMT: [ pPbBlLrRdDtTzZaAsSgG] {getCharPositionInLine() == 52}? -> pushMode(FREE);
OS_ANY: . -> popMode;

mode OnOffIndicatorMode;
BLACK_FLAG: [ ] -> popMode, pushMode(IndicatorMode);
NO_FLAG: [nN] -> popMode, pushMode(IndicatorMode);

mode IndicatorMode;
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

mode FREE;

SPLAT_ALL: '*'[aA][lL][lL];
SPLAT_YMD: '*'[yY][mM][dD];


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
fragment WORD2_WCOLON: WORD_WCOLON WORD_WCOLON;
fragment WORD4_WCOLON: WORD2_WCOLON WORD2_WCOLON;
fragment WORD5_WCOLON: WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON WORD_WCOLON;
fragment WORD10_WCOLON: WORD5_WCOLON WORD5_WCOLON;

