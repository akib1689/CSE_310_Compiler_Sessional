%option noyywrap yylineno

%x string_state
%x comment_state
%x string_escape_state
%x comment_escape_state

%{
#include<bits/stdc++.h>
using namespace std;

FILE *logout;
FILE *tokenout;
char *str_to_store = NULL;

int word_count=0;
int line_count=1;
int error_count=0;

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
* @param 	char* str 	char to append after str_to_store
*/
void append_to_str(char *str) {
	if(str_to_store==NULL)
	{
		str_to_store=new char[strlen(str)+1];
		strcpy(str_to_store,str);
	}else{
		char *temp=new char[strlen(str_to_store)+strlen(str)+1];
		strcpy(temp,str_to_store);
		strcat(temp,str);
		str_to_store=temp;
	}
}
/**
* @brief 	function to remove first and last from "str_to_store"
*			and return the string
* @return 	char* 		removed string
*/
char* remove_first_last() {
	char *temp=new char[strlen(str_to_store)-2];
	strcpy(temp,str_to_store+1);
	temp[strlen(temp)-1]='\0';
	return temp;
}
/**
* @brief 	function to make the str_to_store NULL
*/
void make_str_to_store_null() {
	if(str_to_store!=NULL)
	{
		str_to_store[0]='\0';
	}
}



%}

