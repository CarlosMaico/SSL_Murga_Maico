%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* External declarations of functions and variables */
extern void add_identifier(char *name);
extern void add_string_literal(char *value);
extern void add_keyword(char *name, int line, int column);
extern void add_decimal_constant(int value);
extern void add_hex_constant(int value);
extern void add_octal_constant(int value);
extern void add_real_constant(double value);
extern void add_character_constant(char value);
extern void add_punctuation(char *symbol);
extern void report_unrecognized(char *text, int line, int column);

extern int yylineno;
extern int yycolumn;
#define YY_USER_ACTION yycolumn += yyleng;

%}

%%

[ \t\n]                      { /* Ignore whitespace */ }
"//".*                       { /* Ignore single-line comments */ }
"/*"([^*]|(\*+[^*/]))*"*/"   { /* Ignore multi-line comments */ }

(auto|break|case|char|const|default|do|double|else|enum|float|for|goto|if|int|long|return|short|signed|sizeof|static|struct|switch|typedef|unsigned|void|while)       { add_keyword(yytext, yylineno, yycolumn); }

[0-9]+                      { add_decimal_constant(atoi(yytext)); }
0[xX][0-9a-fA-F]+           { add_hex_constant(strtol(yytext, NULL, 16)); }
0[0-7]+                     { add_octal_constant(strtol(yytext, NULL, 8)); }
[0-9]+"."[0-9]*             { add_real_constant(atof(yytext)); }
"'"([^'\\]|\\['"\\?\\abfnrtv]|\\[0-7]{1,3}|\\x[0-9A-Fa-f]+)?"'" { add_character_constant(yytext[1]); }
\"([^"\\]|\\["\\])*\"       { add_string_literal(yytext); }

[_a-zA-Z][_a-zA-Z0-9]*      { add_identifier(yytext); }
.                           { add_punctuation(yytext); }
%%

int yywrap() {
    return 1;
}