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
BEGINING |
BODY |
PRINT |
INPUT |
MOVE |
ADD |
TO |
END			{ printf("%s Keyword ", yytext); }
^X+			{ printf("Variable size:%s ", yytext); }
;			{ printf("Semicolon:%s ", yytext); }
[Xx]{2,}[a-zA-Z0-9\-]* 	{ printf("Invalid Identifier:%s ", yytext); }
[a-zA-Z][a-zA-Z0-9\-]*	{ printf("Identifier:%s ", yytext); }
[0-9]+[a-zA-Z0-9\-]*	{ printf("Invalid Identifier:%s ", yytext); }
\"[^\"]*\"		{ printf("String:%s ", yytext); }
\.			{ printf("Terminator:%s ", yytext); }
.			{ printf("Invalid:%s ", yytext); }
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
