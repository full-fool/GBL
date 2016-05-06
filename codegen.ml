
module A = Ast

module StringMap = Map.Make(String)

let translate (globals, functions) =

  (*complie global variables*)
  let comp_global_var = function
    (t, n) -> n ^ " = None\n"
  | _ -> ""

  (*complie function parameters*)
  let comp_param = function
    (t, n) -> n
  | _ -> ""

  (*complie local variables*)
  let comp_local_var pos = function
    (t, n) -> (String.make (pos * 4) ' ') ^ n ^ " = None\n"
  | _ -> (String.make (pos * 4) ' ') ^ ""

  (*complie local variables*)
  let comp_local_array pos = function
    (t, n) -> (String.make (pos * 4) ' ') ^ n ^ " = []\n"
  | _ -> (String.make (pos * 4) ' ') ^ ""

  let comp_var_assign pos = function
    (t, n, v) -> (String.make (pos * 4) ' ') ^ n ^ " = " ^ v ^ "\n"
  | _ -> (String.make (pos * 4) ' ') ^ ""

  (*complie symbols*)
  let comp_sym = function
    A.Add     -> " + "
  | A.Sub     -> " - "
  | A.Mult    -> " * "
  | A.Div     -> " / "
  | A.And     -> " and "
  | A.Is      -> " is "
  | A.Or      -> " or "
  | A.Neq     -> " != "
  | A.Less    -> " < "
  | A.Leq     -> " <= "
  | A.Greater -> " > "
  | A.Geq     -> " >= "
  | _         -> " "

  (*complie expressions*)
  let rec comp_expr = function
    A.Literal i -> i
  | A.StringLit s -> s
  | A.FloatLit f -> f
  | A.BoolLit b -> match b with 
      "true"    -> "True"
    | "false"    -> "False"
  | A.Noexpr -> ""
  | A.Id s -> s
  | A.Binop (e1, op, e2) ->
    let e1' = comp_expr e1
    and e2' = comp_expr e2 in
    "(" ^ e1' ^ ")" ^ comp_sym op ^ "(" ^ e2' ^ ")"
  | A.Unop(op, e) -> "not (" ^ comp_expr e ^ ")"
  | A.Assign (s, e) -> s ^ " = " ^ comp_expr e
  | A.Call (f, act) -> let (fdef, fdecl) = StringMap.find f function_decls

  (*complie statements*)
  let rec comp_stmt pos = function
    A.Block sl -> ""
  | A.Expr e -> (String.make (pos * 4) ' ') ^ comp_expr e ^ "\n"
  | A.Return e -> (String.make (pos * 4) ' ') ^ "return " ^ comp_expr e ^ "\n"
  | A.Bind e -> comp_local_var pos e
  | A.ArrayBind e -> comp_local_array pos e
  | A.Init e -> comp_var_assign pos e
  | A.If (predicate, then_stmt, else_stmt) -> ""
  | A.For (e1, e2, e3, body) -> ""
  | A.While (predicate, body) -> ""

  let comp_function fdecl = 
    "def " ^ fdecl.A.fname ^ "(" ^ String.concat "," (List.map comp_param fdecl.A.formals) ^  
    ") :\n" ^ String.concat "" (List.map (comp_local_var 1) fdecl.A.locals) ^ "\n" ^
    String.concat "" (List.map (comp_stmt 1) fdecl.A.body) ^ "\n"

  in String.concat "" (List.map comp_global_var globals) ^ String.concat "" (List.map comp_function functions) ^ "main()" 