/*
	Brian Dooley - 15123529
*/
%{
	#include "project.tab.h"
%}
/*
	yytext stores text matched by current token
	yylval stores value and returns to bison
	noyywrap removes calls to yywrap
*/
%option noyywrap

%%
[\t\n ]+
BEGINING		{ return BEGINING; }
BODY			{ return BODY; }
PRINT			{ return PRINT; }
INPUT			{ return INPUT; }
MOVE			{ return MOVE; }
ADD			{ return ADD; }
TO			{ return TO; }
END			{ return END; }
[Xx]+			{ yylval.size = strlen(yytext); return VARIABLE_SIZE; }
;			{ return SEMICOLON; }
[0-9]+			{ yylval.size = atoi(yytext); return INTEGER; }
[a-zA-Z][a-zA-Z0-9\-]*	{ yylval.identifier = yytext; return IDENTIFIER; }
\"[^\"]*\"		{ return STRING; }
\.			{ return TERMINATOR; }
.			{ return EXIT_SUCCESS; }
%%
