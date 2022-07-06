%{
#include <bits/stdc++.h>
#include "../symbol_table/symbol_table.h"
using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;
FILE *fp;
FILE *log_out;
FILE *error_out;

symbol_table* table;


void yyerror(char *s)
{
	//write your code
}


%}

%union {
	symbol_info* info; 
}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN
%token COMMA SEMICOLON LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD NOT ASSIGNOP INCOP DECOP
%token <symbol_info> ADDOP MULOP RELOP LOGICOP CONST_INT CONST_CHAR CONST_FLOAT ID STRING

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start : program {
		//write your code in this block in all the similar blocks below
		cout<<"program parsed"<<endl;
	}
	;

program : program unit {
		cout<<"program unit found"<<endl;

	}
	| unit {
		cout<<"unit found"<<endl;
	}
	;
	
unit : var_declaration {
		cout<<"var_declaration found"<<endl;
	}
    | func_declaration {
		cout<<"func_declaration found"<<endl;
	}
    | func_definition {
		cout<<"func_definition found"<<endl;
	}
    ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
		cout<<"type_specifier id lparen parameter_list rparen semicolon found"<<endl;
	}
	| type_specifier ID LPAREN RPAREN SEMICOLON {
		cout<<"type_specifier id lparen rparen semicolon found"<<endl;
	}
	;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement {
		cout<<"type_specifier id lparen parameter_list rparen compound_statement found"<<endl;
	}
	| type_specifier ID LPAREN RPAREN compound_statement {
		cout<<"type_specifier id lparen rparen compound_statement found"<<endl;
	}
 	;				


parameter_list  : parameter_list COMMA type_specifier ID {
		cout<<"parameter_list comma type_specifier id found"<<endl;
	}
	| parameter_list COMMA type_specifier {
		cout<<"parameter_list comma type_specifier found"<<endl;
	}
 	| type_specifier ID {
		cout<<"type_specifier id found"<<endl;
	}
	| type_specifier {
		cout<<"type_specifier found"<<endl;
	}
 	;

 		
compound_statement : LCURL statements RCURL {
		cout<<"lcurl statements rcurl found"<<endl;
	}
 	| LCURL RCURL {
		cout<<"lcurl rcurl found"<<endl;
	}
 	;
 		    
var_declaration : type_specifier declaration_list SEMICOLON {
		cout<<"type_specifier declaration_list semicolon found"<<endl;
	}
 	;
 		 
type_specifier	: INT {
		cout<<"int detected"<<endl;
	}
 	| FLOAT {
		cout<<"float detected"<<endl;
	}
 	| VOID {
		cout<<"void detected"<<endl;
	}
 	;
 		
declaration_list : declaration_list COMMA ID {
		cout<<"declaration list detected"<<endl;
	}
 	| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD {
		cout<<"array detected"<<endl;
	}
 	| ID {
		cout<<"id detected"<<endl;

	}
 	| ID LTHIRD CONST_INT RTHIRD {
		cout<<"array detected"<<endl;
	}
 	;
 		  
statements : statement {
		cout<<"statement found"<<endl;
	}
 	| statements statement {
		cout<<"statements statement found"<<endl;
	}
	;
	   
statement : var_declaration {
		cout<<"var_declaration found"<<endl;
	}
	| expression_statement {
		cout<<"expression_statement found"<<endl;
	}
	| compound_statement {
		cout<<"compound_statement found"<<endl;
	}
	| FOR LPAREN expression_statement expression_statement expression RPAREN statement {
		cout<<"for loop detected"<<endl;
	}
	| IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE {
		cout<<"if statement detected"<<endl;
	}
	| IF LPAREN expression RPAREN statement ELSE statement {
		cout<<"if else statement detected"<<endl;
	}
	| WHILE LPAREN expression RPAREN statement {
		cout<<"while loop detected"<<endl;
	}
	| PRINTLN LPAREN ID RPAREN SEMICOLON {
		cout<<"println detected"<<endl;
	}
	| RETURN expression SEMICOLON {
		cout<<"return detected"<<endl;
	}
	;
	  
expression_statement : SEMICOLON {
		cout<<"semicolon found"<<endl;
	}		
	| expression SEMICOLON {
		cout<<"expression semicolon found"<<endl;
	}
	;

variable : ID {
		cout<<"variable id detected"<<endl;
	}
	| ID LTHIRD expression RTHIRD {
		cout<<"variable array detected"<<endl;
	}
	;
	 
 expression : logic_expression {
		cout<<"logic_expression found"<<endl;
 	}
	| variable ASSIGNOP logic_expression {
		cout<<"variable assignop logic_expression found"<<endl;
	} 	
	;

logic_expression : rel_expression {
		cout<<"rel_expression found"<<endl;
	}
	| rel_expression LOGICOP rel_expression {
		cout<<"logicop rel_expression found"<<endl;
	}
	;
			
rel_expression	: simple_expression {
		cout<<"simple_expression found"<<endl;
	}
	| simple_expression RELOP simple_expression	{
		cout<<"relop simple_expression found"<<endl;
	}
	;
				
simple_expression : term {
		cout<<"term found"<<endl;
	} 
	| simple_expression ADDOP term {
		cout<<"addop term found"<<endl;
	}
	;
					
term :	unary_expression {
		cout<<"unary_expression found"<<endl;
	}
    |  term MULOP unary_expression {
		cout<<"mulop unary_expression found"<<endl;
	}
    ;

unary_expression : ADDOP unary_expression {
		cout<<"addop unary_expression found"<<endl;
	} 
	| NOT unary_expression {
		cout<<"not unary_expression found"<<endl;
	} 
	| factor {
		cout<<"factor found"<<endl;
	} 
	;
	
factor	: variable {
		cout<<"variable found"<<endl;
	}
	| ID LPAREN argument_list RPAREN {
		cout<<"function call detected"<<endl;
	}
	| LPAREN expression RPAREN {
		cout<<"parenthesis expression found"<<endl;
	}
	| CONST_INT {
		cout<<"constant int found"<<endl;
	} 
	| CONST_FLOAT {
		cout<<"constant float found"<<endl;
	}
	| variable INCOP {
		cout<<"variable incop found"<<endl;
	}
	| variable DECOP {
		cout<<"variable decop found"<<endl;
	};
	
argument_list : arguments {
		cout<<"arguments found"<<endl;
	}
	| {
		cout<<"empty argument list found"<<endl;
	}
	;
	
arguments : arguments COMMA logic_expression {
		cout<<"arguments comma logic_expression found"<<endl;
	}
	| logic_expression {
		$$ = $1;
		fprintf(log_out, "Line: %d - arguments : logic_expression\n %s", line_count, $$->get_name());
	}
	;
%%
int main(int argc,char *argv[])
{

	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	log_out= fopen(argv[2],"w");
	fclose(log_out);
	error_out= fopen(argv[3],"w");
	fclose(error_out);
	
	log_out= fopen(argv[2],"a");
	error_out= fopen(argv[3],"a");
	

	yyin=fp;
	yyparse();
	

	fclose(log_out);
	fclose(error_out);

	return 0;
}

