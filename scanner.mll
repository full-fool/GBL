{ open Parser }
rule token = parse
[' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "#[^\n]*\n"	{COMMENT}
| ';'	{SEMI}
| '('	{LPAREN}
| ')'	{RPAREN}
| '['	{LBRACK}
| ']'	{RBRACK}
| '{'	{LBRACE}
| '}'	{RBRACE}
| ','	{COMMA}
| '+'	{PLUS}
| '-'	{MINUS}
| '*'	{TIMES}
| '/'	{DIVIDE}
| '%'	{MODULE}
| '='	{ASSIGN}
| '@'	{DOMAINOP}
| "+="	{PLUSEQ}
| "-="	{MINUSEQ}
| "*="	{TIMESEQ}
| "/="	{DIVIDEEQ}
| "%="	{MODULEEQ}
| "=="	{EQ}
| ">=" {GEQ}
| "<="	{LEQ}
| ">"	{GT}
| "<"	{LT}
| "!="	{NEQ}
| "and"	{AND}
| "or" 	{OR}
| "not"	{NOT}
| "true"	{TRUE}
| "false"	{FALSE}
| "array<int>"		{INTARRAY}
| "array<float>"	{FLOATARRAY}
| "array<bool>"		{BOOLARRAY}
| "array<string>"	{STRINGARRAY}
| "int" 	{INT}
| "float"	{FLOAT}
| "bool"	{BOOL}
| "string"	{STRING}
| "game"	{GAME}
| "player" 	{PLAYER}
| "sprite"	{SPRITE}
| "map"		{MAP}
| "void"	{VOID}
| "for"		{FOR}
| "if"		{IF}
| "else"	{ELSE}
| "elif"	{ELIF}
| "break"	{BREAK}
| "continue"	{CONTINUE}
| "while"	{WHILE}
| "return"	{RETURN}

| ['0'-'9']+ as lxm { LITERAL(int_of_string lxm) }
| ['0'-'9']+['.']['0'-'9']+ as lxm {FLOATCONSTANT(float_of_string lxm)}
| '"'[^'"']+'"' as lxm {STRINGCONSTANT(lxm)}
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) } | eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }
