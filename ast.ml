type op = Add | Sub | Mult | Div | Mod | Equal | AddEqual | SubEqual | MultEqual | DivEqual | ModEqual | Neq | Less | Leq | Greater | Geq | And | Or | Is | Xor | ShiftLeft | ShiftRight | At
type uop = Neg | Not
type typ = Int | Bool | Void | Double | Char | String | IntArray | CharArray | BoolArray | DoubleArray | StringArray | Game | Player | Sprite | Map
type bind = typ * string

type expr = Literal of int            | BoolLit of bool
          | Id of string              | Noexpr
          | Binop of expr * op * expr | Unop of uop * expr
          | Assign of string * expr   | Call of string * expr

type stmt = Block of stmt list        | Expr of expr
          | If of expr * stmt         | Else of stmt
          | Elif of expr * stmt       
          | For of expr * expr * expr * stmt
          | While of expr * stmt      | Return of expr
          | Break                     | Continue

type func_decl = {
	typ      : typ;
	fname    : string;
	formals  : bind list;
	locals   : bind list;
	body     : stmt list;
}

type program = bind list * func_decl list
