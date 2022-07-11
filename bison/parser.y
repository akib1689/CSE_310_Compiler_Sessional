%{
#include <bits/stdc++.h>
#include "../symbol_table/symbol_table.h"
using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;
extern int error_count;
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
%token <info> ADDOP MULOP RELOP LOGICOP CONST_INT CONST_CHAR CONST_FLOAT ID STRING

%type <info> arguments logic_expression argument_list factor variable expression unary_expression 
%type <info> program unit term simple_expression rel_expression

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start : program {
		fprintf(log_out, "start : program\n");
	}
	;

program : program unit {
		/* string argument_name = $1->get_name() + "\n" + $2->get_name();
		string argument_identifier = "program";

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - program : program unit\n%s\n", line_count, $$->get_name().c_str()); */

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
		$$ = $1;
		fprintf(log_out, "Line %d - expression : logic_expression\n%s\n", line_count, $$->get_name().c_str());
 	}
	| variable ASSIGNOP logic_expression {
		// todo start working from here and go up to the top
		symbol_info left = $1;
		symbol_info right = $3;
		
	} 	
	;

logic_expression : rel_expression {
		$$ = $1;
		fprintf(log_out, "Line %d - logic_expression : rel_expression\n%s\n", line_count, $$->get_name().c_str());
	}
	| rel_expression LOGICOP rel_expression {
		string return_identifier = "CONST_INT";
		string left_identifier = $1->get_identifier();
		string right_identifier = $3->get_identifier();
		string operator_name = $2->get_name();
		if(left_identifier != "CONST_INT" || right_identifier != "CONST_INT"){
			error_count++;
			fprintf(log_out, "Error at line no: %d Relational operator can only be used with two integers\n", line_count);
			fprintf(error_out, "Error at line no: %d Relational operator can only be used with two integers\n", line_count);
			return_identifier = "ERROR";
		}
		string argument_name = $1->get_name() + $2->get_name() + $3->get_name();
		$$ = new symbol_info(argument_name, return_identifier);
		fprintf(log_out, "Line %d - logic_expression : rel_expression LOGICOP rel_expression\n%s\n", line_count, $$->get_name().c_str());
	}
	;
			
rel_expression	: simple_expression {
		$$ = $1;
		fprintf(log_out, "Line %d - rel_expression : simple_expression\n%s\n", line_count, $$->get_name().c_str());
	}
	| simple_expression RELOP simple_expression	{
		string argument_name = $1->get_name() + $2->get_name() + $3->get_name();
		string argument_identifier = "CONST_INT";
		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - rel_expression : simple_expression relop simple_expression\n%s\n", line_count, $$->get_name().c_str());
	}
	;
				
simple_expression : term {
		$$ = $1;
		fprintf(log_out, "Lind %d - simple_expression : term \n%s\n", line_count, $$->get_name().c_str());
	} 
	| simple_expression ADDOP term {
		string argument_name = $1->get_name() + $2->get_name() + $3->get_name();
		string argument_identifier = "int";
		if($1->get_identifier() == "CONST_FLOAT"){
			argument_identifier = "CONST_FLOAT";
		} else if($3->get_identifier() == "CONST_FLOAT"){
			argument_identifier = "CONST_FLOAT";
		}

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Lind %d - simple_expression : simple_expression ADDOP term \n%s\n", line_count, $$->get_name().c_str());
	}
	;
					
term :	unary_expression {
		$$ = $1;
		fprintf(log_out, "Line %d - term : unary_expression\n%s\n", line_count, $$->get_name().c_str());
	}
    |  term MULOP unary_expression {
		string left_identifier = $1->get_identifier();
		string right_identifier = $3->get_identifier();
		string left_name = $1->get_name();
		string right_name = $3->get_name();

		string return_identifier = "ERROR";
		string operator_name = $2->get_name();
		switch(operator_name[0]){
			case '*':
				if(left_identifier == "CONST_FLOAT" || right_identifier == "CONST_FLOAT"){
					return_identifier = "CONST_FLOAT";
				} else {
					return_identifier = "CONST_INT";
				}
				break;
			case '/':
				if(left_identifier == "CONST_FLOAT" || right_identifier == "CONST_FLOAT"){
					return_identifier = "CONST_FLOAT";
				} else {
					return_identifier = "CONST_INT";
				}
				if(right_name == "0"){
					error_count++;
					fprintf(log_out, "Error at line no:%d - Division by zero\n", line_count);
					fprintf(error_out, "Error at line no:%d - Division by zero\n", line_count);
					return_identifier = "ERROR";
				}
				break;
			case '%':
				if(left_identifier != "CONST_INT" || right_identifier != "CONST_INT"){
					error_count++;
					fprintf(log_out, "Error at line no:%d \% operator can only be used with integers\n", line_count);
					fprintf(error_out, "Error at line no:%d \% operator can only be used with integers\n", line_count);
					return_identifier = "ERROR";
				} else {
					if(right_name == "0"){
						error_count++;
						fprintf(log_out, "Error at line no:%d \% operator can not be used with 0\n", line_count);
						fprintf(error_out, "Error at line no:%d \% operator can not be used with 0\n", line_count);
						return_identifier = "ERROR";
					} else {
						return_identifier = "CONST_INT";
					}
				}
				break;
			default:
				return_identifier = "ERROR";
				break;
		}

		string argument_name = left_name + operator_name + right_name;
		$$ = new symbol_info(argument_name, return_identifier);
		fprintf(log_out, "Line %d - term : term MULOP unary_expression\n%s\n", line_count, $$->get_name().c_str());
	}
    ;

unary_expression : ADDOP unary_expression {
		string argument_name = $1->get_name() + $2->get_name();
		string argument_identifier = $2->get_identifier();

		$$ = new symbol_info(argument_name, argument_identifier);
		
		fprintf(log_out, "Line %d - unary_expression : ADDOP unary_expression\n%s\n", line_count, $$->get_name().c_str());
	} 
	| NOT unary_expression {
		string argument_name = "!" + $2->get_name();
		string argument_identifier = $2->get_identifier();

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - unary_expression : NOT unary_expression\n%s\n", line_count, $$->get_name().c_str());
	} 
	| factor {
		$$ = $1;
		fprintf(log_out, "Line %d - unary_expression : factor\n%s\n", line_count, $$->get_name().c_str());
		
	} 
	;
	
factor	: variable {
		$$ = $1;
		fprintf(log_out, "Line %d - factor : variable\n%s\n", line_count, $$->get_name().c_str());
	}
	| ID LPAREN argument_list RPAREN {
		// todo : need to work here envolves error production
	}
	| LPAREN expression RPAREN {
		string argument_name = "(" + $2->get_name() + ")";
		string argument_identifier = $2->get_identifier();

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - factor : lparen expression rparen\n%s\n", line_count, $$->get_name().c_str());
	}
	| CONST_INT {
		$$ = yylval.info;
		fprintf(log_out, "Line %d - factor : CONST_INT\n%s\n", line_count, $$->get_name().c_str());
	} 
	| CONST_FLOAT {
		$$ = yylval.info;
		fprintf(log_out, "Line %d - factor : CONST_FLOAT\n%s\n", line_count, $$->get_name().c_str());
	}
	| variable INCOP {
		string argument_name = $1->get_name() + "++";
		string argument_identifier = $1->get_identifier();

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - factor : variable INCOP\n%s\n", line_count, $1->get_name().c_str());
	}
	| variable DECOP {
		
		string argument_name = $1->get_name() + "--";
		string argument_identifier = $1->get_identifier();

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - factor : variable DECOP\n%s\n", line_count, $$->get_name().c_str());
	};
	
argument_list : arguments {
		$$ = $1;
		fprintf(log_out, "Line %d - argument_list : arguments\n%s\n", line_count, $$->get_name().c_str());
	}
	| {
		$$ = new symbol_info("", "void");
		fprintf(log_out, "Line %d - argument_list : \n%s\n", line_count, $$->get_name().c_str());
	}
	;
	
arguments : arguments COMMA logic_expression {
		//preparing the new symbol_info for the argument
		string argument_name = $1->get_name() + "," + $3->get_name();
		string argument_identifier = $1->get_identifier() + "," + $3->get_identifier();

		//creating the new symbol_info
		$$ = new symbol_info(argument_name, argument_identifier);
		//log file output
		fprintf(log_out, "Line %d - arguments : arguments COMMA logic_expression\n%s\n", line_count, $$->get_name().c_str());
	}
	| logic_expression {
		$$ = $1;
		fprintf(log_out, "Line: %d - arguments : logic_expression\n%s\n", line_count, $$->get_name().c_str());
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

