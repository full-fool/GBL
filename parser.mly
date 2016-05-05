%{ open Ast %}

%token COMMENT SEMI LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE LANGLE RANGLE COMMA
%token PLUS MINUS TIMES DIVIDE MODULE ASSIGN NOT
%token EQ PLUSEQ MINUSEQ TIMESEQ DIVIDEEQ MODULEEQ NEQ
%token LEQ  GEQ
%token AND OR
%token RIGHTSHIFT LEFTSHIFT DOMAINOP
%token BITAND BITOR BITXOR BITNEG
%token NEWLINE
%token FOR IF ELSE ELIF BREAK CONTINUE WHILE RETURN END 
%token INT BOOL FLOAT STRING GAME PLAYER SPRITE MAP
%token INTARRAY FLOATARRAY BOOLARRAY STRINGARRAY
%token VOID TRUE FALSE
%token GT LT

%token <int> LITERAL
%token <float> FLOATCONSTANT
%token <string> STRINGCONSTANT
%token <string> ID
%token EOF


%nonassoc ELSE
%right ASSIGN
%left OR
%left AND
%left EQ NEQ
%left LANGLE RANGLE 
%left LEQ GEQ
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT

%start program
%type <Ast.program> program

%%

program:
  decls EOF { $1 }

decls:
   /* nothing */ { [], [] }
 | decls vdecl { ($2 :: fst $1), snd $1 }
 | decls fdecl { fst $1, ($2 :: snd $1) }

fdecl:
   typ ID LPAREN formals_opt RPAREN LBRACE vdecl_list stmt_list RBRACE
     { { typ = $1;
   fname = $2;
   formals = $4;
   locals = List.rev $7;
   body = List.rev $8 } }


formals_opt:
    /* nothing */ { [] }
  | formal_list   { List.rev $1 }


formal_list:
    typ ID                   { [($1,$2)] }
  | formal_list COMMA typ ID { ($3,$4) :: $1 }


typ:
    INT         { Int         }
  | BOOL        { Bool        }
  | FLOAT       { Float       }
  | STRING      { String      }
  | VOID        { Void        }
  | GAME        { Game        }
  | PLAYER      { Player      }
  | SPRITE      { Sprite      }
  | MAP         { Map         }
  | INTARRAY    { IntArray    }
  | BOOLARRAY   { BoolArray   }
  | FLOATARRAY  { FloatArray  }
  | STRINGARRAY { StringArray }


vdecl_list:
    /* nothing */    { [] }
  | vdecl_list vdecl { $2 :: $1 }


vdecl:
   typ ID SEMI { ($1, $2) }


stmt_list:
    /* nothing */  { [] }
  | stmt_list stmt { $2 :: $1 }
  

stmt:
    expr SEMI { Expr $1 }
  | RETURN SEMI { Return Noexpr }
  | RETURN expr SEMI { Return $2 }
  | LBRACE stmt_list RBRACE { Block(List.rev $2) }
  | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
  | FOR LPAREN expr_opt SEMI expr SEMI expr_opt RPAREN stmt
     { For($3, $5, $7, $9) }
  | WHILE LPAREN expr RPAREN stmt { While($3, $5) }

expr_opt:
    /* nothing */ { Noexpr }
  | expr          { $1 }

expr:
    LITERAL          { Literal($1)          }
  | FLOATCONSTANT    { FloatLit($1)         }
  | STRINGCONSTANT   { StringLit($1)        }
  | TRUE             { BoolLit(true)        }
  | FALSE            { BoolLit(false)       }
  | ID               { Id($1)               }
  | ID LBRACK LITERAL RBRACK {Arrayele($1, $3)}
  | expr PLUS   expr { Binop($1, Add,   $3) }
  | expr MINUS  expr { Binop($1, Sub,   $3) }
  | expr TIMES  expr { Binop($1, Mult,  $3) }
  | expr DIVIDE expr { Binop($1, Div,   $3) }
  | expr EQ     expr { Binop($1, Is, $3) }
  | expr NEQ    expr { Binop($1, Neq,   $3) }
  | expr LT     expr { Binop($1, Less,  $3) }
  | expr LEQ    expr { Binop($1, Leq,   $3) }
  | expr GT     expr { Binop($1, Greater, $3) }
  | expr GEQ    expr { Binop($1, Geq,   $3) }
  | expr AND    expr { Binop($1, And,   $3) }
  | expr OR     expr { Binop($1, Or,    $3) }
  | NOT expr         { Unop(Not, $2) }
  | ID ASSIGN expr   { Assign($1, $3) }
  | ID LPAREN actuals_opt RPAREN { Call($1, $3) }
  | LPAREN expr RPAREN { $2 }

actuals_opt:
    /* nothing */ { [] }
  | actuals_list  { List.rev $1 }

actuals_list:
    expr                    { [$1] }
  | actuals_list COMMA expr { $3 :: $1 }