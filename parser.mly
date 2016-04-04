%{ open Ast %}

%token SEMI LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE LANGLE RANGLE COMMA
%token PLUS MINUS TIMES DIVIDE MODULE ASSIGN NOT
%token EQ PLUSEQ MINUSEQ TIMESEQ DIVIDEEQ MODULEEQ NEQ
%token LEQ  GEQ
%token AND OR
%token RIGHTSHIFT LEFTSHIFT DOMAINOP
%token BITAND BITOR BITXOR BITNEG
%token NEWLINE
%token FOR IF ELSE ELIF BREAK CONTINUE WHILE RETURN END FUN
%token VOID TRUE FALSE
%token GT LT

%token <int> Literal
%token <bool> BoolLit
%token <double> Double
%token <char> Char
%token <string> Id
%token <list> List
%token <dict> Dict
%token <game> Game
%token <player> Player
%token <sprite> Sprite
%token <map> Map
%token EOF


%nonassoc ELSE
%right ASSIGN
%left OR
%left AND
%left EQ
%left EQ NEQ
%left LANGLE RANGLE 
%left LEQ GEQ
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT

%start expr
%type <Ast.expr> expr

%start program
%type <Ast.program> program

%%