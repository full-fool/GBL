{ open Parser }
rule token = parse
[' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "#[^\n]*\n"	{COMMENT}
| '('	{LPAREN}
| ')'	{RPAREN}
| '['	{LBRACK}
| ']'	{RBRACK}
| '{'	{LBRACE}
| '}'	{RBRACE}
| '<'	{LANGLE}
| '>' 	{RANGLE}
| ','	{COMMA}
| '+'	{PLUS}
| '-'	{MINUS}
| '*'	{TIMES}
| '/'	{DIVIDE}
| '%'	{MODULE}
| '='	{ASSIGN}
| '&'	{BITAND}
| '|'	{BITOR}
| '^'	{BITXOR}
| '~'	{BITNEG}
| '@'	{DOMAINOP}
| '\\'	{NEWLINE}
| ">>"	{RIGHTSHIFT}
| "<<"	{LEFTSHIFT}
| "+="	{PLUSEQ}
| "-="	{MINUSEQ}
| "*="	{TIMESEQ}
| "/="	{DIVIDEEQ}
| "%="	{MODULEEQ}
| "is"	{EQ}
| "geq" {GEQ}
| "leq"	{LEQ}
| "gt"	{GT}
| "lt"	{LT}
| "neq"	{NEQ}
| "and"	{AND}
| "or" 	{OR}
| "not"	{NOT}
| "int" {INT}
| "true"	{TRUE}
| "false"	{FALSE}
| "float"	{FLOAT}
| "bool"	{BOOL}
| "string"	{STRING}
| "list"	{LIST}
| "dict"	{DICT}
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
| ['0'-'9']+['.']['0'-'9']+ as lxm {LITERAL(float_of_string lxm)}
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) } | eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }
