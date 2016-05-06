
module A = Ast

module StringMap = Map.Make(String)

let translate (globals, classes) =

  (*complie function parameters*)
  let comp_param = function
      (t, n) -> n
    | _ -> ""
  in

  (*complie local variables*)
  let comp_local_decl pos = function
      (t, n) -> (String.make (pos * 4) ' ') ^ n ^ " = None\n"
    | _ -> (String.make (pos * 4) ' ') ^ ""
  in

  let rec list_gen item = function
     0 -> []
    |n -> item :: list_gen item (n - 1)
  in

  (*complie local variables*)
  let comp_local_array pos = function
      (t, n, a) -> (String.make (pos * 4) ' ') ^ n ^ " = [" ^ 
        (match a with
         0 -> ""
        |_ -> String.concat ", " (list_gen "None" a)
        ) ^ "]\n"
    | _ -> (String.make (pos * 4) ' ') ^ ""
  in

  let comp_global_decl header = function
      (t, n) -> header ^ n ^ " = None\n"
    | _ -> ""
  in

  (*complie local variables*)
  let comp_global_array header = function
      (t, n, a) -> header ^ n ^ " = [" ^ 
        (match a with
         0 -> ""
        |_ -> String.concat ", " (list_gen "None" a)
        ) ^ "]\n"
    | _ -> ""
  in

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
  in

  (*complie expressions*)
  let rec comp_expr = function
      A.Literal i -> string_of_int i
    | A.StringLit s -> s
    | A.FloatLit f -> string_of_float f
    | A.BoolLit b -> ( match b with 
        true    -> "True"
      | false    -> "False" )
    | A.Noexpr -> ""
    | A.Id s -> s
    | A.Binop (e1, op, e2) ->
      let e1' = comp_expr e1
      and e2' = comp_expr e2 in
      "(" ^ e1' ^ ")" ^ comp_sym op ^ "(" ^ e2' ^ ")"
    | A.Unop(op, e) -> "not (" ^ comp_expr e ^ ")"
    | A.Assign (s, e) -> s ^ " = " ^ comp_expr e
    | A.Call (f, act) -> f ^ "(" ^ String.concat ", " (List.map comp_expr act) ^ ")"
  in


  let comp_local_assign pos = function
      (t, n, v) -> (String.make (pos * 4) ' ') ^ n ^ " = " ^ comp_expr v ^ "\n"
    | _ -> (String.make (pos * 4) ' ') ^ ""
  in

  let comp_global_assign header = function
      (t, n, v) -> header ^ n ^ " = " ^ comp_expr v ^ "\n"
    | _ -> ""
  in

  (*complie global variables*)
  let comp_global_var header = function
      A.Bind e -> comp_global_decl header e
    | A.ArrayBind e -> comp_global_array header e
    | A.Init (t, n, v) -> comp_global_assign header (t, n, v)
  in

  (*complie statements*)
  let rec comp_stmt pos = function
      A.Block sl -> ""
    | A.Expr e -> (String.make (pos * 4) ' ') ^ comp_expr e ^ "\n"
    | A.Return e -> (String.make (pos * 4) ' ') ^ "return " ^ comp_expr e ^ "\n"
    | A.Bind e -> comp_local_decl pos e
    | A.ArrayBind e -> comp_local_array pos e
    | A.Init (t, n, v) -> comp_local_assign pos (t, n, v)
    | A.If (predicate, then_stmt, else_stmt) -> ""
    | A.For (e1, e2, e3, body) -> ""
    | A.While (predicate, body) -> ""
  in

  let comp_function header fdecl = 
    "def " ^ header ^ fdecl.A.fname ^ "(" ^ String.concat "," (List.map comp_param fdecl.A.formals) ^  
    ") :\n" ^ String.concat "" (List.map (comp_stmt 1) fdecl.A.body) ^ "\n"
  in

  let comp_cbody header cbody = 
    String.concat "" (List.map (comp_global_var header) cbody.A.vdecls) ^ 
    String.concat "" (List.map (comp_global_var header) cbody.A.array_decls) ^
    String.concat "" (List.map (comp_function header) cbody.A.methods)
  in

  let comp_class cdecl = 
    comp_cbody cdecl.A.cname ^ "_" ^ cdecl.A.extends ^ "_" cdecl.A.cbody
  in

  String.concat "" (List.map (comp_global_var "") globals) ^ String.concat "" (List.map comp_class classes) ^ "main()" 
