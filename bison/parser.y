%{
#include <bits/stdc++.h>
#include "../symbol_table/symbol_table.h"
#include "../util/util.h"
using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;
extern int error_count;
FILE *fp;
FILE *log_out;
FILE *error_out;

string current_function_ret_type = "UNDEFINED";
string current_function_name = "UNDEFINED";

symbol_table table(7);


void yyerror(char *s)
{
	//write your code
	error_count++;
	fprintf(log_out, "Error at line %d: %s\n\n", line_count, s);
	fprintf(error_out, "Error at line no: %d - \"%s\"\n\n", line_count, s);
}


%}

%union {
	symbol_info* info; 
}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN
%token COMMA SEMICOLON LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD NOT ASSIGNOP INCOP DECOP
%token <info> ADDOP MULOP RELOP LOGICOP CONST_INT CONST_CHAR CONST_FLOAT ID STRING

%type <info> arguments logic_expression argument_list factor variable expression unary_expression 
%type <info> program unit term simple_expression rel_expression expression_statement statement statements
%type <info> var_declaration compound_statement declaration_list type_specifier parameter_list func_definition func_declaration

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start : program {
		fprintf(log_out, "start : program\n\n");
	}
	;

program : program unit {
		string argument_name = $1->get_name() + "\n" + $2->get_name();
		string argument_identifier = "program";

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - program : program unit\n\n%s\n\n", line_count, $$->get_name().c_str());

	}
	| unit {
		// cout<<"unit found"<<endl;
		$$ = $1;
		fprintf(log_out, "Line %d - program : unit\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	;
	
unit : var_declaration {
		// cout<<"var_declaration found"<<endl;
		$$ = $1;
		fprintf(log_out, "Line %d - unit : var_declaration\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
    | func_declaration {
		// cout<<"func_declaration found"<<endl;
		$$ = $1;
		fprintf(log_out, "Line %d - unit : func_declaration\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
    | func_definition {
		// cout<<"func_definition found"<<endl;
		$$ = $1;
		fprintf(log_out, "Line %d - unit : func_definition\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
    ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
		// cout<<"type_specifier id lparen parameter_list rparen semicolon found"<<endl;
		string func_ret_type = $1->get_name();
		string func_name = $2->get_name();

		vector<param> func_param_list = get_param_type_list($4->get_name());
		symbol_info* temp_func = table.search(func_name);
		if(temp_func != NULL) {
			// ! function already declared and cannot be redeclared
			error_count++;
			fprintf(log_out, "Error at line no:%d Function %s already declared\n\n", line_count, func_name.c_str());
			fprintf(error_out, "Error at line no:%d Function %s already declared\n\n", line_count, func_name.c_str());
		}
		else {
			// okay function not declared and can be declared
			symbol_info *temp_func = new symbol_info(func_name, func_ret_type, func_param_list);
			// set the definition flag to false
			temp_func->set_defined(false);
			table.insert(temp_func);
		}

		string argument_name = $1->get_name() + " " + $2->get_name() + "(" + $4->get_name() + ");";
		string argument_identifier = "func_declaration";

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| type_specifier ID LPAREN RPAREN SEMICOLON {
		// cout<<"type_specifier id lparen rparen semicolon found"<<endl;
		string func_ret_type = $1->get_name();
		string func_name = $2->get_name();

		vector<param> func_param_list;
		symbol_info* temp_func = table.search(func_name);
		if(temp_func != NULL) {
			// ! function already declared and cannot be redeclared
			error_count++;
			fprintf(log_out, "Error at line no:%d Function %s already declared\n\n", line_count, func_name.c_str());
			fprintf(error_out, "Error at line no:%d Function %s already declared\n\n", line_count, func_name.c_str());
		}
		else {
			// okay function not declared and can be declared
			symbol_info *temp_func = new symbol_info(func_name, func_ret_type, func_param_list);
			// set the definition flag to false
			temp_func->set_defined(false);
			table.insert(temp_func);
		}

		string argument_name = $1->get_name() + " " + $2->get_name() + "();";
		string argument_identifier = "func_declaration";
		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN {
	// this is called after finding the ) in the function declaration and before the {
		string func_ret_type = $1->get_name();
		string func_name = $2->get_name();
		vector<param> func_param_list = get_param_list($4->get_name());
		current_function_ret_type = func_ret_type;
		current_function_name = func_name;

		symbol_info* temp_func = table.search(func_name);
		if(temp_func != NULL){
			// function already declared
			if(temp_func->is_function()){
				// function is declared as a function
				if(temp_func->is_defined()){
					// ! function alredy defined cannot be defined again
					error_count++;
					fprintf(log_out, "Error at line no:%d Function \"%s\" already defined\n\n", line_count, func_name.c_str());
					fprintf(error_out, "Error at line no:%d Function \"%s\" already defined\n\n", line_count, func_name.c_str());
				} else {
					// okay function is declared as a function but not defined 
					bool definition_matched = true;
					int declared_param_count = temp_func->get_param_count();
					int definition_param_count = func_param_list.size();
					// check if the function definition has the same number of parameters
					if(declared_param_count != definition_param_count){
						// ! function definition has different number of parameters
						error_count++;
						fprintf(log_out, "Error at line no:%d Function \"%s\" has different number of parameters\n\n", line_count, func_name.c_str());
						fprintf(error_out, "Error at line no:%d Function \"%s\" has different number of parameters\n\n", line_count, func_name.c_str());
						definition_matched = false;
					} else {
						vector<param> declared_param_list = temp_func->get_params();
						for(int i = 0; i < declared_param_count; i++){
							if(declared_param_list[i].get_type() != func_param_list[i].get_type()){
								// ! function definition has different parameter types
								error_count++;
								fprintf(log_out, "Error at line no:%d Function \"%s\" has different parameter types\n\n", line_count, func_name.c_str());
								fprintf(error_out, "Error at line no:%d Function \"%s\" has different parameter types\n\n", line_count, func_name.c_str());
								definition_matched = false;
							}
							
						}
					}
					if(func_ret_type != temp_func->get_identifier()){
						// ! function definition has different return type
						error_count++;
						fprintf(log_out, "Error at line no:%d Function \"%s\" has different return type\n\n", line_count, func_name.c_str());
						fprintf(error_out, "Error at line no:%d Function \"%s\" has different return type\n\n", line_count, func_name.c_str());
						definition_matched = false;
					}
					// if the function definition matches the declaration then 
					// remove the function from the symbol table and add it again with the definition
					if(definition_matched){
						table.remove(func_name);
						temp_func = new symbol_info(func_name, func_ret_type, func_param_list);
						table.insert(temp_func);
					}
					// set the fundtion as defined
					temp_func->set_defined(true);

					// enter to the function scope
					table.create_scope();
					// add the parameters to the symbol table
					for(int i = 0; i < func_param_list.size(); i++){
						string param_name = func_param_list[i].get_name();
						string param_type = func_param_list[i].get_type();
						bool result = table.insert(new symbol_info(param_name, param_type));

						if(!result){
							// ! function parameter already declared
							error_count++;
							fprintf(log_out, "Error at line no:%d Function parameter \"%s\" already declared\n\n", line_count, param_name.c_str());
							fprintf(error_out, "Error at line no:%d Function parameter \"%s\" already declared\n\n", line_count, param_name.c_str());
						}
					}
				}
			} else {
				// ! function is not declared as a function but is already declared
				// we will enter scope no matter what and treat this as a function
				table.create_scope();
				error_count++;
				fprintf(log_out, "Error at line no:%d Function \"%s\" already declared but not as Function\n\n", line_count, func_name.c_str());
				fprintf(error_out, "Error at line no:%d Function \"%s\" already declared but not as Function\n\n", line_count, func_name.c_str());
			}
		} else {
			// function is not declared okay
			symbol_info* temp_func = new symbol_info(func_name, func_ret_type, func_param_list);
			temp_func->set_defined(true);
			table.insert(temp_func);
			// enter to the function scope
			table.create_scope();
			// add the parameters to the symbol table
			for(int i = 0; i < func_param_list.size(); i++){
				string param_name = func_param_list[i].get_name();
				string param_type = func_param_list[i].get_type();
				bool result = table.insert(new symbol_info(param_name, param_type));

				if(!result){
					// ! function parameter already declared
					error_count++;
					fprintf(log_out, "Error at line no:%d Function parameter \"%s\" already declared\n\n", line_count, param_name.c_str());
					fprintf(error_out, "Error at line no:%d Function parameter \"%s\" already declared\n\n", line_count, param_name.c_str());
				}
			}
		}

	} compound_statement {
		string argument_name = $1->get_name() + " " + $2->get_name() + "(" + $4->get_name() + ")" + $7->get_name();
		string argument_identifier = "function_definition";

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line no:%d - function definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n%s\n\n", line_count, argument_name.c_str());
	}
	| type_specifier ID LPAREN RPAREN {
		string func_ret_type = $1->get_name();
		string func_name = $2->get_name();
		vector<param> func_param_list;

		symbol_info* temp_func = table.search(func_name);
		if(temp_func != NULL){
			// function is already declared
			if(temp_func->is_function()){
				// function is already declared as a function
				if(temp_func->is_defined()){
					// ! function is already defined and cannot be redefined
					error_count++;
					fprintf(log_out, "Error at line no:%d Function \"%s\" already defined\n\n", line_count, func_name.c_str());
					fprintf(error_out, "Error at line no:%d Function \"%s\" already defined\n\n", line_count, func_name.c_str());
				} else {
					// function is declared as a function but not defined
					bool definition_matched = true;
					int declared_param_count = temp_func->get_param_count();
					int definition_param_count = func_param_list.size();
					// check if the function definition has the same number of parameters
					if(declared_param_count != definition_param_count){
						// ! function definition has different number of parameters
						error_count++;
						fprintf(log_out, "Error at line no:%d Function \"%s\" has different number of parameters\n\n", line_count, func_name.c_str());
						fprintf(error_out, "Error at line no:%d Function \"%s\" has different number of parameters\n\n", line_count, func_name.c_str());
						definition_matched = false;
					}
					if(func_ret_type != temp_func->get_identifier()){
						// ! function definition has different return type
						error_count++;
						fprintf(log_out, "Error at line no:%d Function \"%s\" has different return type\n\n", line_count, func_name.c_str());
						fprintf(error_out, "Error at line no:%d Function \"%s\" has different return type\n\n", line_count, func_name.c_str());
						definition_matched = false;
					}
					// if the function definition matches the declaration then 
					// remove the function from the symbol table and add it again with the definition
					if(definition_matched){
						table.remove(func_name);
						temp_func = new symbol_info(func_name, func_ret_type, func_param_list);
						table.insert(temp_func);
					}
					// set the fundtion as defined
					temp_func->set_defined(true);

					// enter to the function scope
					table.create_scope();
				}
			}
		} else {
			// function is not declared
			symbol_info* temp_func = new symbol_info(func_name, func_ret_type, func_param_list);
			temp_func->set_defined(true);
			table.insert(temp_func);
			// enter to the function scope
			table.create_scope();
		}
		
	} compound_statement {
		// cout<<"type_specifier id lparen rparen compound_statement found"<<endl;
		string argument_name = $1->get_name() + " " + $2->get_name() + "()" + $6->get_name();
		string argument_identifier = "function_definition";

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line no:%d - function definition : type_specifier ID LPAREN RPAREN compound_statement\n\n%s\n\n", line_count, argument_name.c_str());
	}
 	;				


parameter_list  : parameter_list COMMA type_specifier ID {
		// cout<<"parameter_list comma type_specifier id found"<<endl;
		string argument_name = $1->get_name() + "," + $3->get_name() + " " + $4->get_name();
		string argument_identifier = "parameter_list";

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - parameter_list : parameter_list COMMA type_specifier ID\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| parameter_list COMMA type_specifier {
		// cout<<"parameter_list comma type_specifier found"<<endl;
		string argument_name = $1->get_name() + "," + $3->get_name();
		string argument_identifier = "parameter_list";

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - parameter_list : parameter_list COMMA type_specifier ID\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
 	| type_specifier ID {
		// cout<<"type_specifier id found"<<endl;
		string argument_name = $1->get_name() + " " + $2->get_name();
		string argument_identifier = "parameter_list";

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - parameter_list : type_specifier ID\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| type_specifier {
		// cout<<"type_specifier found"<<endl;
		$$ = $1;
		fprintf(log_out, "Line %d - parameter_list : type_specifier\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
 	;

 		
compound_statement : LCURL statements RCURL {
		// cout<<"lcurl statements rcurl found"<<endl;
		string argument_name = "{\n" + $2->get_name() + "\n}";
		string argument_identifier = "compound_statement";

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - compound_statement : LCURL statements RCURL\n\n%s\n\n", line_count, $$->get_name().c_str());

		table.print_all(log_out);
		table.delete_scope();
	}
 	| LCURL RCURL {
		// cout<<"lcurl rcurl found"<<endl;
		string argument_name = "{\n}";
		string argument_identifier = "compound_statement";

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - compound_statement : LCURL RCURL\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
 	;
 		    
var_declaration : type_specifier declaration_list SEMICOLON {
		// cout<<"type_specifier declaration_list semicolon found"<<endl;
		string variable_type = $1->get_identifier();

		if(variable_type == "void"){
			error_count++;
			fprintf(error_out, "Error at line no:%d void is not a valid type for variable declaration\n\n", line_count);
		} else {
			vector<string> declaration_list_names = split($2->get_name(), ',');
			for(int i = 0; i < declaration_list_names.size(); i++){
				string argument_name = declaration_list_names[i];
				symbol_info* temp;
				if (is_array_declaration(argument_name)){
					int array_size = get_array_size(argument_name);
					string array_name = get_array_name(argument_name);
					temp = new symbol_info(array_name, variable_type, array_size);
				} else {
					temp = new symbol_info(argument_name, variable_type);
				}
				if(!table.insert(temp)){
					// ! multiple declaration error
					// ! the symbol is already present in the symbol table
					error_count++;
					fprintf(log_out, "Error at line no:%d Multiple declaration of %s\n\n", line_count, temp->get_name().c_str());
					fprintf(error_out, "Error at line no:%d Multiple declaration of %s\n\n", line_count, temp->get_name().c_str());
				}
			}
		}
		string argument_name = $1->get_name() + " " + $2->get_name() + ";";
		string argument_identifier = "var_declaration";

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - var_declaration : type_specifier declaration_list semicolon\n\n%s\n\n", line_count, $$->get_name().c_str());		
	}
 	;
 		 
type_specifier	: INT {
		// cout<<"int detected"<<endl;
		$$ = new symbol_info("int", "CONST_INT");
		fprintf(log_out, "Line %d - type_specifier : INT\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
 	| FLOAT {
		// cout<<"float detected"<<endl;
		$$ = new symbol_info("float", "CONST_FLOAT");
		fprintf(log_out, "Line %d - type_specifier : FLOAT\n\n%s\n\n", line_count, $$->get_name().c_str());
		
	}
 	| VOID {
		// cout<<"void detected"<<endl;
		$$ = new symbol_info("void", "VOID");
		fprintf(log_out, "Line %d - type_specifier : VOID\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
 	;
 		
declaration_list : declaration_list COMMA ID {
		// cout<<"declaration list detected"<<endl;
		string argument_name = $1->get_name() + "," + $3->get_name();
		string argument_identifier = "declaration_list";

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - declaration_list : declaration_list COMMA ID\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
 	| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD {
		// cout<<"array detected"<<endl;
		string argument_name = $1->get_name() + "," + $3->get_name() + "[" + $5->get_name() + "]";
		string argument_identifier = "declaration_list";

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
 	| ID {
		// cout<<"id detected"<<endl;
		$$ = $1;
		fprintf(log_out, "Line %d - declaration_list : ID\n\n%s\n\n", line_count, $$->get_name().c_str());

	}
 	| ID LTHIRD CONST_INT RTHIRD {
		// cout<<"array detected"<<endl;
		string argument_name = $1->get_name() + "[" + $3->get_name() + "]";
		string argument_identifier = "declaration_list";

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
 	;
 		  
statements : statement {
		// cout<<"statement found"<<endl;
		$$ = $1;

		fprintf(log_out, "Line %d - statements : statement\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
 	| statements statement {
		// cout<<"statements statement found"<<endl;
		string argument_name = $1->get_name() + "\n" + $2->get_name();
		string argument_identifier = "statements";

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - statements : statements statement\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	;
	   
statement : var_declaration {
		$$ = $1;
		fprintf(log_out, "Line %d - statement : var_declaration\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| expression_statement {
		$$ = $1;
		fprintf(log_out, "Line %d - statement : expression_statement\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| { table.create_scope(); } compound_statement {
		$$ = $2;
		fprintf(log_out, "Line %d - statement : compound_statement\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| FOR LPAREN expression_statement expression_statement expression RPAREN statement {
		// cout<<"for loop detected"<<endl;
		string argument_name = "for (" + $3->get_name() + $4->get_name() + $5->get_name() + ")" + $7->get_name();
		string argument_identifier = "statement";

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE {
		// cout<<"if statement detected"<<endl;
		string argument_name = "if (" + $3->get_name() + ")" + $5->get_name();
		string argument_identifier = "statement";

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - statement : IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| IF LPAREN expression RPAREN statement ELSE statement {
		// cout<<"if else statement detected"<<endl;
		string argument_name = "if (" + $3->get_name() + ")" + $5->get_name() + "else" + $7->get_name();
		string argument_identifier = "statement";

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - statement : IF LPAREN expression RPAREN statement ELSE statement\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| WHILE LPAREN expression RPAREN statement {
		// cout<<"while loop detected"<<endl;

		string argument_name = "while (" + $3->get_name() + ")" + $5->get_name();
		string argument_identifier = "statement";

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - statement : WHILE LPAREN expression RPAREN statement\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| PRINTLN LPAREN ID RPAREN SEMICOLON {
		// cout<<"println detected"<<endl;
		string argument_name = "printf(" + $3->get_name() + ")";
		string argument_identifier = "statement";

		symbol_info* temp = table.search($3->get_name());

		if(temp == NULL){
			// ! the variable is not declared
			error_count++;
			fprintf(log_out, "Error at line no: %d Variable - %s not declared\n\n", line_count, $3->get_name().c_str());
			fprintf(error_out, "Error at line no: %d Variable - %s not declared\n\n", line_count, $3->get_name().c_str());
		} else {
			if (!temp->is_variable()){
				// ! the variable is not a variable
				error_count++;
				fprintf(log_out, "Error at line no: %d Variable - %s is not a variable\n\n", line_count, $3->get_name().c_str());
				fprintf(error_out, "Error at line no: %d Variable - %s is not a variable\n\n", line_count, $3->get_name().c_str());
			}
		}

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n%s\n\n", line_count, $$->get_name().c_str());

	}
	| RETURN expression SEMICOLON {
		// cout<<"return detected"<<endl;
		string argument_name = "return " + $2->get_name() + ";";
		string argument_identifier = "statement";

		if(current_function_ret_type == "void"){
			error_count++;
			fprintf(log_out, "Error at line no: %d Function - %s does not have a return type\n", line_count, current_function_name.c_str());
			fprintf(error_out, "Error at line no: %d Function - %s does not have a return type\n", line_count, current_function_name.c_str());
			current_function_ret_type = "ERROR";
		}

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - statement : RETURN expression SEMICOLON\n\n%s\n\n", line_count, $$->get_name().c_str());

	}
	;
	  
expression_statement : SEMICOLON {
		$$ = new symbol_info(";", "SEMICOLON");
	}		
	| expression SEMICOLON {
		string argument_name = $1->get_name() + ";";
		string argument_identifier = "EXPRESSION_STATEMENT";

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - expression_statement : expression SEMICOLON\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	;

variable : ID {
		symbol_info* temp = table.search($1->get_name());

		if(temp == NULL){
			// ! current symbol is not in the table
			error_count++;
			fprintf(log_out, "Error at line no: %d Variable - %s not declared\n\n", line_count, $1->get_name().c_str());
			fprintf(error_out, "Error at line no: %d Variable - %s not declared\n\n", line_count, $1->get_name().c_str());

			$$ = new symbol_info($1->get_name(), "ERROR");
		} else {
			if(temp->is_array()) {
				// ! current symbol is found in the table but it is an array so error
				$$ = new symbol_info(temp->get_name(), "ERROR", temp->get_size());
			} else {
				// current symbol is found in the table and it is not an array so all okay
				$$ = new symbol_info(temp->get_name(), temp->get_identifier());
			}
		}
		fprintf(log_out, "Line %d - variable : ID\n\n%s\n\n",line_count, $$->get_name().c_str());
	}
	| ID LTHIRD expression RTHIRD {
		//cout<<$1->get_name()<<endl;
		symbol_info* temp = table.search($1->get_name());
		if(temp == NULL){
			// ! current symbol is not in the table
			error_count++;
			fprintf(log_out, "Error at line no: %d Variable - %s not declared\n\n", line_count, $1->get_name().c_str());
			fprintf(error_out, "Error at line no: %d Variable - %s not declared\n\n", line_count, $1->get_name().c_str());
			string argument_name = $1->get_name() + "[" + $3->get_name() + "]";
			$$ = new symbol_info(argument_name, "ERROR");
		} else {
			if(temp->is_array()) {
				// current symbol is found in the table and it is an array so all okay
				if ($3->get_identifier() != "CONST_INT"){
					// ! index is not an integer error
					error_count++;
					fprintf(log_out, "Error at line no: %d Array index is not an integer\n\n", line_count);
					fprintf(error_out, "Error at line no: %d Array index is not an integer\n\n", line_count);
				}
				string argument_name = $1->get_name() + "[" + $3->get_name() + "]";
				$$ = new symbol_info(argument_name, temp->get_identifier());
			} else {
				// ! current symbol is found in the table and it is not an array so error
				string argument_name = $1->get_name() + "[" + $3->get_name() + "]";
				$$ = new symbol_info(argument_name, "ERROR");
			}
		}
		fprintf(log_out, "Line %d - variable : ID LTHIRD expression RTHIRD\n\n%s\n\n",line_count, $$->get_name().c_str());
	}
	;
	 
 expression : logic_expression {
		$$ = $1;
		fprintf(log_out, "Line %d - expression : logic_expression\n\n%s\n\n", line_count, $$->get_name().c_str());
 	}
	| variable ASSIGNOP logic_expression {
		symbol_info* left = $1;
		symbol_info* right = $3;

		if (left->get_identifier() != right->get_identifier()) {
			// error
			if (left->get_identifier() == "ERROR" || right->get_identifier() == "ERROR") {
				if (left->is_array() || right->is_array()) {
					// error
					error_count++;
					if(left->is_array()){
						fprintf(log_out, "Error at line no: %d Type mismatch, %s is an array\n\n", line_count, left->get_name().c_str());
						fprintf(error_out, "Error at line no: %d Type mismatch, %s is an array\n\n", line_count, left->get_name().c_str());
					}else{
						fprintf(log_out, "Error at line no: %d Type mismatch, %s is an array\n\n", line_count, right->get_name().c_str());
						fprintf(error_out, "Error at line no: %d Type mismatch, %s is an array\n\n", line_count, right->get_name().c_str());
					}
				} 
			} else if (left->get_identifier() == "CONST_FLOAT" && right->get_identifier() == "CONST_INT") {
				// do nothing
			} else {
				// error
				error_count++;
				fprintf(log_out, "Error at line no: %d Type mismatch, %s is not of type %s\n\n", line_count, left->get_name().c_str(), right->get_identifier().c_str());
				fprintf(error_out, "Error at line no: %d Type mismatch, %s is not of type %s\n\n", line_count, left->get_name().c_str(), right->get_identifier().c_str());
			}
		}

		string argument_name = left->get_name() + " = " + right->get_name();
		string argument_identifier = "EXPRESSION";

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - expression : variable ASSIGNOP logic_expression\n\n%s\n\n", line_count, $$->get_name().c_str());

	} 	
	;

logic_expression : rel_expression {
		$$ = $1;
		fprintf(log_out, "Line %d - logic_expression : rel_expression\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| rel_expression LOGICOP rel_expression {
		string return_identifier = "CONST_INT";
		string left_identifier = $1->get_identifier();
		string right_identifier = $3->get_identifier();
		string operator_name = $2->get_name();
		if(left_identifier != "CONST_INT" || right_identifier != "CONST_INT"){
			error_count++;
			fprintf(log_out, "Error at line no: %d Relational operator can only be used with two integers\n\n", line_count);
			fprintf(error_out, "Error at line no: %d Relational operator can only be used with two integers\n\n", line_count);
			return_identifier = "ERROR";
		}
		string argument_name = $1->get_name() + $2->get_name() + $3->get_name();
		$$ = new symbol_info(argument_name, return_identifier);
		fprintf(log_out, "Line %d - logic_expression : rel_expression LOGICOP rel_expression\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	;
			
rel_expression	: simple_expression {
		$$ = $1;
		fprintf(log_out, "Line %d - rel_expression : simple_expression\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| simple_expression RELOP simple_expression	{
		string argument_name = $1->get_name() + $2->get_name() + $3->get_name();
		string argument_identifier = "CONST_INT";
		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - rel_expression : simple_expression relop simple_expression\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	;
				
simple_expression : term {
		$$ = $1;
		fprintf(log_out, "Lind %d - simple_expression : term \n\n%s\n\n", line_count, $$->get_name().c_str());
	} 
	| simple_expression ADDOP term {
		string argument_name = $1->get_name() + $2->get_name() + $3->get_name();
		string argument_identifier = "CONST_INT";
		if($1->get_identifier() == "CONST_FLOAT"){
			argument_identifier = "CONST_FLOAT";
		} else if($3->get_identifier() == "CONST_FLOAT"){
			argument_identifier = "CONST_FLOAT";
		}

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Lind %d - simple_expression : simple_expression ADDOP term \n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	;
					
term :	unary_expression {
		$$ = $1;
		fprintf(log_out, "Line %d - term : unary_expression\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
    |  term MULOP unary_expression {
		string left_identifier = $1->get_identifier();
		string right_identifier = $3->get_identifier();
		string left_name = $1->get_name().c_str();
		string right_name = $3->get_name().c_str();

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
					fprintf(log_out, "Error at line no:%d - Division by zero\n\n", line_count);
					fprintf(error_out, "Error at line no:%d - Division by zero\n\n", line_count);
					return_identifier = "ERROR";
				}
				break;
			case '%':
				if(left_identifier != "CONST_INT" || right_identifier != "CONST_INT"){
					error_count++;
					fprintf(log_out, "Error at line no:%d %c operator can only be used with integers\n\n", line_count, '%');
					fprintf(error_out, "Error at line no:%d %c operator can only be used with integers\n\n", line_count, '%');
					return_identifier = "ERROR";
				} else {
					if(right_name == "0"){
						error_count++;
						fprintf(log_out, "Error at line no:%d \% operator can not be used with 0\n\n", line_count);
						fprintf(error_out, "Error at line no:%d \% operator can not be used with 0\n\n", line_count);
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
		fprintf(log_out, "Line %d - term : term MULOP unary_expression\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
    ;

unary_expression : ADDOP unary_expression {
		string argument_name = $1->get_name() + $2->get_name();
		string argument_identifier = $2->get_identifier();

		$$ = new symbol_info(argument_name, argument_identifier);
		
		fprintf(log_out, "Line %d - unary_expression : ADDOP unary_expression\n\n%s\n\n", line_count, $$->get_name().c_str());
	} 
	| NOT unary_expression {
		string argument_name = "!" + $2->get_name();
		string argument_identifier = $2->get_identifier();

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - unary_expression : NOT unary_expression\n\n%s\n\n", line_count, $$->get_name().c_str());
	} 
	| factor {
		$$ = $1;
		fprintf(log_out, "Line %d - unary_expression : factor\n\n%s\n\n", line_count, $$->get_name().c_str());
		
	} 
	;
	
factor	: variable {
		$$ = $1;
		fprintf(log_out, "Line %d - factor : variable\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| ID LPAREN argument_list RPAREN {
		// todo : need to work here envolves error production
	}
	| LPAREN expression RPAREN {
		string argument_name = "(" + $2->get_name() + ")";
		string argument_identifier = $2->get_identifier();

		$$ = new symbol_info(argument_name, argument_identifier);
		fprintf(log_out, "Line %d - factor : lparen expression rparen\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| CONST_INT {
		$$ = yylval.info;
		fprintf(log_out, "Line %d - factor : CONST_INT\n\n%s\n\n", line_count, $$->get_name().c_str());
	} 
	| CONST_FLOAT {
		$$ = yylval.info;
		fprintf(log_out, "Line %d - factor : CONST_FLOAT\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| variable INCOP {
		string argument_name = $1->get_name() + "++";
		string argument_identifier = $1->get_identifier();

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - factor : variable INCOP\n\n%s\n\n", line_count, $1->get_name().c_str());
	}
	| variable DECOP {
		
		string argument_name = $1->get_name() + "--";
		string argument_identifier = $1->get_identifier();

		$$ = new symbol_info(argument_name, argument_identifier);

		fprintf(log_out, "Line %d - factor : variable DECOP\n\n%s\n\n", line_count, $$->get_name().c_str());
	};
	
argument_list : arguments {
		$$ = $1;
		fprintf(log_out, "Line %d - argument_list : arguments\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| {
		$$ = new symbol_info("", "void");
		fprintf(log_out, "Line %d - argument_list : \n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	;
	
arguments : arguments COMMA logic_expression {
		//preparing the new symbol_info for the argument
		string argument_name = $1->get_name() + "," + $3->get_name();
		string argument_identifier = $1->get_identifier() + "," + $3->get_identifier();

		//creating the new symbol_info
		$$ = new symbol_info(argument_name, argument_identifier);
		//log file output
		fprintf(log_out, "Line %d - arguments : arguments COMMA logic_expression\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	| logic_expression {
		$$ = $1;
		fprintf(log_out, "Line: %d - arguments : logic_expression\n\n%s\n\n", line_count, $$->get_name().c_str());
	}
	;
%%
int main(int argc,char *argv[]) {

	if((fp=fopen(argv[1],"r"))==NULL) {
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
	table.print_all(log_out);
	
	fprintf(log_out, "Total Lines: %d\n", line_count);
	fprintf(log_out, "Total Errors: %d\n", error_count);
	fclose(log_out);
	fclose(error_out);

	return 0;
}

