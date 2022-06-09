%option noyywrap yylineno

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
	for(int i=0;str[i]!='\0';i++)
	{
		if(str[i]>='a' && str[i]<='z')
		{
			str[i]=str[i]-32;
		}
	}
	return str;
}



%}

character [a-zA-Z]
digit [0-9]
keyword if|else|for|while|do|break|int|char|float|double|void|return|switch|case|default|continue
newline \n
increment "++"|"--"
relational "<"|">"|"<="|">="|"=="|"!="
int_litral {digit}+

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
	char* s=strtoupper(yytext);
	printf("integer literal found %s\n", s);
	fprintf(tokenout,"<CONST_INT, %s>", s);
	fprintf(logout,"Line no %d: TOKEN <CONST_INT, %s> Lexeme %s found\n",line_count,s,yytext);
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
