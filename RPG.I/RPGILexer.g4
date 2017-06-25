/**
 * Antlr4 Lexer for IBM RPG Language's Input Specification
 */
lexer grammar RPGILexer;

//Parser Rules
//End Source. No more parsing after this
END_SOURCE: '**' {getCharPositionInLine() == 2}? ~[\r\n]~[\r\n]~[\r\n]~[\r\n*]~[\r\n]* EOL -> pushMode(EndOfSourceMode);
//Ignore or skip leading 5 white space
LEAD_WS5: '     ' {getCharPositionInLine() == 5}? -> skip;
LEAD_WS5_COMMENTS: WORD5 {getCharPositionInLine() == 5}? -> channel(HIDDEN);
//Column 6 * means comment
COMMENT_SPEC_FIXED: {getCharPositionInLine() == 5}? .'*' -> pushMode(CommentMode), channel(HIDDEN);

RPG_I: [iI] {getCharPositionInLine() == 6}? -> pushMode(InputSpecMode);

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

mode InputSpecMode;
IS_BLANK_SPEC :  
    '                                                                           ' 
    {getCharPositionInLine()==80}? -> type(BLANK_SPEC);
IS_FILE_NAME: WORD5_WCOLON WORD5_WCOLON {getCharPositionInLine() == 16}?;
IS_FIELD_RESERVED: '                        ' {getCharPositionInLine() == 30}? -> pushMode(FieldSpecMode), skip;
IS_EXTERNAL_FIELD_RESERVED: '              ' {getCharPositionInLine() == 20}? -> pushMode(ExternalFieldMode), skip;
IS_LOGICAL_RELATIONSHIP: ('AND' | 'OR ' | ' OR') {getCharPositionInLine() == 18}?;
IS_EXTERNAL_RECORE_RESERVED: '    ' {getCharPositionInLine() == 20}? -> pushMode(ExternalRecordMode), pushMode(IndicatorMode);
IS_SEQUENCE: WORD_WCOLON WORD_WCOLON {getCharPositionInLine() == 18}?;
IS_NUMBER: [ 1nN] {getCharPositionInLine() == 19}?;
IS_OPTION: [ oO] {getCharPositionInLine() == 20}? -> pushMode(IndicatorMode);
IS_RECORD_ID_CODE: WORD10_WCOLON WORD10_WCOLON WORD4_WCOLON {getCharPositionInLine() == 46}?;
IS_WS: [ \t] {getCharPositionInLine() >= 47}? [ \t]* -> type(WS);
IS_COMMENTS: ~[\r\n] {getCharPositionInLine() > 80}? ~[\r\n]* -> channel(HIDDEN);
IS_EOL: NEWLINE -> type(EOL), popMode;

mode FieldSpecMode;
ISFLD_DATE_FMT_EXT: WORD4_WCOLON {getCharPositionInLine() == 34}?;
ISFLD_DATE_SEPARATOR: ~[\r\n] {getCharPositionInLine() == 35}?;
ISFLD_DATE_FMT: [ pPbBlLrRdDtTzZaAsSgG] {getCharPositionInLine() == 36}?;
ISFLD_FIELD_LOCATION: WORD10_WCOLON {getCharPositionInLine() == 46}?;
ISFLD_DECIMAL_POSITIONS: [0-9][0-9] {getCharPositionInLine() == 48}?;
ISFLD_FIELD_NAME: WORD10_WCOLON WORD4_WCOLON {getCharPositionInLine() == 62}?;
ISFLD_CONTROL_LEVEL: ('L'[1-9] | '  ') {getCharPositionInLine() == 64}?;
ISFLD_MATCHING_FIELDS: ('M'[1-9] | '  ') {getCharPositionInLine() == 66}? -> pushMode(IndicatorMode), pushMode(IndicatorMode), pushMode(IndicatorMode), pushMode(IndicatorMode);
ISFLD_BLACKS: '      ' {getCharPositionInLine() == 80}? -> skip;
ISFLD_COMMENETS: ~[\r\n] {getCharPositionInLine() > 80}? ~[\r\n]* -> channel(HIDDEN);
ISFLD_EOL: NEWLINE -> type(EOL), popMode, popMode;

mode ExternalFieldMode;
ISEXTFLD_NAME: WORD10_WCOLON {getCharPositionInLine() == 30}?;
ISEXTFLD_REVERVED: '                  ' {getCharPositionInLine() == 48}? -> skip;
ISEXTFLD_FIELD_NAME: WORD10_WCOLON WORD4_WCOLON {getCharPositionInLine() == 62}? -> pushMode(IndicatorMode), pushMode(IndicatorMode);
ISEXTFLD_REVERSED_2: '  ' {getCharPositionInLine() == 68}? -> pushMode(IndicatorMode), pushMode(IndicatorMode), pushMode(IndicatorMode), skip; //3 indicators in a row.
ISEXTFLD_WS: [ \t] {getCharPositionInLine() >= 75}? -> type(WS), popMode, skip; 

mode ExternalRecordMode;
ISEXTREC_WS: [ \t] {getCharPositionInLine() >= 23}? [ \t]* -> type(WS), popMode;

mode IndicatorMode;
INDICATOR_BLACK: [ ][ ] -> popMode;
INDICATOR_GENERAL: ([0][1-9] | [1-9][0-9]) -> popMode;
INDICATOR_FUNC_KEY: [kK][a-np-yA-NP-Y] -> popMode;
INDICATOR_CONTROL_LEVEL: [lL][1-9] -> popMode;
INDICATOR_LAST_RECORD: [lL][rR] -> popMode;
INDICATOR_MATCHING_RECORD: [mM][rR] -> popMode;
INDICATOR_HALT: [hH][1-9] -> popMode;
INDICATOR_RETURN: [rR][tT] -> popMode;
INDICATOR_EXTERNAL: [uU][1-8] -> popMode;
INDICATOR_OVERFLOW: [oO][A-GVa-gv] -> popMode;
INDICATOR_FIRST_PAGE: [1][pP] -> popMode;

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

