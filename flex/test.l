%option noyywrap yylineno

%x string_state
%x block_comment_state
%x line_comment_state
%x string_escape_state
%x line_comment_escape_state

%{
#include<bits/stdc++.h>
#include "../SymbolTable/symbol_table.h"
using namespace std;

FILE *logout;
FILE *tokenout;
char *str_to_store = NULL;
char *original_str = NULL;

int word_count=0;
int line_count=1;
int error_count=0;
symbol_table table(7);

/**
* @brief 	function to convert the lower case upper case
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
* @brief 	function to remove first and last from "str_to_store"
*			and return the string
* @return 	char* 		removed string
* ! deprecated function no longer in use
*/
/* char* remove_first_last() {
	char *temp=new char[strlen(str_to_store)-2];
	strcpy(temp,str_to_store+1);
	temp[strlen(temp)-1]='\0';
	return temp;
} */
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



%}

whitespace [ \t\f\r\v]+ 
alpha [a-zA-Z]
alpha_with_underscore [a-zA-Z_]
digit [0-9]
keyword if|else|for|while|do|break|int|char|float|double|void|return|switch|case|default|continue
newline \r?\n
increment "++"|"--"
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

[+-] {
	word_count++;
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<ADDOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <ADDOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
[=] {
	word_count++;
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<ASSIGNOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <ASSIGNOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
[*/%] {
	word_count++;
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<MULOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <MULOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
[!] {
	word_count++;
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<NOT, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <NOT, %s> Lexeme %s found\n",line_count,s,yytext);
}
[(] {
	word_count++;
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<LPAREN, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <LPAREN, %s> Lexeme %s found\n",line_count,s,yytext);
}
[)] {
	word_count++;
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<RPAREN, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <RPAREN, %s> Lexeme %s found\n",line_count,s,yytext);
}
[\{] {
	word_count++;
	/**
	* done		need to add the enter scope
	*/
	table.create_scope();
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<LCURL, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <LCURL, %s> Lexeme %s found\n",line_count,s,yytext);
}
[\}] {
	word_count++;
	/**
	* done need to add the exit scope
	*/
	table.delete_scope();
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<RCURL, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <RCURL, %s> Lexeme %s found\n",line_count,s,yytext);
}
[\[] {
	word_count++;
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<LTHIRD, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <LTHIRD, %s> Lexeme %s found\n",line_count,s,yytext);
}
[\]] {
	word_count++;
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<RTHIRD, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <RTHIRD, %s> Lexeme %s found\n",line_count,s,yytext);
}
[,] {
	word_count++;
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<COMMA, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <COMMA, %s> Lexeme %s found\n",line_count,s,yytext);
}
[;] {
	word_count++;
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<SEMICOLON, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <SEMICOLON, %s> Lexeme %s found\n",line_count,s,yytext);
}
{relational} {
	word_count+=strlen(yytext);
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<RELOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <RELOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
{logic} {
	word_count+=strlen(yytext);
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<LOGICOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <LOGICOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
{increment} {
	word_count+=2;
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<INCOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <INCOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
{empty_char} {
	word_count++;
	error_count++;
	char * s = yytext;
	fprintf(logout,"Error at line no %d, %d: Empty character: %s\n",line_count, word_count,s);
}
{unfinished_char_literal} {
	word_count+=strlen(yytext);
	error_count++;
	char * s = yytext;
	fprintf(logout,"Error at line no %d, %d: Unfinished character: %s\n",line_count, word_count,s);
}
{char_litral} {
	word_count+=strlen(yytext);
	/**
	* done		need to symboltable insert the char literal
	*/
	char* s=special_to_char(yytext);
	fprintf(tokenout,"<CONST_CHAR, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <CONST_CHAR, %s> Lexeme %s found\n",line_count,s,yytext);
	table.insert(yytext, "CONST_CHAR", logout);
}
{multiple_char} {
	word_count+=strlen(yytext);
	error_count++;
	char * s = yytext;
	fprintf(logout,"Error at line no %d, %d: Multiple character: %s\n",line_count, word_count,s);
}
{keyword} {
	word_count+=strlen(yytext);
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<%s>", s);
	fprintf(logout,"Line no %d: TOKEN <%s> Lexeme %s found\n",line_count,s,yytext);
}
{newline} {
	//increase the line_count
	line_count++;
	//reset the word_count
	word_count=0;
}
{int_litral} {
	word_count+=strlen(yytext);
	/**
	* done		need to symboltable insert the int literal
	*/
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<CONST_INT, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <CONST_INT, %s> Lexeme %s found\n",line_count,s,yytext);
	table.insert(s, "CONST_INT", logout);
}
{float_litral} {
	word_count+=strlen(yytext);
	/**
	* done		need to symboltable insert the float literal
	*/
	char* s=strtoupper(yytext);
	fprintf(tokenout,"<CONST_FLOAT, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT, %s> Lexeme %s found\n",line_count,s,yytext);
	table.insert(s, "CONST_FLOAT", logout);
}
{too_many_decimals} {
	word_count+=strlen(yytext);
	error_count++;
	char * s = yytext;
	fprintf(logout,"Error at line no %d, %d: Too many decimals: %s\n",line_count, word_count,s);
}
{ill_formed_float} {
	word_count+=strlen(yytext);
	error_count++;
	char * s = yytext;
	fprintf(logout,"Error at line no %d, %d: ill formed floating number: %s\n",line_count, word_count,s);
}
{identifier} {
	word_count+=strlen(yytext);
	/**
	* done		need to symboltable insert the identifier
	*/
	char* s=yytext;
	fprintf(tokenout,"<ID, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <ID, %s> Lexeme %s found\n",line_count,s,yytext);
	table.insert(s, "ID", logout);
}
{ill_formed_identifier} {
	word_count++;
	error_count++;
	char * s = yytext;
	fprintf(logout,"Error at line no %d, %d: Invalid prefix on ID or invalid suffix on Number: %s\n",line_count, word_count,s);
}
[\"] {
	word_count++;
	BEGIN string_state;
	append_to_str(yytext, yytext);
}
{line_comment_start} {
	word_count+=2;
	append_to_str(yytext, yytext);
	BEGIN line_comment_state;
}
{block_comment_start} {
	word_count+=2;
	append_to_str(yytext, yytext);
	BEGIN block_comment_state;
}
<string_state>{special_char_without_escape} {
	word_count+=strlen(yytext);
	char *s = add_space(yytext);
	char *ptr = special_to_char(s);
	append_to_str(ptr, yytext);
}
<string_state>[\"] {

	/**
	* done		need to symboltable insert the string literal
	*/
	append_to_str(yytext, yytext);
	//char* s=remove_first_last();
	char* s = str_to_store;
	fprintf(tokenout,"<STRING, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <STRING, %s> Lexeme %s found\n",line_count,s,original_str);
	make_str_to_store_null();
	word_count++;
	BEGIN INITIAL;
}
<string_state>[\\] {
	word_count++;
	char *p = new char[1];
	p[0] = '\0';
	append_to_str(p, yytext);
	BEGIN string_escape_state;
}
<string_state><<EOF>> {
	word_count++;
	append_to_str(yytext, yytext);
	error_count++;
	fprintf(logout,"Error at line no %d, %d: Unfinished string\n%s",line_count, word_count,str_to_store);
	make_str_to_store_null();
	BEGIN INITIAL;
}
<string_state>{newline} {
	word_count++;
	append_to_str(yytext, yytext);
	error_count++;
	fprintf(logout,"Error at line no %d, %d: Unfinished string\n%s",line_count, word_count,str_to_store);
	make_str_to_store_null();
	line_count++;
	word_count=0;
	BEGIN INITIAL;
}
<string_state>. {
	append_to_str(yytext, yytext);	
	word_count++;
}
<string_escape_state>{newline} {
	// this is used to only escape one character and go back to the original state
	line_count++;
	word_count=0;
	char *p = new char[1];
	p[0] = '\0';
	append_to_str(p, yytext);
	BEGIN string_state;
}
<string_escape_state>{special_char_without_escape} {
	// this is used to only escape one character and go back to the original state
	word_count+=strlen(yytext);
	BEGIN string_state;
}
<string_escape_state>. {
	//this in normal g++ compiler generates warning named unknown escape sequence
	word_count++;
	append_to_str(yytext, yytext);
	BEGIN string_state;
}
<string_escape_state><<EOF>> {
	word_count++;
	append_to_str(yytext, yytext);
	error_count++;
	fprintf(logout,"Error at line no %d, %d: Unfinished string\n%s",line_count, word_count,str_to_store);
	make_str_to_store_null();
	BEGIN INITIAL;
}
<line_comment_state>{newline} {
	fprintf(logout,"Line no %d: Comment found: %s\n",line_count,str_to_store);
	make_str_to_store_null();
	line_count++;
	word_count=0;
	BEGIN INITIAL;
}
<line_comment_state><<EOF>> {
	fprintf(logout,"Line no %d: Comment found: %s\n",line_count,str_to_store);
	make_str_to_store_null();
	BEGIN INITIAL;
}
<line_comment_state>[\\] {
	word_count++;
	BEGIN line_comment_escape_state;
}
<line_comment_state>. {
	word_count++;
	append_to_str(yytext, yytext);
}
<line_comment_escape_state>{newline} {
	line_count++;
	word_count=0;
	BEGIN line_comment_state;
}
<line_comment_escape_state>. {
	BEGIN line_comment_state;
	word_count++;
}
<block_comment_state>{newline} {
	line_count++;
	word_count=0;
}
<block_comment_state><<EOF>> {
	error_count++;
	fprintf(logout,"Error at line no %d, %d: Unfinished comment\n\t%s\n",line_count, word_count,str_to_store);
	make_str_to_store_null();
	BEGIN INITIAL;
}
<block_comment_state>{block_comment_end} {
	append_to_str(yytext, yytext);
	fprintf(logout,"Line no %d: Comment found: %s\n",line_count,str_to_store);
	make_str_to_store_null();
	word_count++;
	BEGIN INITIAL;
}
<block_comment_state>. {
	word_count++;
	append_to_str(yytext, yytext);
}

<<EOF>> {
	fprintf(logout, "Total Line Count: %d\n",line_count);
	fprintf(logout, "Total Error Count: %d\n",error_count);
	return 0;
}
. {
	//increasing the word_count to keep track of the position of the word
	word_count++;
	error_count++;
	fprintf(logout,"Error at line no %d, %d: Unrecognized character %s\n",line_count, word_count,yytext);
}

%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("1805086_log.txt","w");
	tokenout= fopen("1805086_token.txt","w");

	yyin= fin;
	yylex();
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}
