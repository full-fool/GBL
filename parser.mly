%{ open Ast %}

%token SEMI LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE LANGLE RANGLE COMMA
%token Add Sub Mult Div Mod Assign Neg Not
%token Equal AddEqual SubEqual MulEqual DivEqual ModEqual Neq
%token Leq  Geq
%token And Or Is Xor
%token ShiftLeft ShiftRight At
%token BITAND BITXOR BITNEG
%token NEWLINE
%token FOR IF ELSE ELIF BREAK CONTINUE WHILE RETURN END FUN
(* we need  *)
%token VOID TRUE FALSE

%token <int> Literal
%token <bool> BoolLit
%token <double> Double
%token <char> Char
%token <string> Id
%token <intarray> IntArray
%token <chararray> chararray
%token <boolarray> BoolArray
%token <doublearray> DoubleArray
%token <stringarray> StringArray
%token <game> Game
%token <player> Player
%token <sprite> Sprite
%token <map> Map
%token EOF


%nonaasoc ELSE
%right Assign
%left Or
%left And
%left Is
%left Xor
%left Equal Neq
%left LANGLE RANGLE 
%left Leq Geq
%left Add Sub
%left Mult Div
%right Not Neg

%start expr
%type <Ast.expr> expr

%start program
%type <Ast.program> program

%%
