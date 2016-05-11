(* Author: Yiqing Cui(yc3121) *)
{ open Parser 
let strip str =
  Scanf.sscanf str "%S" (fun s -> s)

}

let str_chars = [^ '"' '\\'] | "\\\\" | "\\\""  | "\\'"
| "\\n" | "\\r" | "\\t" | "\\b"
| "\\" [ '0'-'9' ]  [ '0'-'9' ]  [ '0'-'9' ]
let str = '"' str_chars* '"'
let comment = '#' [^'\n']
rule token = parse
[' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "/*"                 { comment lexbuf }
| '#'                   { line_comment lexbuf }
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
| "int" 	{INT}
| "float"	{FLOAT}
| "bool"	{BOOL}
| "string"	{STRING}
| "struct"  {STRUCT}
| "class"   {CLASS}
| "extends" {EXTENDS}
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
| str as lxm {STRINGCONSTANT(strip(Lexing.lexeme lexbuf))}
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) } | eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }


and comment = parse
 "*/"      { token lexbuf }
| _         { comment lexbuf }


and line_comment = parse
 ['\n' '\r']   { token lexbuf }
| _             { line_comment lexbuf }

