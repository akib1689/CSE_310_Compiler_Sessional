flex $1.l
g++ lex.yy.c -lfl -o $1.out
./$1.out $1.txt