/*
Brian Dooley - 15123529
*/

/*
Notes
https://www.youtube.com/watch?v=__-wUHG2rfM&feature=youtu.be&fbclid=IwAR1oGAGgWWpl8N673FjvsBdzDlRZclbEOf5TlxpOFMED88TxnrlNL3NBZwc

https://www.genivia.com/doc/reflex/html/
*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define SIZE 100

/* Prototypes */
void yyerror(char *s);
void moveIntegerToVariable(int newNum, char *variable);
void addVariable(int size, char *name);
void moveIdentifierToVariable(char *variable1, char *variable2);
int getVarSize(char *variable);
void checkDeclaration(char *variable);
int checkVariable(char *variable);
void lastCharDel(char* name);

char identifiers[SIZE][SIZE];
int sizes[SIZE];
int variableCount = 0;
extern int yylex();
extern int yyparse();
%}

/* Bison definitions */

/*
VARIABLE_SIZE stored in size
IDENTIFIER stored in identifier
INTEGER stored in size
*/

%start START
%token BEGINING BODY PRINT INPUT MOVE ADD TO END SEMICOLON INVALID_ID_X INVALID_ID_NUM STRING TERMINATOR
%token <identifier> IDENTIFIER
%token <size> VARIABLE_SIZE
%token <size> INTEGER
%union
{
	char *identifier;
	int size;
}
%%

/*
List of Grammar Rules (Productions)
Starts at 'START:' rule
$1 $2 $3...$n refer to values associated with symbol
NT:
*/
START           : BEGINING TERMINATOR DECLARATIONS {};

DECLARATIONS    : DECLARATION DECLARATIONS {}
		| body {};

DECLARATION     : VARIABLE_SIZE IDENTIFIER TERMINATOR {	addVariable($1, $2); };

body		: BODY TERMINATOR content {};

content		: stmt content {}
		| end {};

stmt		: print
		| input
		| move
		| add {};

print		: PRINT print_stmt {};

print_stmt	: STRING SEMICOLON print_stmt {}
 		| IDENTIFIER SEMICOLON print_stmt { checkDeclaration($1); }
 		| STRING TERMINATOR {}
 		| IDENTIFIER TERMINATOR { checkDeclaration($1);	};

move		: MOVE INTEGER TO IDENTIFIER TERMINATOR	{ moveIntegerToVariable($2, $4); }
		| MOVE IDENTIFIER TO IDENTIFIER TERMINATOR { moveIdentifierToVariable($2, $4); };

add		: ADD IDENTIFIER TO IDENTIFIER TERMINATOR { moveIdentifierToVariable($2, $4); }
		| ADD INTEGER TO IDENTIFIER TERMINATOR { moveIntegerToVariable($2, $4); };

input		: INPUT input_stmt {};

input_stmt	: IDENTIFIER TERMINATOR	{ checkDeclaration($1);	}
		| IDENTIFIER SEMICOLON input_stmt { checkDeclaration($1); };

end		: END TERMINATOR { exit(EXIT_SUCCESS); };
%%

/*
C code to support language processing
*/

int main()
{
	return yyparse(); // bison generated
}

void yyerror(char *s)
{
	fprintf(stderr, "There is an error: %s\n", s);
}

void moveIntegerToVariable(int newNum, char *variable)
{
	int digits = 0;
    	lastCharDel(variable);
    	int sizeOfVar = getVarSize(variable);

     	while(newNum != 0)
    	{
        	newNum /= 10;
        	++digits;
    	}
	if (sizeOfVar < 0)
	{
		printf("Warning: unable to assign undeclared integer %s. ", variable);
	}
	else if (digits > sizeOfVar)
	{
		printf("Warning: integer size expected %d, "
			"integer size received %d\n", sizeOfVar, digits);
	}
}

int checkVariable(char *variable)
{
	if (strstr(variable, ";") != NULL)
	{
		int i = 0;
		while (i < strlen(variable))
		{
			if (variable[i] == ';' || variable[i] == ' ')
			{
		    		variable[i] = '\0';
		    		break;
			}
			i++;	
		}
    	}
    	for (int i = 0; i < variableCount; i++)
	{
        	if (strcmp(variable, identifiers[i]) == 0)
		{
            		return 1;
        	}
    	}
	return 0;
}

void moveIdentifierToVariable(char *variable1, char *variable2)
{
	int i = 0;
	while (i < strlen(variable1))
	{
		if (variable1[i] == ';' || variable1[i] == ' ')
		{
            		variable1[i] = '\0';
            		break;
        	}
		i++;	
	}
	if (checkVariable(variable1))
	{
		lastCharDel(variable2);
		if (checkVariable(variable2))
		{
			if (getVarSize(variable1) > getVarSize(variable2))
			{
				printf("Warning: %s is declared larger than %s\n", variable1, variable2);
			}
		}
	} 
	else
	{
		printf("Warning: identifier: %s has not been declared previously.\n", variable1);
	}
}

int getVarSize(char *variable)
{
    	for (int i = 0; i < variableCount; i++)
	{
        	if (strcmp(variable, identifiers[i]) == 0)
		{
            		return sizes[i];
        	}
    	}
    	return 0;
}

void addVariable(int size, char *name)
{
	lastCharDel(name);
	if (checkVariable(name))
	{
		printf("Warning: identifier '%s' has been previously declared.\n", name);
	}
	else
	{
		strcpy(identifiers[variableCount], name);
		sizes[variableCount] = size;
		variableCount++;
	}
}

void lastCharDel(char* name)
{
	int i = 0;
    	while(name[i] != '\0')
    	{
        	i++;  
    	}
    	name[i - 1] = '\0';
}

void checkDeclaration(char *variable)
{
	lastCharDel(variable);
    	if (checkVariable(variable) < 1)
	{
        	printf("Warning: identifier %s has not been declared.\n", variable);
    	}
}
