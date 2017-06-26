/**
 * Antlr4 Lexer for IBM RPG Language's Calculation Specification
 */
lexer grammar RPGCLexer;

//Parser Rules
//End Source. No more parsing after this
END_SOURCE: '**' {getCharPositionInLine() == 2}? ~[\r\n]~[\r\n]~[\r\n]~[\r\n*]~[\r\n]* EOL -> pushMode(EndOfSourceMode);
//Ignore or skip leading 5 white space
LEAD_WS5: '     ' {getCharPositionInLine() == 5}? -> skip;
LEAD_WS5_COMMENTS: WORD5 {getCharPositionInLine() == 5}? -> channel(HIDDEN);
//Column 6 * means comment
COMMENT_SPEC_FIXED: {getCharPositionInLine() == 5}? .'*' -> pushMode(CommentMode), channel(HIDDEN);

RPG_C: [cC] {getCharPositionInLine() == 6}? -> pushMode(CalcSpecMode), pushMode(OnOffIndicatorMode), pushMode(IndicatorMode);

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

mode CalcSpecMode;
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
CS_DECIMAL_POSITIONS: [ 0-9][ 0-9] {getCharPositionInLine() == 70}? -> pushMode(IndicatorMode), pushMode(IndicatorMode), pushMode(IndicatorMode); //3 indicators.

CS_WS: [ \t] {getCharPositionInLine() >= 77}? [ \t]* -> skip;
CS_COMMENTS: ~[\r\n] {getCharPositionInLine() > 80}? ~[\r\n]*;
CS_FIXED_COMMENTS: ~[\r\n] {getCharPositionInLine() >= 77}? ~[\r\n]*;
CS_EOL: NEWLINE -> type(EOL), popMode;

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

mode OpCodes;
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

