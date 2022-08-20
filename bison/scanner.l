%option noyywrap yylineno

%x string_state
%x block_comment_state
%x line_comment_state
%x string_escape_state
%x line_comment_escape_state

%{
#include<bits/stdc++.h>
#include"../symbol_table/symbol_info.h"
#include"y.tab.h"
using namespace std;

char *str_to_store = NULL;
char *original_str = NULL;

int line_count=1;
int error_count=0;
void yyerror(char *);
extern FILE* log_out;
extern FILE* error_out;

//------------function declaretion-------------------
char* strtoupper(char*);
void make_str_to_store_null();
void append_to_str(char*,char*);
char* add_space(char*);
char* special_to_char(char*);

%}

whitespace [ \t\f\r\v]+
alpha_with_underscore [a-zA-Z_]
digit [0-9]
newline \r?\n
increment "++"
decrement "--"
logic "&&"|"||"
relational "<"|">"|"<="|">="|"=="|"!="
line_comment_start "//"
block_comment_start "/*"
block_comment_end "*/"
int_litral {digit}+
too_many_decimals ({digit}*\.{digit}*\.{digit}*)+(\.{digit}*)*
ill_formed_float {float_litral}+\.{int_litral}
float_litral {digit}*({digit}\.?|\.{digit}){digit}*([Ee][-+]?{digit}+)?
empty_char \'\'
unfinished_char \'([ -~])?
unfinished_special_char \'\\[\\nfratbv0\']
unfinished_char_literal {unfinished_char}|{unfinished_special_char}
multiple_char \'[ -~]{2,}\'
char \'[ -~]\'
special_char \'\\[\\nfratbv0\']\'
special_char_without_escape \\[\\nfratbv0\']
char_litral {char}|{special_char}
identifier {alpha_with_underscore}({alpha_with_underscore}|{digit})*
ill_formed_identifier {int_litral}{identifier}

%%
{whitespace} {}

"if" {return IF;}
"else" {return ELSE;}
"for" {return FOR;}
"while" {return WHILE;}
"do" {return DO;}
"break" {return BREAK;}
"int" {return INT;}
"char" {return CHAR;}
"float" {return FLOAT;}
"double" {return DOUBLE;}
"void" {return VOID;}
"return" {return RETURN;}
"switch" {return SWITCH;}
"case" {return CASE;}
"default" {return DEFAULT;}
"continue" {return CONTINUE;}
"printf" {return PRINTLN;}
"println" {return PRINTLN;}
[+-] {
    symbol_info* info=new symbol_info(yytext,"ADDOP");
    yylval.info = info;
    return ADDOP;
}
[=] {
    return ASSIGNOP;
}
[*/%] {
    symbol_info* info = new symbol_info(yytext,"MULOP");
    yylval.info = info;
    return MULOP;
}
[!] {
    return NOT;
}
[(] {
    return LPAREN;
}
[)] {
    return RPAREN;
}
[\{] {
    return LCURL;
}
[\}] {
	return RCURL;
}
[\[] {
    return LTHIRD;
}
[\]] {
    return RTHIRD;
}
[,] {
    return COMMA;
}
[;] {
    return SEMICOLON;
}
{relational} {
    symbol_info* info = new symbol_info(yytext,"RELOP");
    yylval.info = info;
    return RELOP;
}
{logic} {
    symbol_info* info = new symbol_info(yytext,"LOGIC");
    yylval.info = info;
    return LOGICOP;
}
{increment} {
    return INCOP;
}
{decrement} {
	return DECOP;
}
{empty_char} {
	
}
{unfinished_char_literal} {

}
{char_litral} {
	symbol_info* info = new symbol_info(yytext,"CONST_CHAR");
	yylval.info = info;
	return CONST_CHAR;
}
{multiple_char} {

}
{newline} {
	//increase the line_count
	line_count++;
}
{int_litral} {
	symbol_info* info = new symbol_info(yytext,"CONST_INT");
	yylval.info = info;
	return CONST_INT;
}
{float_litral} {
	symbol_info* info = new symbol_info(yytext,"CONST_FLOAT");
	yylval.info = info;
	return CONST_FLOAT;
}
{too_many_decimals} {
	
}
{ill_formed_float} {
	
}
{identifier} {
	symbol_info* info = new symbol_info(yytext,"ID");
	yylval.info = info;
	return ID;
}
{ill_formed_identifier} {

}
[\"] {
	BEGIN string_state;
	append_to_str(yytext, yytext);
}
{line_comment_start} {
	append_to_str(yytext, yytext);
	BEGIN line_comment_state;
}
{block_comment_start} {
	append_to_str(yytext, yytext);
	BEGIN block_comment_state;
}
<string_state>{special_char_without_escape} {
	char *s = add_space(yytext);
	char *ptr = special_to_char(s);
	append_to_str(ptr, yytext);
}
<string_state>[\"] {
	append_to_str(yytext, yytext);
	//char* s=remove_first_last();
	char* s = str_to_store;
	symbol_info* info = new symbol_info(s,"STRING");
	yylval.info = info;
	make_str_to_store_null();
	BEGIN INITIAL;
	return STRING;
}
<string_state>[\\] {
	char *p = new char[1];
	p[0] = '\0';
	append_to_str(p, yytext);
	BEGIN string_escape_state;
}
<string_state><<EOF>> {
	append_to_str(yytext, yytext);
	error_count++;
	fprintf(log_out, "Error at line no:%d Unterminated string\n", line_count);
	fprintf(error_out, "Error at line no:%d Unterminated string\n", line_count);
	make_str_to_store_null();
	BEGIN INITIAL;
}
<string_state>{newline} {
	append_to_str(yytext, yytext);
	error_count++;
	fprintf(log_out, "Error at line no:%d Unterminated string\n", line_count);
	fprintf(error_out, "Error at line no:%d Unterminated string\n", line_count);
	make_str_to_store_null();
	line_count++;
	BEGIN INITIAL;
}
<string_state>. {
	append_to_str(yytext, yytext);
}
<string_escape_state>{newline} {
	// this is used to only escape one character and go back to the original state
	line_count++;
	char *p = new char[1];
	p[0] = '\0';
	append_to_str(p, yytext);
	BEGIN string_state;
}
<string_escape_state>{special_char_without_escape} {
	// this is used to only escape one character and go back to the original state
	BEGIN string_state;
}
<string_escape_state>. {
	//this in normal g++ compiler generates warning named unknown escape sequence
	append_to_str(yytext, yytext);
	BEGIN string_state;
}
<string_escape_state><<EOF>> {
	append_to_str(yytext, yytext);
	error_count++;
	fprintf(log_out, "Error at line no:%d Unterminated string\n\n", line_count);
	fprintf(error_out, "Error at line no:%d Unterminated string\n\n", line_count);
	make_str_to_store_null();
	BEGIN INITIAL;
}
<line_comment_state>{newline} {
	make_str_to_store_null();
	line_count++;
	BEGIN INITIAL;
}
<line_comment_state><<EOF>> {
	make_str_to_store_null();
	BEGIN INITIAL;
}
<line_comment_state>[\\] {
	BEGIN line_comment_escape_state;
}
<line_comment_state>. {
	append_to_str(yytext, yytext);
}
<line_comment_escape_state>{newline} {
	line_count++;
	BEGIN line_comment_state;
}
<line_comment_escape_state>. {
	BEGIN line_comment_state;
}
<block_comment_state>{newline} {
	line_count++;
}
<block_comment_state><<EOF>> {
	error_count++;
	fprintf(log_out, "Error at line no:%d Unterminated comment\n\n", line_count);
	fprintf(error_out, "Error at line no:%d Unterminated comment\n\n", line_count);
	make_str_to_store_null();
	BEGIN INITIAL;
}
<block_comment_state>{block_comment_end} {
	append_to_str(yytext, yytext);
	make_str_to_store_null();
	BEGIN INITIAL;
}
<block_comment_state>. {
	append_to_str(yytext, yytext);
}

<<EOF>> {
	return 0;
}
. {
	error_count++;
	fprintf(log_out, "Error at line no:%d Unknown character %s\n\n", line_count, yytext);
	fprintf(error_out, "Error at line no:%d Unknown character %s\n\n", line_count, yytext);
}

%%

/**
* @brief 	function to convert the lower case upper case
* ! not used anymore as the keywords are seperatedly returned
* @param 	char* str 	string to convert
* @return 	char* 		converted string
* */
char *strtoupper(char *str) {
	char *p = new char;
	for(int i=0;str[i]!='\0';i++)
	{
		if(str[i]>='a' && str[i]<='z')
		{
			p[i]=str[i]-32;
		}else{
			p[i]=str[i];
		}
	}
	return p;
}
/**
* @brief 	function to convert 
*			the special formatted char literal to individual character
* @param 	char* str 	char in format '\char'
* @return 	char* 		converted corresponding char code
*/
char *special_to_char(char *str) {
	char *p = new char;
	if	(str[1]!='\\'){
		p[0]=str[1];
		p[1]='\0';
		return p;
	}
	switch(str[2]) {
		case 'n':
			p[0]='\n';
			break;
		case 't':
			p[0]='\t';
			break;
		case '\\':
			p[0]='\\';
			break;
		case '\'':
			p[0]='\'';
			break;
		case 'a':
			p[0]='\a';
			break;
		case 'f':
			p[0]='\f';
			break;
		case 'r':
			p[0]='\r';
			break;
		case 'b':
			p[0]='\b';
			break;
		case 'v':
			p[0]='\v';
			break;
		case '0':
			p[0]='\0';
			break;
	}
	p[1]='\0';
	return p;
}
/**
* @brief 	function to add one space to the front of the string 
*			copy the rest of the string afterwards
* @param 	char* str 	string to add space to
* @return 	char* 		converted string
*/
char *add_space(char *str) {
	char *p = new char;
	p[0]=' ';
	p[1]='\0';
	char *q = new char;
	strcpy(q,str);
	char *r = new char;
	strcpy(r,p);
	char *s = new char;
	strcpy(s,r);
	strcat(s,q);
	return s;
}
/**
* @brief 	function to append found char to the end of str_to_store
* 			if word is found
* @param 	char* str 			string to append after str_to_store
* @param	char* given			string to append after original_str
*/
void append_to_str(char *str,char *given) {
	if(str_to_store==NULL) {
		str_to_store = new char;
		strcpy(str_to_store,str);
	}else{
		strcat(str_to_store,str);
	}
	if(original_str==NULL) {
		original_str = new char;
		strcpy(original_str,given);
	}else{
		strcat(original_str,given);
	}
}
/**
* @brief 	function to make the str_to_store NULL
*/
void make_str_to_store_null() {
	if(str_to_store!=NULL)
	{
		str_to_store[0]='\0';
	}
	if(original_str!=NULL)
	{
		original_str[0]='\0';
	}
}

