#simple makefile

mycomp: teac_parser.tab.c lex.yy.c cgen.c
	gcc -o mycomp teac_parser.tab.c lex.yy.c cgen.c -lfl
teac_parser.tab.c:
	bison -d -v -r all teac_parser.y
lex.yy.c:
	flex teac_lex.l

clean:
	rm mycomp teac_parser.output lex.yy.c teac_parser.tab.*