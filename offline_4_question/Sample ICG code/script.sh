yacc -Wyacc -d -y -Wno-yacc parser.y
echo 'Generated the parser C file as well the header file'
g++ -w -c -o y.o y.tab.c
echo 'Generated the parser object file'
flex scanner.l
echo 'Generated the scanner C file'
g++ -w -c -o l.o lex.yy.c
echo 'Generated the scanner object file'
g++ y.o l.o -lfl -o output.o
echo 'All file produced successfully'
./output.o input.txt log.txt error.txt