type op = Add | Sub | Mult | Div | Mod | AddEqual | SubEqual | MultEqual | DivEqual | ModEqual | Neq | Less | Leq | Greater | Geq | And | Or | Is | At
(* type domain = DomainOp *)
type uop = Neg | Not
type typ = Int | Bool | Void | Float | String | IntArray | BoolArray | FloatArray | StringArray | Game | Player | Sprite | Map
type bind = typ * string


type expr = Literal of int            | BoolLit of bool
          | FloatLit of float         | StringLit of string
          | Id of string              | Noexpr
          | Binop of expr * op * expr | Unop of uop * expr
          | Assign of string * expr   | Call of string * expr list
          | ArrayElement of string * int  | ArrayElementAssign of string * int * expr
          (* | IdInClass of string * domain * string
          | CallDomain of string * expr list * domain * string *)

type array_bind = typ * string * expr

type init = typ * string * expr

type stmt = Block of stmt list        | Expr of expr
          | If of expr * stmt * stmt  
          | For of expr * expr * expr * stmt
          | While of expr * stmt      | Return of expr
          | Break                     | Continue | Init of typ * string * expr
          | Bind of bind              (* | Init of init *)
          | ArrayBind of array_bind   


type global = Bind of bind | ArrayBind of array_bind | Init of typ * string * expr

type func_decl = {
	typ      : typ;
	fname    : string;
	formals  : bind list;
	body     : stmt list;
}

type cbody = {
  vdecls : global list;
  methods : func_decl list;
}

type class_decl = {
  cname : string;
  extends : string;
  cbody : cbody;
}


type program = global list * class_decl list

(* type program = Program of bind list * func_decl list * class_decl list *)
(* type program = bind list * func_decl list *)
(* type program = Program of decl_stmt *)
(* Pretty-printing functions *)

let string_of_op = function
    Add -> "+"
  | Sub -> "-"
  | Mult -> "*"
  | Div -> "/"
  | Mod -> "%"
  | Is -> "=="
  | AddEqual -> "+="
  | SubEqual -> "-="
  | MultEqual -> "*="
  | DivEqual -> "/="
  | ModEqual -> "%="
  | Neq -> "!="
  | Less -> "<"
  | Leq -> "<="
  | Greater -> ">"
  | Geq -> ">="
  | And -> "&&"
  | Or -> "||"
  | At -> "@"

let string_of_uop = function
    Neg -> "-"
  | Not -> "!"

let rec string_of_expr = function
    Literal(l) -> string_of_int l
  | BoolLit(true) -> "true"
  | BoolLit(false) -> "false"
  | FloatLit(f) -> string_of_float f
  | StringLit(s) -> s
  | Id(s) -> s
  | Binop(e1, o, e2) ->
      string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | Unop(o, e) -> string_of_uop o ^ string_of_expr e
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Call(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | Noexpr -> ""

let string_of_typ = function
    Int -> "int"
  | Bool -> "bool"
  | Void -> "void"
  | Float -> "float"
  | String -> "string"
  | IntArray -> "Array<int>"
  | BoolArray -> "Array<bool>"
  | FloatArray -> "Array<float>"
  | StringArray -> "Array<string>"
  | Game -> "game"
  | Player -> "player"
  | Sprite -> "sprite"
  | Map -> "map"

let rec string_of_stmt = function
    Block(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr(expr) -> string_of_expr expr ^ ";\n";
  | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n";
  | If(e, s, Block([])) -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s
  | If(e, s1, s2) ->  "if (" ^ string_of_expr e ^ ")\n" ^
      string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2
  | For(e1, e2, e3, s) ->
      "for (" ^ string_of_expr e1  ^ " ; " ^ string_of_expr e2 ^ " ; " ^
      string_of_expr e3  ^ ") " ^ string_of_stmt s
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s
  | Continue -> "continue"
  | Break -> "break"
  | Bind(b) -> "bind"
  | ArrayBind(ab) -> "Arraybind"
  | Init(e, s, t) -> "init"


let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let string_of_fdecl fdecl =
  string_of_typ fdecl.typ ^ " " ^
  fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ")\n{\n" ^
(*   String.concat "" (List.map string_of_vdecl fdecl.locals) ^ *)
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_program (vars, funcs) =
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_fdecl funcs)
