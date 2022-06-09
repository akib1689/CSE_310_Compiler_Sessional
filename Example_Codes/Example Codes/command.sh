flex -o $1.c $1.l
g++ $1.c -lfl -o $1.out
./$1.out $1.txt
