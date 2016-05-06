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
<<<<<<< HEAD
  | STRUCT
  | CLASS
  | EXTENDS
=======
>>>>>>> 70f38b2f0bc75e44df8d3f97c68b2ba492acb346
  | LITERAL of (int)
  | FLOATCONSTANT of (float)
  | STRINGCONSTANT of (string)
  | ID of (string)
  | EOF

val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.program
