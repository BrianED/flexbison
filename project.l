%{

%}

%option noyywrap
%%
[\t ]+

is |
am |
are |
were |
was |
go |
want { printf("%s: is a verb\n", yytext); }
[a-zA-Z]+ { printf("%s: is not a verb\n", yytext); }
.|\n {ECHO; }
%%
main() {
	yylex();
	printf("Hello, world!");
}