alpha [a-zA-Z]
alpha_with_underscore [a-zA-Z_]
digit [0-9]
keyword if|else|for|while|do|break|int|char|float|double|void|return|switch|case|default|continue
newline \r?\n
increment "++"|"--"
logic "&&"|"||"
relational "<"|">"|"<="|">="|"=="|"!="
int_litral {digit}+
float_litral {digit}*({digit}\.?|\.{digit}){digit}*([Ee][-+]?{digit}+)?
char \'[ -~]\'
special_char \'\\[\\nfratbv0\']\'
special_char_without_escape \\[\\nfratbv0\']
char_litral {char}|{special_char}
identifier {alpha_with_underscore}({alpha_with_underscore}|{digit})*
comment_start "/*"|"//"


%%
[ \t\v]+ {}

[+-] {
	char* s=strtoupper(yytext);
	printf("additional operator found %s\n", s);
	fprintf(tokenout,"<ADDOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <ADDOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
[=] {
	char* s=strtoupper(yytext);
	printf("assignment operator found %s\n", s);
	fprintf(tokenout,"<ASSIGNOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <ASSIGNOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
[*/%] {
	char* s=strtoupper(yytext);
	printf("multiple operator found %s\n", s);
	fprintf(tokenout,"<MULOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <MULOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
[!] {
	char* s=strtoupper(yytext);
	printf("not operator found %s\n", s);
	fprintf(tokenout,"<NOT, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <NOT, %s> Lexeme %s found\n",line_count,s,yytext);
}
[(] {
	char* s=strtoupper(yytext);
	printf("left parenthesis found %s\n", s);
	fprintf(tokenout,"<LPAREN, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <LPAREN, %s> Lexeme %s found\n",line_count,s,yytext);
}
[)] {
	char* s=strtoupper(yytext);
	printf("right parenthesis found %s\n", s);
	fprintf(tokenout,"<RPAREN, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <RPAREN, %s> Lexeme %s found\n",line_count,s,yytext);
}
[\{] {
	/**
	* todo		need to add the enter scope
	*/
	char* s=strtoupper(yytext);
	printf("left brace found %s\n", s);
	fprintf(tokenout,"<LCURL, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <LCURL, %s> Lexeme %s found\n",line_count,s,yytext);
}
[\}] {
	/**
	* todo		need to add the exit scope
	*/
	char* s=strtoupper(yytext);
	printf("right brace found %s\n", s);
	fprintf(tokenout,"<RCURL, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <RCURL, %s> Lexeme %s found\n",line_count,s,yytext);
}
[\[] {
	char* s=strtoupper(yytext);
	printf("left bracket found %s\n", s);
	fprintf(tokenout,"<LTHIRD, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <LTHIRD, %s> Lexeme %s found\n",line_count,s,yytext);
}
[\]] {
	char* s=strtoupper(yytext);
	printf("right bracket found %s\n", s);
	fprintf(tokenout,"<RTHIRD, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <RTHIRD, %s> Lexeme %s found\n",line_count,s,yytext);
}
[,] {
	char* s=strtoupper(yytext);
	printf("comma found %s\n", s);
	fprintf(tokenout,"<COMMA, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <COMMA, %s> Lexeme %s found\n",line_count,s,yytext);
}
[;] {
	char* s=strtoupper(yytext);
	printf("semicolon found %s\n", s);
	fprintf(tokenout,"<SEMICOLON, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <SEMICOLON, %s> Lexeme %s found\n",line_count,s,yytext);
}
{relational} {
	char* s=strtoupper(yytext);
	printf("relational operator found %s\n", s);
	fprintf(tokenout,"<RELOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <RELOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
{logic} {
	char* s=strtoupper(yytext);
	printf("logic operator found %s\n", s);
	fprintf(tokenout,"<LOGICOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <LOGICOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
{increment} {
	char* s=strtoupper(yytext);
	printf("incremental operator found %s\n", s);
	fprintf(tokenout,"<INCOP, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <INCOP, %s> Lexeme %s found\n",line_count,s,yytext);
}
{keyword} {
	char* s=strtoupper(yytext);
	printf("keyword found %s\n", s);
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
	/**
	* todo		need to symboltable insert the int literal
	*/
	char* s=strtoupper(yytext);
	printf("integer literal found %s\n", s);
	fprintf(tokenout,"<CONST_INT, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <CONST_INT, %s> Lexeme %s found\n",line_count,s,yytext);
}
{float_litral} {
	/**
	* todo		need to symboltable insert the float literal
	*/
	char* s=strtoupper(yytext);
	printf("float literal found %s\n", s);
	fprintf(tokenout,"<CONST_FLOAT, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT, %s> Lexeme %s found\n",line_count,s,yytext);
}
{char_litral} {
	/**
	* todo		need to symboltable insert the char literal
	*/
	char* s=special_to_char(yytext);
	printf("character literal found %s\n", s);
	fprintf(tokenout,"<CONST_CHAR, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <CONST_CHAR, %s> Lexeme %s found\n",line_count,s,yytext);
}
{identifier} {
	/**
	* todo		need to symboltable insert the identifier
	*/
	char* s=yytext;
	printf("identifier found %s\n", s);
	fprintf(tokenout,"<ID, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <ID, %s> Lexeme %s found\n",line_count,s,yytext);
}
[\"] {
	BEGIN string_state;
	append_to_str(yytext);
}
<string_state>{special_char_without_escape} {
	char *s = add_space(yytext);
	char *ptr = special_to_char(s);
	append_to_str(ptr);
	printf("special char found in string literal %s\n", s);
}
<string_state>[\"] {
	/**
	* todo		need to symboltable insert the string literal
	*/
	append_to_str(yytext);
	char* s=remove_first_last();
	printf("string terminator found %s\n", s);
	fprintf(tokenout,"<STRING, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <STRING, %s> Lexeme %s found\n",line_count,s,str_to_store);
	make_str_to_store_null();
	word_count++;
	BEGIN INITIAL;
}
<string_state>[\\] {
	BEGIN string_escape_state;
}
<string_state><<EOF>> {
	append_to_str(yytext);
	error_count++;
	printf("error found: Unfinished string st %s\n", str_to_store);
	fprintf(logout,"Error at line no %d, %d: Unfinished string\n%s",line_count, word_count,str_to_store);
	make_str_to_store_null();
	BEGIN INITIAL;
}
<string_state>{newline} {
	append_to_str(yytext);
	error_count++;
	printf("error found: Unfinished string st %s\n", str_to_store);
	fprintf(logout,"Error at line no %d, %d: Unfinished string\n%s",line_count, word_count,str_to_store);
	make_str_to_store_null();
	line_count++;
	word_count=0;
	BEGIN INITIAL;
}
<string_state>. {
	append_to_str(yytext);	
	word_count++;
}
<string_escape_state>{newline} {
	// this is used to only escape one character and go back to the original state
	line_count++;
	word_count=0;
	printf("escaping new line");
	BEGIN string_state;
}
<string_escape_state>. {
	// this is used to only escape one character and go back to the original state
	printf("escaping character: %d\n", (int)yytext[0]);
	word_count++;
	BEGIN string_state;
}


<<EOF>> {
	printf("Total Line Count: %d\n",line_count);
	return 0;
}
. {
	//increasing the word_count to keep track of the position of the word
	word_count++;
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
	
	logout= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");

	yyin= fin;
	yylex();
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}
