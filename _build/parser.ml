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
  | LITERAL of (int)
  | FLOATCONSTANT of (float)
  | STRINGCONSTANT of (string)
  | ID of (string)
  | EOF

open Parsing;;
let _ = parse_error;;
# 1 "parser.mly"
 open Ast 
# 76 "parser.ml"
let yytransl_const = [|
  257 (* COMMENT *);
  258 (* SEMI *);
  259 (* LPAREN *);
  260 (* RPAREN *);
  261 (* LBRACK *);
  262 (* RBRACK *);
  263 (* LBRACE *);
  264 (* RBRACE *);
  265 (* LANGLE *);
  266 (* RANGLE *);
  267 (* COMMA *);
  268 (* PLUS *);
  269 (* MINUS *);
  270 (* TIMES *);
  271 (* DIVIDE *);
  272 (* MODULE *);
  273 (* ASSIGN *);
  274 (* NOT *);
  275 (* EQ *);
  276 (* PLUSEQ *);
  277 (* MINUSEQ *);
  278 (* TIMESEQ *);
  279 (* DIVIDEEQ *);
  280 (* MODULEEQ *);
  281 (* NEQ *);
  282 (* LEQ *);
  283 (* GEQ *);
  284 (* AND *);
  285 (* OR *);
  286 (* RIGHTSHIFT *);
  287 (* LEFTSHIFT *);
  288 (* DOMAINOP *);
  289 (* BITAND *);
  290 (* BITOR *);
  291 (* BITXOR *);
  292 (* BITNEG *);
  293 (* NEWLINE *);
  294 (* FOR *);
  295 (* IF *);
  296 (* ELSE *);
  297 (* ELIF *);
  298 (* BREAK *);
  299 (* CONTINUE *);
  300 (* WHILE *);
  301 (* RETURN *);
  302 (* END *);
  303 (* INT *);
  304 (* BOOL *);
  305 (* FLOAT *);
  306 (* STRING *);
  307 (* GAME *);
  308 (* PLAYER *);
  309 (* SPRITE *);
  310 (* MAP *);
  311 (* INTARRAY *);
  312 (* FLOATARRAY *);
  313 (* BOOLARRAY *);
  314 (* STRINGARRAY *);
  315 (* VOID *);
  316 (* TRUE *);
  317 (* FALSE *);
  318 (* GT *);
  319 (* LT *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  320 (* LITERAL *);
  321 (* FLOATCONSTANT *);
  322 (* STRINGCONSTANT *);
  323 (* ID *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\004\000\006\000\006\000\009\000\
\009\000\005\000\005\000\005\000\005\000\005\000\005\000\005\000\
\005\000\005\000\005\000\005\000\005\000\005\000\007\000\007\000\
\003\000\008\000\008\000\010\000\010\000\010\000\010\000\010\000\
\010\000\010\000\012\000\012\000\011\000\011\000\011\000\011\000\
\011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
\011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
\011\000\011\000\013\000\013\000\014\000\014\000\000\000"

let yylen = "\002\000\
\002\000\000\000\002\000\002\000\009\000\000\000\001\000\002\000\
\004\000\001\000\001\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\001\000\001\000\000\000\002\000\
\003\000\000\000\002\000\002\000\002\000\003\000\003\000\007\000\
\009\000\005\000\000\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\003\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\003\000\003\000\003\000\003\000\002\000\003\000\
\004\000\003\000\000\000\001\000\001\000\003\000\002\000"

let yydefred = "\000\000\
\002\000\000\000\063\000\000\000\010\000\011\000\012\000\013\000\
\015\000\016\000\017\000\018\000\019\000\021\000\020\000\022\000\
\014\000\001\000\003\000\004\000\000\000\000\000\025\000\000\000\
\000\000\000\000\000\000\008\000\000\000\000\000\023\000\000\000\
\000\000\009\000\024\000\000\000\000\000\000\000\000\000\026\000\
\005\000\000\000\000\000\000\000\000\000\000\000\040\000\041\000\
\037\000\038\000\039\000\000\000\027\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\029\000\000\000\000\000\000\000\
\028\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\058\000\031\000\000\000\
\000\000\000\000\000\000\030\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\057\000\
\000\000\000\000\000\000\034\000\000\000\000\000\000\000\000\000\
\032\000\000\000\033\000"

let yydgoto = "\002\000\
\003\000\004\000\019\000\020\000\021\000\026\000\033\000\037\000\
\027\000\053\000\054\000\081\000\086\000\087\000"

let yysindex = "\003\000\
\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\197\254\020\255\000\000\015\001\
\228\254\039\255\056\255\000\000\063\255\015\001\000\000\013\255\
\015\001\000\000\000\000\019\255\038\255\085\255\075\255\000\000\
\000\000\075\255\086\255\089\255\097\255\008\255\000\000\000\000\
\000\000\000\000\000\000\255\254\000\000\203\255\059\000\046\255\
\251\254\075\255\075\255\075\255\000\000\224\255\075\255\075\255\
\000\000\075\255\075\255\075\255\075\255\075\255\075\255\075\255\
\075\255\075\255\075\255\075\255\075\255\000\000\000\000\122\000\
\099\255\077\000\104\000\000\000\122\000\112\255\104\255\122\000\
\254\254\254\254\251\254\251\254\082\255\082\255\139\255\139\255\
\020\000\143\000\122\000\122\000\075\255\119\255\119\255\000\000\
\075\255\255\255\080\255\000\000\122\000\075\255\119\255\113\255\
\000\000\119\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\117\255\
\000\000\000\000\120\255\000\000\000\000\000\000\000\000\000\000\
\111\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\185\255\000\000\000\000\000\000\000\000\
\161\000\121\255\000\000\000\000\000\000\000\000\123\255\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\061\255\
\000\000\000\000\000\000\000\000\036\255\000\000\124\255\040\255\
\227\000\246\000\189\000\208\000\163\255\032\001\002\001\021\001\
\231\255\064\000\048\255\077\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\044\255\126\255\000\000\000\000\
\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\000\000\092\000\000\000\241\255\000\000\000\000\091\000\
\000\000\159\255\217\255\022\000\000\000\000\000"

let yytablesize = 586
let yytable = "\055\000\
\018\000\063\000\057\000\001\000\107\000\108\000\062\000\022\000\
\025\000\061\000\039\000\068\000\069\000\113\000\032\000\064\000\
\115\000\036\000\080\000\082\000\083\000\023\000\024\000\085\000\
\088\000\042\000\089\000\090\000\091\000\092\000\093\000\094\000\
\095\000\096\000\097\000\098\000\099\000\100\000\028\000\061\000\
\039\000\056\000\029\000\056\000\040\000\041\000\061\000\062\000\
\039\000\051\000\056\000\051\000\040\000\079\000\062\000\042\000\
\076\000\077\000\051\000\076\000\077\000\106\000\036\000\042\000\
\036\000\109\000\030\000\047\000\048\000\031\000\080\000\049\000\
\050\000\051\000\052\000\043\000\044\000\039\000\049\000\034\000\
\049\000\045\000\046\000\043\000\044\000\038\000\023\000\049\000\
\058\000\045\000\046\000\059\000\042\000\066\000\067\000\068\000\
\069\000\047\000\048\000\060\000\101\000\049\000\050\000\051\000\
\052\000\047\000\048\000\072\000\073\000\049\000\050\000\051\000\
\052\000\026\000\105\000\104\000\114\000\026\000\026\000\111\000\
\006\000\039\000\035\000\007\000\035\000\040\000\059\000\060\000\
\026\000\035\000\056\000\112\000\000\000\000\000\047\000\048\000\
\042\000\000\000\049\000\050\000\051\000\052\000\000\000\076\000\
\077\000\000\000\000\000\000\000\026\000\026\000\066\000\067\000\
\068\000\069\000\026\000\026\000\043\000\044\000\000\000\000\000\
\000\000\000\000\045\000\046\000\047\000\000\000\047\000\000\000\
\000\000\000\000\026\000\026\000\000\000\047\000\026\000\026\000\
\026\000\026\000\047\000\048\000\000\000\047\000\049\000\050\000\
\051\000\052\000\042\000\047\000\042\000\000\000\047\000\047\000\
\000\000\000\000\000\000\042\000\042\000\042\000\042\000\042\000\
\076\000\077\000\000\000\042\000\065\000\000\000\000\000\000\000\
\000\000\042\000\042\000\042\000\042\000\042\000\066\000\067\000\
\068\000\069\000\000\000\000\000\000\000\070\000\000\000\000\000\
\000\000\084\000\000\000\071\000\072\000\073\000\074\000\075\000\
\053\000\000\000\053\000\066\000\067\000\068\000\069\000\000\000\
\000\000\053\000\070\000\000\000\000\000\000\000\042\000\042\000\
\071\000\072\000\073\000\074\000\075\000\000\000\000\000\000\000\
\110\000\000\000\053\000\053\000\000\000\000\000\000\000\000\000\
\076\000\077\000\066\000\067\000\068\000\069\000\000\000\000\000\
\000\000\070\000\000\000\000\000\000\000\000\000\000\000\071\000\
\072\000\073\000\074\000\075\000\000\000\076\000\077\000\066\000\
\067\000\068\000\069\000\000\000\000\000\000\000\070\000\000\000\
\000\000\000\000\000\000\000\000\071\000\072\000\073\000\005\000\
\006\000\007\000\008\000\009\000\010\000\011\000\012\000\013\000\
\014\000\015\000\016\000\017\000\076\000\077\000\078\000\000\000\
\000\000\054\000\000\000\054\000\000\000\000\000\066\000\067\000\
\068\000\069\000\054\000\000\000\000\000\070\000\000\000\000\000\
\102\000\076\000\077\000\071\000\072\000\073\000\074\000\075\000\
\066\000\067\000\068\000\069\000\054\000\000\000\000\000\070\000\
\000\000\000\000\000\000\000\000\000\000\071\000\072\000\073\000\
\074\000\075\000\000\000\103\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\066\000\067\000\068\000\069\000\000\000\
\076\000\077\000\070\000\000\000\000\000\000\000\000\000\000\000\
\071\000\072\000\073\000\074\000\075\000\066\000\067\000\068\000\
\069\000\000\000\076\000\077\000\070\000\000\000\000\000\000\000\
\000\000\000\000\071\000\072\000\073\000\074\000\075\000\000\000\
\000\000\000\000\066\000\067\000\068\000\069\000\000\000\000\000\
\000\000\070\000\055\000\000\000\055\000\076\000\077\000\071\000\
\072\000\073\000\074\000\055\000\055\000\055\000\055\000\055\000\
\000\000\000\000\000\000\055\000\000\000\000\000\000\000\076\000\
\077\000\055\000\055\000\055\000\055\000\055\000\045\000\000\000\
\045\000\000\000\000\000\000\000\000\000\000\000\000\000\045\000\
\045\000\045\000\045\000\045\000\076\000\077\000\000\000\045\000\
\000\000\046\000\000\000\046\000\000\000\045\000\045\000\045\000\
\045\000\045\000\046\000\046\000\046\000\046\000\046\000\000\000\
\000\000\000\000\046\000\000\000\043\000\000\000\043\000\000\000\
\046\000\046\000\046\000\046\000\046\000\043\000\043\000\043\000\
\000\000\000\000\000\000\000\000\000\000\043\000\000\000\044\000\
\000\000\044\000\000\000\043\000\043\000\043\000\043\000\043\000\
\044\000\044\000\044\000\050\000\000\000\050\000\000\000\000\000\
\044\000\000\000\000\000\000\000\050\000\000\000\044\000\044\000\
\044\000\044\000\044\000\000\000\050\000\000\000\052\000\000\000\
\052\000\000\000\050\000\050\000\050\000\050\000\050\000\052\000\
\000\000\048\000\000\000\048\000\000\000\000\000\000\000\052\000\
\000\000\000\000\048\000\000\000\000\000\052\000\052\000\052\000\
\052\000\052\000\048\000\000\000\000\000\000\000\000\000\000\000\
\048\000\000\000\000\000\048\000\048\000\005\000\006\000\007\000\
\008\000\009\000\010\000\011\000\012\000\013\000\014\000\015\000\
\016\000\017\000"

let yycheck = "\039\000\
\000\000\003\001\042\000\001\000\102\000\103\000\046\000\067\001\
\024\000\002\001\003\001\014\001\015\001\111\000\030\000\017\001\
\114\000\033\000\058\000\059\000\060\000\002\001\003\001\063\000\
\064\000\018\001\066\000\067\000\068\000\069\000\070\000\071\000\
\072\000\073\000\074\000\075\000\076\000\077\000\067\001\004\001\
\003\001\002\001\004\001\004\001\007\001\008\001\011\001\004\001\
\003\001\002\001\011\001\004\001\007\001\008\001\011\001\018\001\
\062\001\063\001\011\001\062\001\063\001\101\000\002\001\018\001\
\004\001\105\000\011\001\060\001\061\001\007\001\110\000\064\001\
\065\001\066\001\067\001\038\001\039\001\003\001\002\001\067\001\
\004\001\044\001\045\001\038\001\039\001\067\001\002\001\011\001\
\003\001\044\001\045\001\003\001\018\001\012\001\013\001\014\001\
\015\001\060\001\061\001\003\001\002\001\064\001\065\001\066\001\
\067\001\060\001\061\001\026\001\027\001\064\001\065\001\066\001\
\067\001\003\001\011\001\004\001\004\001\007\001\008\001\040\001\
\004\001\003\001\002\001\004\001\033\000\007\001\004\001\004\001\
\018\001\004\001\040\000\110\000\255\255\255\255\060\001\061\001\
\018\001\255\255\064\001\065\001\066\001\067\001\255\255\062\001\
\063\001\255\255\255\255\255\255\038\001\039\001\012\001\013\001\
\014\001\015\001\044\001\045\001\038\001\039\001\255\255\255\255\
\255\255\255\255\044\001\045\001\002\001\255\255\004\001\255\255\
\255\255\255\255\060\001\061\001\255\255\011\001\064\001\065\001\
\066\001\067\001\060\001\061\001\255\255\019\001\064\001\065\001\
\066\001\067\001\002\001\025\001\004\001\255\255\028\001\029\001\
\255\255\255\255\255\255\011\001\012\001\013\001\014\001\015\001\
\062\001\063\001\255\255\019\001\002\001\255\255\255\255\255\255\
\255\255\025\001\026\001\027\001\028\001\029\001\012\001\013\001\
\014\001\015\001\255\255\255\255\255\255\019\001\255\255\255\255\
\255\255\002\001\255\255\025\001\026\001\027\001\028\001\029\001\
\002\001\255\255\004\001\012\001\013\001\014\001\015\001\255\255\
\255\255\011\001\019\001\255\255\255\255\255\255\062\001\063\001\
\025\001\026\001\027\001\028\001\029\001\255\255\255\255\255\255\
\002\001\255\255\028\001\029\001\255\255\255\255\255\255\255\255\
\062\001\063\001\012\001\013\001\014\001\015\001\255\255\255\255\
\255\255\019\001\255\255\255\255\255\255\255\255\255\255\025\001\
\026\001\027\001\028\001\029\001\255\255\062\001\063\001\012\001\
\013\001\014\001\015\001\255\255\255\255\255\255\019\001\255\255\
\255\255\255\255\255\255\255\255\025\001\026\001\027\001\047\001\
\048\001\049\001\050\001\051\001\052\001\053\001\054\001\055\001\
\056\001\057\001\058\001\059\001\062\001\063\001\004\001\255\255\
\255\255\002\001\255\255\004\001\255\255\255\255\012\001\013\001\
\014\001\015\001\011\001\255\255\255\255\019\001\255\255\255\255\
\004\001\062\001\063\001\025\001\026\001\027\001\028\001\029\001\
\012\001\013\001\014\001\015\001\029\001\255\255\255\255\019\001\
\255\255\255\255\255\255\255\255\255\255\025\001\026\001\027\001\
\028\001\029\001\255\255\004\001\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\012\001\013\001\014\001\015\001\255\255\
\062\001\063\001\019\001\255\255\255\255\255\255\255\255\255\255\
\025\001\026\001\027\001\028\001\029\001\012\001\013\001\014\001\
\015\001\255\255\062\001\063\001\019\001\255\255\255\255\255\255\
\255\255\255\255\025\001\026\001\027\001\028\001\029\001\255\255\
\255\255\255\255\012\001\013\001\014\001\015\001\255\255\255\255\
\255\255\019\001\002\001\255\255\004\001\062\001\063\001\025\001\
\026\001\027\001\028\001\011\001\012\001\013\001\014\001\015\001\
\255\255\255\255\255\255\019\001\255\255\255\255\255\255\062\001\
\063\001\025\001\026\001\027\001\028\001\029\001\002\001\255\255\
\004\001\255\255\255\255\255\255\255\255\255\255\255\255\011\001\
\012\001\013\001\014\001\015\001\062\001\063\001\255\255\019\001\
\255\255\002\001\255\255\004\001\255\255\025\001\026\001\027\001\
\028\001\029\001\011\001\012\001\013\001\014\001\015\001\255\255\
\255\255\255\255\019\001\255\255\002\001\255\255\004\001\255\255\
\025\001\026\001\027\001\028\001\029\001\011\001\012\001\013\001\
\255\255\255\255\255\255\255\255\255\255\019\001\255\255\002\001\
\255\255\004\001\255\255\025\001\026\001\027\001\028\001\029\001\
\011\001\012\001\013\001\002\001\255\255\004\001\255\255\255\255\
\019\001\255\255\255\255\255\255\011\001\255\255\025\001\026\001\
\027\001\028\001\029\001\255\255\019\001\255\255\002\001\255\255\
\004\001\255\255\025\001\026\001\027\001\028\001\029\001\011\001\
\255\255\002\001\255\255\004\001\255\255\255\255\255\255\019\001\
\255\255\255\255\011\001\255\255\255\255\025\001\026\001\027\001\
\028\001\029\001\019\001\255\255\255\255\255\255\255\255\255\255\
\025\001\255\255\255\255\028\001\029\001\047\001\048\001\049\001\
\050\001\051\001\052\001\053\001\054\001\055\001\056\001\057\001\
\058\001\059\001"

let yynames_const = "\
  COMMENT\000\
  SEMI\000\
  LPAREN\000\
  RPAREN\000\
  LBRACK\000\
  RBRACK\000\
  LBRACE\000\
  RBRACE\000\
  LANGLE\000\
  RANGLE\000\
  COMMA\000\
  PLUS\000\
  MINUS\000\
  TIMES\000\
  DIVIDE\000\
  MODULE\000\
  ASSIGN\000\
  NOT\000\
  EQ\000\
  PLUSEQ\000\
  MINUSEQ\000\
  TIMESEQ\000\
  DIVIDEEQ\000\
  MODULEEQ\000\
  NEQ\000\
  LEQ\000\
  GEQ\000\
  AND\000\
  OR\000\
  RIGHTSHIFT\000\
  LEFTSHIFT\000\
  DOMAINOP\000\
  BITAND\000\
  BITOR\000\
  BITXOR\000\
  BITNEG\000\
  NEWLINE\000\
  FOR\000\
  IF\000\
  ELSE\000\
  ELIF\000\
  BREAK\000\
  CONTINUE\000\
  WHILE\000\
  RETURN\000\
  END\000\
  INT\000\
  BOOL\000\
  FLOAT\000\
  STRING\000\
  GAME\000\
  PLAYER\000\
  SPRITE\000\
  MAP\000\
  INTARRAY\000\
  FLOATARRAY\000\
  BOOLARRAY\000\
  STRINGARRAY\000\
  VOID\000\
  TRUE\000\
  FALSE\000\
  GT\000\
  LT\000\
  EOF\000\
  "

let yynames_block = "\
  LITERAL\000\
  FLOATCONSTANT\000\
  STRINGCONSTANT\000\
  ID\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    Obj.repr(
# 41 "parser.mly"
            ( _1 )
# 464 "parser.ml"
               : Ast.program))
; (fun __caml_parser_env ->
    Obj.repr(
# 44 "parser.mly"
                 ( [], [] )
# 470 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'vdecl) in
    Obj.repr(
# 45 "parser.mly"
               ( (_2 :: fst _1), snd _1 )
# 478 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'fdecl) in
    Obj.repr(
# 46 "parser.mly"
               ( fst _1, (_2 :: snd _1) )
# 486 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 8 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 7 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 5 : 'formals_opt) in
    let _7 = (Parsing.peek_val __caml_parser_env 2 : 'vdecl_list) in
    let _8 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 50 "parser.mly"
     ( { typ = _1;
	 fname = _2;
	 formals = _4;
	 locals = List.rev _7;
	 body = List.rev _8 } )
# 501 "parser.ml"
               : 'fdecl))
; (fun __caml_parser_env ->
    Obj.repr(
# 57 "parser.mly"
                  ( [] )
# 507 "parser.ml"
               : 'formals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'formal_list) in
    Obj.repr(
# 58 "parser.mly"
                  ( List.rev _1 )
# 514 "parser.ml"
               : 'formals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 61 "parser.mly"
                             ( [(_1,_2)] )
# 522 "parser.ml"
               : 'formal_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'formal_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 62 "parser.mly"
                             ( (_3,_4) :: _1 )
# 531 "parser.ml"
               : 'formal_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 65 "parser.mly"
                ( Int         )
# 537 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 66 "parser.mly"
                ( Bool        )
# 543 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 67 "parser.mly"
                ( Float       )
# 549 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 68 "parser.mly"
                ( String      )
# 555 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 69 "parser.mly"
                ( Void        )
# 561 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 70 "parser.mly"
                ( Game        )
# 567 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 71 "parser.mly"
                ( Player      )
# 573 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 72 "parser.mly"
                ( Sprite      )
# 579 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 73 "parser.mly"
                ( Map         )
# 585 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 74 "parser.mly"
                ( IntArray    )
# 591 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "parser.mly"
                ( BoolArray   )
# 597 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 76 "parser.mly"
                ( FloatArray  )
# 603 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 77 "parser.mly"
                ( StringArray )
# 609 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 82 "parser.mly"
                     ( [] )
# 615 "parser.ml"
               : 'vdecl_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'vdecl_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'vdecl) in
    Obj.repr(
# 83 "parser.mly"
                     ( _2 :: _1 )
# 623 "parser.ml"
               : 'vdecl_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 86 "parser.mly"
               ( (_1, _2) )
# 631 "parser.ml"
               : 'vdecl))
; (fun __caml_parser_env ->
    Obj.repr(
# 89 "parser.mly"
                   ( [] )
# 637 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 90 "parser.mly"
                   ( _2 :: _1 )
# 645 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 93 "parser.mly"
              ( Expr _1 )
# 652 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 94 "parser.mly"
                ( Return Noexpr )
# 658 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 95 "parser.mly"
                     ( Return _2 )
# 665 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 96 "parser.mly"
                            ( Block(List.rev _2) )
# 672 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 97 "parser.mly"
                                            ( If(_3, _5, _7) )
# 681 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 6 : 'expr_opt) in
    let _5 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 2 : 'expr_opt) in
    let _9 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 99 "parser.mly"
     ( For(_3, _5, _7, _9) )
# 691 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 100 "parser.mly"
                                  ( While(_3, _5) )
# 699 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 103 "parser.mly"
                  ( Noexpr )
# 705 "parser.ml"
               : 'expr_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 104 "parser.mly"
                  ( _1 )
# 712 "parser.ml"
               : 'expr_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 107 "parser.mly"
                     ( Literal(_1)          )
# 719 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : float) in
    Obj.repr(
# 108 "parser.mly"
                     ( FloatLit(_1)         )
# 726 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 109 "parser.mly"
                     ( StringLit(_1)        )
# 733 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 110 "parser.mly"
                     ( BoolLit(true)        )
# 739 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 111 "parser.mly"
                     ( BoolLit(false)       )
# 745 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 112 "parser.mly"
                     ( Id(_1)               )
# 752 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 113 "parser.mly"
                     ( Binop(_1, Add,   _3) )
# 760 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 114 "parser.mly"
                     ( Binop(_1, Sub,   _3) )
# 768 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 115 "parser.mly"
                     ( Binop(_1, Mult,  _3) )
# 776 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 116 "parser.mly"
                     ( Binop(_1, Div,   _3) )
# 784 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 117 "parser.mly"
                     ( Binop(_1, Is, _3) )
# 792 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 118 "parser.mly"
                     ( Binop(_1, Neq,   _3) )
# 800 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 119 "parser.mly"
                     ( Binop(_1, Less,  _3) )
# 808 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 120 "parser.mly"
                     ( Binop(_1, Leq,   _3) )
# 816 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 121 "parser.mly"
                     ( Binop(_1, Greater, _3) )
# 824 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 122 "parser.mly"
                     ( Binop(_1, Geq,   _3) )
# 832 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 123 "parser.mly"
                     ( Binop(_1, And,   _3) )
# 840 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 124 "parser.mly"
                     ( Binop(_1, Or,    _3) )
# 848 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 125 "parser.mly"
                     ( Unop(Not, _2) )
# 855 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 126 "parser.mly"
                     ( Assign(_1, _3) )
# 863 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'actuals_opt) in
    Obj.repr(
# 127 "parser.mly"
                                 ( Call(_1, _3) )
# 871 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 128 "parser.mly"
                       ( _2 )
# 878 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 131 "parser.mly"
                  ( [] )
# 884 "parser.ml"
               : 'actuals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'actuals_list) in
    Obj.repr(
# 132 "parser.mly"
                  ( List.rev _1 )
# 891 "parser.ml"
               : 'actuals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 135 "parser.mly"
                            ( [_1] )
# 898 "parser.ml"
               : 'actuals_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'actuals_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 136 "parser.mly"
                            ( _3 :: _1 )
# 906 "parser.ml"
               : 'actuals_list))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.program)
