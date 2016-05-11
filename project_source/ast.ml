(* Author: Shengtong Zhang(sz2539) *)
type op = Add | Sub | Mult | Div | Mod | AddEqual | SubEqual | MultEqual | DivEqual | ModEqual | Neq | Less | Leq | Greater | Geq | And | Or | Is | At
type uop = Neg | Not
type typ = Int | Bool | Void | Float | String | Game | Player | Sprite | Map | Main | Ai
type bind = typ * string


type expr = Literal of int            | BoolLit of bool
          | FloatLit of float         | StringLit of string
          | Id of string              | Noexpr
          | Binop of expr * op * expr | Unop of uop * expr
          | Assign of string * expr   | Call of string * expr list
          | ArrayElement of string * expr  | ArrayElementAssign of string * expr * expr
          | IdInClass of string * string
          | ArrayInClass of string * expr * string
          | CallDomain of string * expr list * string
          | Negative of op * expr


type init = typ * string * expr
type arraybind = typ * string * expr


type stmt = Block of stmt list        | Expr of expr
          | Ifnoelse of expr * stmt
          | Ifelse of expr * stmt * stmt  
          | For of expr * expr * expr * stmt
          | While of expr * stmt      | Return of expr
          | Break                     | Continue | Init of typ * string * expr
          | Bind of bind              (* | Init of init *)
          | ArrayBind of arraybind 
          | Classdecl of string * string


type global = Bind of bind | ArrayBind of arraybind | Init of typ * string * expr

(* type formalvora = Bindinf of typ * string | ArrayBindinf of typ * string * expr *)

type func_decl = {
	typ      : typ;
	fname    : string;
	formals  : bind list;
	body     : stmt list;
}


type cbody = {
  vandadecls : global list;
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
  | Is -> "=="
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
  | Noexpr -> ""
  | Binop(e1, o, e2) ->
      string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | Unop(o, e) -> string_of_uop o ^ string_of_expr e
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Call(f, el) -> f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | ArrayElement(v, e) -> v ^ "[" ^ string_of_expr e ^ "]"
  | ArrayElementAssign(v, e1, e2) -> v ^ "[" ^ string_of_expr e1 ^ "]" ^ " = " ^ string_of_expr e2
  | IdInClass(s1, s2) -> s1 ^ "@" ^ s2
  | ArrayInClass(s1, e, s2) -> s1 ^ "[" ^ string_of_expr e ^ "]@" ^ s2
  | CallDomain(f, el, s) -> f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")@" ^ s
  | Negative(o, e) -> string_of_op o ^ string_of_expr e


let string_of_typ = function
    Int -> "int"
  | Bool -> "bool"
  | Void -> "void"
  | Float -> "float"
  | String -> "string"
  | Game -> "game"
  | Player -> "player"
  | Sprite -> "sprite"
  | Map -> "map"
  | Main -> "main"
  | Ai -> "ai"

let typ_of_string = function
    "int" -> Int
  | "bool" -> Bool
  | "void" -> Void
  | "float" -> Float
  | "string" -> String
  | "game" -> Game
  | "player" -> Player
  | "sprite" -> Sprite
  | "map" -> Map
  | "main" -> Main
  | "ai" -> Ai
(* let rec string_of_stmt = function
    Block(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr(expr) -> string_of_expr expr ^ ";\n"
  | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n"
  | Ifnoelse() -> "if ("
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
  String.concat "\n" (List.map string_of_fdecl funcs)*)
