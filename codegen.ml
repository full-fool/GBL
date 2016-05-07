
module A = Ast

module StringMap = Map.Make(String)

let translate (globals, classes) =

  (*complie function parameters*)
  let comp_param = function
      (t, n) -> n
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
  let rec comp_global_expr = function
      A.Literal i -> string_of_int i
    | A.StringLit s -> s
    | A.FloatLit f -> string_of_float f
    | A.BoolLit b -> ( match b with 
        true    -> "True"
      | false    -> "False" )
    | A.Noexpr -> ""
    | A.Id s -> s
    | A.ArrayElement (s, i) -> s ^ "[" ^ comp_global_expr i ^ "]"
    | A.ArrayElementAssign (s, i, v) -> s ^ "[" ^ comp_global_expr i ^ "]" ^ "=" ^ comp_global_expr v
    | A.Binop (e1, op, e2) ->
      let e1' = comp_global_expr e1
      and e2' = comp_global_expr e2 in
      "(" ^ e1' ^ ")" ^ comp_sym op ^ "(" ^ e2' ^ ")"
    | A.Unop(op, e) -> "not (" ^ comp_global_expr e ^ ")"
    | A.Assign (s, e) -> s ^ " = " ^ comp_global_expr e
    | A.Call (f, act) -> f ^ "(" ^ String.concat ", " (List.map comp_global_expr act) ^ ")"
  in

  (*complie global variables*)
  let comp_global_var = function
      A.Bind e -> (match e with
                   (t, n) -> n ^ " = None\n"
                  | _ -> "")
    | A.ArrayBind e -> (match e with 
                   (t, n, a) -> n ^ " = [ None ] * " ^ comp_global_expr a ^ "\n"
                  | _ -> "")
    | A.Init (t, n, v) -> n ^ " = " ^ comp_global_expr v ^ "\n"
  in

  (*complie class body*)
  let comp_cbody cbody = 

    let init_var m vdecl = 
      StringMap.add (match vdecl with 
                      A.Bind e -> (match e with (t, n) -> n | _ -> "")
                    | A.ArrayBind e -> (match e with (t, n, a) -> n | _ -> "")
                    | A.Init (t, n, v) -> n) "self." m
    in

    let local_vars = List.fold_left init_var StringMap.empty cbody.A.vdecls
    in

    let lookup n = try StringMap.find n local_vars
                   with Not_found -> ""
    in

    let rec comp_local_expr = function
        A.Literal i -> string_of_int i
      | A.StringLit s -> s
      | A.FloatLit f -> string_of_float f
      | A.BoolLit b -> ( match b with 
          true    -> "True"
        | false    -> "False" )
      | A.Noexpr -> ""
      | A.Id s -> lookup s ^ s
      | A.ArrayElement (s, i) -> lookup s ^ s ^ "[" ^ comp_local_expr i ^ "]"
      | A.ArrayElementAssign (s, i, v) -> lookup s ^ s ^ "[" ^ comp_local_expr i ^ "]" ^ "=" ^ comp_local_expr v
      | A.Binop (e1, op, e2) ->
        let e1' = comp_local_expr e1
        and e2' = comp_local_expr e2 in
        "(" ^ e1' ^ ")" ^ comp_sym op ^ "(" ^ e2' ^ ")"
      | A.Unop(op, e) -> "not (" ^ comp_local_expr e ^ ")"
      | A.Assign (s, e) -> lookup s ^ s ^ " = " ^ comp_local_expr e
      | A.Call (f, act) -> f ^ "(" ^ String.concat ", " (List.map comp_local_expr act) ^ ")"
    in

    (*complie global variables*)
    let comp_local_var pos = function
        A.Bind e -> (match e with
                     (t, n) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = None\n"
                    | _ -> "")
      | A.ArrayBind e -> (match e with 
                     (t, n, a) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = [ None ] * " ^ comp_local_expr a ^ "\n"
                    | _ -> "")
      | A.Init (t, n, v) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = " ^ comp_local_expr v ^ "\n"
    in

    (*complie statements*)
    let rec comp_stmt pos = function
        A.Block sl -> String.concat "" (List.map (comp_stmt pos) sl)
      | A.Expr e -> (String.make (pos * 4) ' ') ^ comp_local_expr e ^ "\n"
      | A.Return A.Noexpr -> (String.make (pos * 4) ' ') ^ "return\n"
      | A.Break -> (String.make (pos * 4) ' ') ^ "break\n"
      | A.Continue -> (String.make (pos * 4) ' ') ^ "continue\n"
      | A.Return e -> (String.make (pos * 4) ' ') ^ "return " ^ comp_local_expr e ^ "\n"
      | A.Bind e -> (match e with
                     (t, n) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = None\n"
                    | _ -> "") ^ "\n"
      | A.ArrayBind e -> (match e with 
                     (t, n, a) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = [ None ] * " ^ comp_local_expr a ^ "\n"
                    | _ -> "") ^ "\n"
      | A.Init (t, n, v) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = " ^ comp_local_expr v ^ "\n"
      | A.Classdecl (t, s) -> (String.make (pos * 4) ' ') ^ lookup s ^ s ^ " = " ^ t ^ "()\n"
      | A.Ifelse (predicate, then_stmt, else_stmt) -> (String.make (pos * 4) ' ') ^ "if (" ^ comp_local_expr predicate ^ "):\n" ^
                                                  comp_stmt (pos + 1) then_stmt ^ (String.make (pos * 4) ' ') ^ "else:\n" ^ 
                                                  comp_stmt (pos + 1) else_stmt
      | A.Ifnoelse (predicate, then_stmt) -> (String.make (pos * 4) ' ') ^ "if (" ^ comp_local_expr predicate ^ "):\n" ^
                                              comp_stmt (pos + 1) then_stmt
      | A.For (e1, e2, e3, body) -> (match e1 with
                                      A.Noexpr -> ""
                                    | _ -> (String.make (pos * 4) ' ') ^ comp_local_expr e1 ^ "\n") ^ 
                                    (String.make (pos * 4) ' ') ^
                                    "while (" ^ comp_local_expr e2 ^ "):\n" ^ comp_stmt (pos + 1) body ^ 
                                    (match e3 with
                                      A.Noexpr -> ""
                                    | _ -> (String.make ((pos + 1) * 4) ' ') ^ comp_local_expr e3 ^ "\n")
      | A.While (predicate, body) -> (String.make (pos * 4) ' ') ^ "while (" ^ comp_local_expr predicate ^ "):\n" ^
                                     comp_stmt (pos + 1) body
    in

    let comp_class_var pos vdecls = 
      (String.make (pos * 4) ' ') ^ "def __init__(self):\n" ^ 
      String.concat "" (List.map (comp_local_var (pos + 1)) vdecls) ^ "\n" ^
      (String.make (pos * 4) ' ') ^ "pass" ^ "\n"
    in

    let comp_function pos fdecl = 
      (String.make (pos * 4) ' ') ^ "def " ^ fdecl.A.fname ^
      "(" ^ String.concat "," ("self" :: (List.map comp_param fdecl.A.formals)) ^  
      "):\n" ^ String.concat "" (List.map (comp_stmt (pos + 1)) fdecl.A.body) ^ "\n" ^
      (String.make (pos * 4) ' ') ^ "pass" ^ "\n"
    in

    comp_class_var 1 cbody.A.vdecls ^ 
    String.concat "" (List.map (comp_function 1) cbody.A.methods)
  in

  let comp_class cdecl = 
    (*comp_cbody (cdecl.A.cname ^ "_" ^ cdecl.A.extends ^ "_") cdecl.A.cbody*)
    "class "^ cdecl.A.cname ^ ":\n" ^ comp_cbody cdecl.A.cbody
  in

  let find_main_class cdecl = 
    if cdecl.A.extends == "Main" then cdecl.A.cname else ""
  in

  let comp_main_class classes = 
    "real_main = " ^ String.concat "" (List.map find_main_class classes) ^ "()\n" ^
    "real_main.main()\n"
  in

  String.concat "" (List.map comp_global_var globals) ^ String.concat "" (List.map comp_class classes) ^ 
  comp_main_class classes
