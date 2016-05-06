type token =
  | COMMENT
  | SEMI
  | LPAREN
  | RPAREN
  | LBRACK
  | RBRACK
  | LBRACE
  | RBRACE
  | LANGLE
  | RANGLE
  | COMMA
  | PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | MODULE
  | ASSIGN
  | NOT
  | EQ
  | PLUSEQ
  | MINUSEQ
  | TIMESEQ
  | DIVIDEEQ
  | MODULEEQ
  | NEQ
  | LEQ
  | GEQ
  | AND
  | OR
  | RIGHTSHIFT
  | LEFTSHIFT
  | DOMAINOP
  | BITAND
  | BITOR
  | BITXOR
  | BITNEG
  | NEWLINE
  | FOR
  | IF
  | ELSE
  | ELIF
  | BREAK
  | CONTINUE
  | WHILE
  | RETURN
  | END
  | INT
  | BOOL
  | FLOAT
  | STRING
  | GAME
  | PLAYER
  | SPRITE
  | MAP
  | INTARRAY
  | FLOATARRAY
  | BOOLARRAY
  | STRINGARRAY
  | VOID
  | TRUE
  | FALSE
  | GT
  | LT
  | STRUCT
  | CLASS
  | EXTENDS
  | LITERAL of (int)
  | FLOATCONSTANT of (float)
  | STRINGCONSTANT of (string)
  | ID of (string)
  | EOF

val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.program
