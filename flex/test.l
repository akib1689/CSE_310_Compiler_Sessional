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
/**
* @brief 	function to copy the string to another char pointer
*/
char *strcpy_new(char *dest,char *src)
{
	int i=0;
	while(src[i]!='\0')
	{
		dest[i]=src[i];
		i++;
	}
	dest[i]='\0';
	return dest;
}



%}

letter [a-zA-Z]
digit [0-9]
keyword if|else|for|while|do|break|int|char|float|double|void|return|switch|case|default|continue

newline \n


%%
[ \t\v]+ {}
{keyword} {
	char* s=strtoupper(yytext);
	printf("keyword found %s\n", s);
	fprintf(tokenout,"<%s>", s);
	fprintf(logout,"Line no %d: TOKEN <%s> Lexeme %s found\n",line_count,s,yytext);
	word_count++;
}
{newline} {
	//increase the line_count
	line_count++;
	//reset the word_count
	word_count=0;
}

<<EOF>> {
	printf("Total Line Number: %d\n",line_count);
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
