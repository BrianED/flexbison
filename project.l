/*
Declarations and options
*/
%{

%}

/*
List of patterns and actions
*/
%%
[ \t]+			/* Ignore whitespace */
BEGINING		{ printf("Begining:%s ", yytext); }
BODY			{ printf("Body:%s ", yytext); }
PRINT			{ printf("Print:%s ", yytext); }
INPUT			{ printf("Input:%s ", yytext); }
MOVE			{ printf("Move:%s ", yytext); }
ADD			{ printf("Add:%s ", yytext); }
TO			{ printf("To:%s ", yytext); }
END			{ printf("End:%s ", yytext); }
X+			{ printf("Variable size:%s ", yytext); }
;			{ printf("Semicolon:%s ", yytext); }
[0-9]+			{ printf("Integer:%s ", yytext); }
[a-zA-Z0-9\-]+		{ printf("Identifier:%s ", yytext); }
\"(\\.|[^"\\])*\"	{ printf("String:%s ", yytext); }
\.			{ printf("Terminator:%s ", yytext); }
.			{ printf("**INVALID**:%s ", yytext); }
%%

/*
C code copied to generated scanner
*/
int main(int argc, char* argv[]) {
/*
	if (argc > 1) {
		if (!(yyin = fopen(argv[1], "r"))) {
			perror(argv[1]);
			return (1);
		}
	}
*/
	yylex();
}
