%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>		
#include "cgen.h"


extern int yylex(void);
extern int line_num;
%}

%union
{
	char* crepr;
}


%token <crepr> IDENT
%token <crepr> POSINT 
%token <crepr> REAL 
%token <crepr> STRING


/*my code */
%token KW_BOOL
%token KW_TRUE
%token KW_FALSE
%token KW_IF
%token KW_ELSE
%token KW_FI
%token KW_WHILE
%token KW_LOOP
%token KW_POOL
%token KW_BREAK
%token KW_RETURN
%token KW_THEN


%token KW_START 
%token KW_CONST
%token KW_LET
%token KW_INT
%token KW_REAL
%token KW_STRING

%token ASSIGN
%token ARROW

%start program

%type <crepr> decl_list  decl

%type <crepr> variable_decl_body variable_decl_list variable_decl_init decl_id
%type <crepr>  expr expr_list



%type<crepr> basic_data_types
%type<crepr> brackets

%type<crepr> types

%type<crepr> command assign if_stmt func_call while_l retrn

%type<crepr> func_core variable_list variable_body variable_init func_list func_var_list

%type <crepr> const_decl_body const_decl_list const_decl_init

%type<crepr> body body_list

%left KW_OR
%left KW_AND
%left '=' '<' LESSEQ NOTEQ
%left '+' '-'
%left '*' '/' '%'
%precedence sign 
%right KW_NOT 






/*          END DECLARATIONS          */

%%

program: decl_list func_list KW_CONST KW_START ASSIGN '(' ')' ':' KW_INT ARROW '{' body_list '}' { 
	if(yyerror_count==0) {
	  printf("#include <stdlib.h> \n");
	  puts(c_prologue); 
	  printf("%s \n %s\n", $1,$2);
	  printf("int main() {\n%s  \n} \n", $12);
	}
}
|func_list KW_CONST KW_START ASSIGN '(' ')' ':' KW_INT ARROW '{' body_list '}' { 
	if(yyerror_count==0) {
	  printf("#include <stdlib.h> \n");
	  puts(c_prologue); 
	  printf("%s \n \n", $1);
	  printf("int main() {\n%s  \n} \n", $11);
	}
	}
|decl_list KW_CONST KW_START ASSIGN '(' ')' ':' KW_INT ARROW '{' body_list '}' { 
	if(yyerror_count==0) {
	  printf("#include <stdlib.h> \n");
	  puts(c_prologue); 
	  printf("%s \n \n", $1);
	  printf("int main() {\n%s  \n} \n", $11);
	}
	}
|KW_CONST KW_START ASSIGN '(' ')' ':' KW_INT ARROW '{' body_list '}' { 
	if(yyerror_count==0) {
	  printf("#include <stdlib.h> \n");
	  puts(c_prologue); 
	  printf("int main() {\n%s  \n} \n", $10);
	}
	}
;

decl_list: decl_list decl { $$ = template("%s\n%s", $1, $2); }
| decl { $$ = $1; }
;


/* declaration of constants or variables*/

decl: KW_CONST const_decl_body { $$ = template("const %s", $2); }
| KW_LET variable_decl_body { $$ = template("%s",$2); }
;

const_decl_body: const_decl_list ':' basic_data_types ';' {  $$ = template("%s %s;", $3, $1); }
;

variable_decl_body: variable_decl_list ':' basic_data_types ';' {  $$ = template("%s %s;", $3, $1); }
;

const_decl_list: const_decl_list ',' const_decl_init { $$ = template("%s, %s", $1, $3 );}
| const_decl_init { $$ = $1; }
;

variable_decl_list: variable_decl_list ',' variable_decl_init { $$ = template("%s, %s", $1, $3 );}
| variable_decl_init { $$ = $1; }
;


const_decl_init: IDENT ASSIGN expr { $$ = template("%s=%s", $1, $3);}
| IDENT brackets ASSIGN expr { $$ = template("%s[%s]=%s", $1,$2, $4);}
; 

variable_decl_init:decl_id { $$ = $1; }
|decl_id ASSIGN expr { $$ = template("%s=%s", $1, $3);}
; 


