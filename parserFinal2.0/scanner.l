%{
#include "parser.tab.h"
int yylineno = 1;
int yycolumn = 1;
%}

%%

\n           { yylineno++; yycolumn = 1; }
[a-zA-Z_][a-zA-Z0-9_]* { yycolumn += yyleng; return IDENTIFICADOR; }
"="                    { yycolumn += yyleng; return '='; }
";"                    { yycolumn += yyleng; return ';'; }
[ \t]                  { yycolumn += yyleng; /* Ignorar espacios y tabs */ }
.                      { yycolumn += yyleng; return yytext[0]; }


%%

int yywrap() {
    return 1;
}
