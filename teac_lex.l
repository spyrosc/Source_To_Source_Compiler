%{
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "teac_parser.tab.h"
#include "cgen.h"


int line_num = 1;

%}

IDENT [a-zA-Z_][0-9a-zA-Z_]*
DIGIT  [0-9]
NUMBER  {DIGIT}{DIGIT}*
DECIMAL ("."{NUMBER})|({NUMBER}("."{NUMBER}?)?)
REAL    {DECIMAL}([eE][+-]?{NUMBER})?
STRING  \"[^\n]*\" 

%x comment



%%

start		{ printf("//token : %s\n", yytext); return KW_START; }
const 		{ printf("//token : %s\n", yytext); return KW_CONST; }
let			{ printf("//token : %s\n", yytext); return KW_LET;}
int         { printf("//token : %s\n", yytext); return KW_INT;}
real        { printf("//token : %s\n", yytext) ;return KW_REAL;}
string      { printf("//token : %s\n", yytext);  return KW_STRING;} 

then        { printf("//token : %s\n", yytext); return KW_THEN; }
and 		{ printf("//token : %s\n", yytext); return KW_AND; }
or 			{ printf("//token : %s\n", yytext) ;return KW_OR;}
not 		{ printf("//token : %s\n", yytext) ;return KW_NOT;}
bool		{ printf("//token : %s\n", yytext) ;return KW_BOOL;}

true		{ printf("//token : %s\n", yytext); return KW_TRUE;}

false		{ printf("//token : %s\n", yytext); return KW_FALSE;}

if 			{ printf("//token : %s\n", yytext) ;return KW_IF;}
else		{ printf("//token : %s\n", yytext) ;return KW_ELSE;}
fi			{ printf("//token : %s\n", yytext) ;return KW_FI;}
while		{ printf("//token : %s\n", yytext) ;return KW_WHILE;}
loop		{ printf("//token : %s\n", yytext) ;return KW_LOOP;}
pool		{ printf("//token : %s\n", yytext) ;return KW_POOL;}
break		{ printf("//token : %s\n", yytext) ;return KW_BREAK;}
return		{ printf("//token : %s\n", yytext) ;return KW_RETURN;} 




{IDENT}  	     { printf("//token : %s\n", yytext);
						yylval.crepr = strdup(yytext); 
					return IDENT; }

{NUMBER}			{ printf("//token : %s\n", yytext);
						yylval.crepr = strdup(yytext); 
					return POSINT; }
{REAL}				{  printf("//token : %s\n", yytext);
						yylval.crepr = strdup(yytext); 
					 return REAL; }
{STRING}			{ printf("//token : %s\n", yytext);
						yylval.crepr = strdup(yytext); 
					return STRING; }


"-"               { printf("//token : %s\n", yytext); return '-'; } 
"/"                { printf("//token : %s\n", yytext); return '/'; }
"%"                { printf("//token : %s\n", yytext); return '%'; }
"="                { printf("//token : %s\n", yytext); return '='; }
"!="              { printf("//token : %s\n", yytext); return NOTEQ; }
"<"                { printf("//token : %s\n", yytext); return '<'; }
"<="              { printf("//token : %s\n", yytext); return LESSEQ; }




"<-"		       { printf("//token : %s\n", yytext) ; return ASSIGN;}
"=>"         	{ printf("//token : %s\n", yytext); return ARROW;}
":"		        { printf("//token : %s\n", yytext);  return ':';}
","           { printf("//token : %s\n", yytext);  return ',';}
"+"						{ printf("//token : %s\n", yytext);  return '+';}
"*"						{ printf("//token : %s\n", yytext);  return '*';}
";"						{ printf("//token : %s\n", yytext);  return ';';}
"."						{ printf("//token : %s\n", yytext);  return '.';}
"("						{ printf("//token : %s\n", yytext);  return '(';}
")"						{ printf("//token : %s\n", yytext);  return ')';}

"["						{ printf("//token : %s\n", yytext);  return '[';}
"]"						{ printf("//token : %s\n", yytext);  return ']';}

"{"						{ printf("//token : %s\n", yytext);  return '{';}
"}"						{ printf("//token : %s\n", yytext);  return '}';}


"--"[^\n]*  	/* eat line comments */

"(*"					BEGIN(comment);
<comment>[^*\n]*        /*   eat anything that's not a '*'    */
<comment>"*"+[^*)\n]*   /*   eat up '*'s not followed by ')'s    */
<comment>\n             ++line_num;
<comment>"*"+")"        BEGIN(INITIAL);


[ \r\t]+				/* skip whitespace */
\n 						++line_num;
<<EOF>> 			return EOF;

.             { yyerror("lexical error: unrecognized literal '%s'\n", yytext); }


%%