decl_id: IDENT { $$ = $1; } 
| IDENT brackets { $$ = template("%s[%s]", $1, $2); }
;



/* Variables and types */


/* single brackets */
brackets: '['POSINT']' {$$ = $2;}
;


basic_data_types:  KW_INT { $$="int";}
| KW_REAL { $$="double";}
| KW_BOOL {$$="int";}
| KW_STRING{$$="char";}
;


/* End Variables and types */



/*    Expressions-Operators   */

expr: types { $$ = template("%s",$1);}
| expr '+' expr { $$ = template("%s+%s",$1,$3); }
| expr '-' expr { $$ = template("%s-%s",$1,$3); }
| expr '*' expr { $$ = template("%s*%s",$1,$3); }
| expr '/' expr { $$ = template("%s/%s",$1,$3); }
| '-' expr %prec sign { $$ = template("-%s",$2); }
| KW_NOT expr  { $$ = template("!%s",$2); }
| '(' expr ')' {$$ = template("(%s)",$2); }
| expr '%' expr { $$ = template("%s%s%s",$1,"%",$3); }
| expr '=' expr { $$ = template("%s==%s",$1,$3); }
| expr '<' expr { $$ = template("%s<%s",$1,$3); }
| expr LESSEQ expr { $$ = template("%s<=%s",$1,$3); }
| expr NOTEQ expr { $$ = template("%s!=%s",$1,$3); }
| expr KW_AND expr { $$ = template("%s and %s",$1,$3); }
| expr KW_OR expr { $$ = template("%s or %s",$1,$3); }
;

types:POSINT { $$ = $1; }
| REAL { $$ = $1; }
| STRING {$$=$1;}
|decl_id {$$=$1;}
| KW_TRUE {$$="1";}
| KW_FALSE {$$="0";}
| func_call {$$=$1;}
;

expr_list:expr_list ',' expr {$$ = template("%s , %s", $1, $3);}
| expr{$$=$1;}
|%empty {$$=" ";}
;




/*           Instructions          */


command:assign {$$=$1;}
| if_stmt {$$=$1;}
| func_call {$$=$1;}
| while_l {$$=$1;}
| retrn {$$=$1;}
;

assign:decl_id ASSIGN expr  { $$ = template("%s=%s", $1, $3);}
;

if_stmt: KW_IF expr KW_THEN body_list KW_FI  { $$ = template("if(%s)  \n { \n %s \n } ",$2,$4); }
| KW_IF expr KW_THEN body_list KW_ELSE body_list KW_FI  { $$ = template("if(%s) \n { \n %s \n } \n else \n { \n %s \n }",$2,$4,$6); }
;

func_call:IDENT '('expr_list')'  {$$ = template("%s(%s)", $1, $3);}
;

while_l:KW_WHILE expr KW_LOOP body_list KW_POOL { $$ = template("while(%s)  \n \t{ \n %s \n \t } ",$2,$4); }
;

retrn:KW_RETURN expr {$$ = template("return %s",$2);}
| KW_RETURN  {$$ = "return ";} 
;


/*              Functions            */



func_list:func_list func_core { $$ = template("%s\n%s", $1, $2); }
| func_core{ $$=$1;}
;
func_core: KW_CONST IDENT ASSIGN '(' func_var_list ')' ':' basic_data_types ARROW '{' body_list '}' ';' 
{ $$ = template("%s %s(%s){%s}", $8, $2,$5,$11);}
;

func_var_list:variable_list{$$=$1;}
|%empty {$$=" ";}
;

variable_list:variable_body ',' variable_list { $$ = template("%s, %s", $3, $1); }
| variable_body {$$ = $1;}
;

variable_body: variable_init ':' basic_data_types {  $$ = template("%s %s", $3, $1); }
;

variable_init: variable_init ',' decl_id { $$ = template("%s, %s", $1, $3 );}
| decl_id { $$ = $1; }
;



/*      Body       */
body_list:body_list body { $$ = template("%s \n %s", $1, $2);}
|body{$$=$1;}
;

body:decl {$$=$1;}
|command ';' {$$ = template("%s;", $1);}
;


%%
int main () {
  if ( yyparse() != 0 )
    printf("Rejected!\n");
}

