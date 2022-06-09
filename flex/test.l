%option noyywrap yylineno

%x string_state
%x comment_state

%{
#include<stdio.h>
#include<stdlib.h>

FILE *logout;
FILE *tokenout;

int word_count=0;
int line_count=1;

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
* @brief 	function to convert the char litral to single char
* @param 	char* str 	char in format 'char'
* @return 	char* 		converted string
*/
char *char_to_single(char *str) {
	char *p = new char;
	p[0]=str[1];
	p[1]='\0';
	return p;
}
/**
* @brief 	function to convert 
*			the special char literal to individual special character
* @param 	char* str 	char in format '\char'
* @return 	char* 		converted corresponding char code
*/
char *special_to_char(char *str) {
	char *p = new char;
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



%}

alpha [a-zA-Z]
alpha_with_underscore [a-zA-Z_]
digit [0-9]
keyword if|else|for|while|do|break|int|char|float|double|void|return|switch|case|default|continue
newline \n
increment "++"|"--"
relational "<"|">"|"<="|">="|"=="|"!="
int_litral {digit}+
float_litral {digit}*({digit}\.?|\.{digit}){digit}*([Ee][-+]?{digit}+)?
char \'[ -~]\'
special_char \'\\[\\nfratbv0\"\']\'
identifier {alpha_with_underscore}({alpha_with_underscore}|{digit})*

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
{char} {
	/**
	* todo		need to symboltable insert the char literal
	*/
	char* s=char_to_single(yytext);
	printf("character literal found %s\n", s);
	fprintf(tokenout,"<CONST_CHAR, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <CONST_CHAR, %s> Lexeme %s found\n",line_count,s,yytext);
}
{special_char} {
	/**
	* todo		need to symboltable insert the special char literal
	*/
	char* s=special_to_char(yytext);
	printf("special character literal found %s\n", s);
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
