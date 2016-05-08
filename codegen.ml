
module A = Ast

module StringMap = Map.Make(String)

let translate (globals, classes) =

  let load_lib f = 
    let ic = open_in f in
    let n = in_channel_length ic in
    let s = String.create n in
    really_input ic s 0 n; close_in ic; (s)
  in

  let gen_game_var_code = load_lib "lib/game_vars.py" in

  let gen_game_init_code = load_lib "lib/game_init.py" in

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
    | A.Is      -> " == "
    | A.Or      -> " or "
    | A.Neq     -> " != "
    | A.Less    -> " < "
    | A.Leq     -> " <= "
    | A.Greater -> " > "
    | A.Geq     -> " >= "
    | A.Mod     -> " % "
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
    | A.Negative (op, e) -> 
      let e' = comp_global_expr e in
      comp_sym op ^ "(" ^ e' ^ ")"
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
  let comp_cbody extends cbody = 

    let init_var m vdecl = 
      StringMap.add (match vdecl with 
                      A.Bind e -> (match e with (t, n) -> n | _ -> "")
                    | A.ArrayBind e -> (match e with (t, n, a) -> n | _ -> "")
                    | A.Init (t, n, v) -> n) "self." m
    in

    let local_vars = List.fold_left init_var StringMap.empty cbody.A.vandadecls
    in

    let lookup n = try StringMap.find n local_vars
                   with Not_found -> ""
    in

    let rec comp_local_expr = function
        A.Literal i -> string_of_int i
      | A.StringLit s -> "\"" ^ s ^ "\""
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
      | A.Negative (op, e) -> 
        let e' = comp_global_expr e in
        comp_sym op ^ "(" ^ e' ^ ")"
      | A.IdInClass (e, s) -> lookup s ^ s ^ "." ^ e
      | A.ArrayInClass (e, i, s) -> lookup s ^ s ^ "." ^ e ^ "[" ^ comp_local_expr i ^ "]"
      | A.Unop(op, e) -> "not (" ^ comp_local_expr e ^ ")"
      | A.Assign (s, e) -> lookup s ^ s ^ " = " ^ comp_local_expr e
      | A.Call (f, act) -> f ^ "(" ^ String.concat ", " (List.map comp_local_expr act) ^ ")"
      | A.CallDomain (f, act, s) -> lookup s ^ s ^ "." ^ f ^ "(" ^ String.concat ", " (List.map comp_local_expr act) ^ ")"
      | _ as s -> ""
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
                     (t, n) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = None"
                    | _ -> "") ^ "\n"
      | A.ArrayBind e -> (match e with 
                     (t, n, a) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = [ None ] * " ^ comp_local_expr a
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
      | _ as s -> ""
    in

    let comp_class_var pos vdecls = 
      (String.make (pos * 4) ' ') ^ "def __init__(self):\n" ^ 
      String.concat "" (List.map (comp_local_var (pos + 1)) vdecls) ^
      (if extends = "Game" then (gen_game_var_code ^ "\n") else "") ^
      (String.make ((pos + 1) * 4) ' ')  ^ "pass" ^ "\n"
    in

    let comp_function pos fdecl = 
      (String.make (pos * 4) ' ') ^ "def " ^ fdecl.A.fname ^
      "(" ^ String.concat "," ("self" :: (List.map comp_param fdecl.A.formals)) ^  
      "):\n" ^ String.concat "" (List.map (comp_stmt (pos + 1)) fdecl.A.body) ^
      (String.make ((pos + 1) * 4) ' ') ^ "pass" ^ "\n"
    in

    comp_class_var 1 cbody.A.vandadecls ^ (if extends = "Game" then (gen_game_init_code ^ "\n") else "") ^
    String.concat "" (List.map (comp_function 1) cbody.A.methods)
  in

  let gen_main_code = ""
  in

  let comp_class cdecl = 
    (*comp_cbody (cdecl.A.cname ^ "_" ^ cdecl.A.extends ^ "_") cdecl.A.cbody*)
    "class "^ cdecl.A.cname ^ ":\n" ^ comp_cbody cdecl.A.extends cdecl.A.cbody
  in

  let find_var vname m = function
      A.Classdecl (t, s) -> if t = vname then (StringMap.add s "" m) else m
    | _ as s -> m
  in

  let find_fun vname m = function
      A.Expr e -> (match e with
                A.CallDomain (f, act, s) -> if f = vname then (StringMap.add s "" m) else m
              | _ -> m)
    | _ as s -> m
  in

  let find_in_fun fname vname m ty fdecl = 
    if ty = "var" then (
      if fdecl.A.fname = fname then
      (List.fold_left (find_var vname m) fdecl.A.body)
      else m )
    else
      (if fdecl.A.fname = fname then
      (List.fold_left (find_fun vname m) fdecl.A.body)
      else m )
  in

  let find_in_class fname cname vname m ty cdecl = 
    if cdecl.A.extends = cname then 
    (List.fold_left (find_var_in_fun fname vname m ty) cdecl.A.cbody.A.methods)
    else m
  in

  let find_class name cdecl = 
    if cdecl.A.extends = name then cdecl.A.cname else ""
  in

  let main_class = String.concat "" (List.map (find_class "Main") classes) in
  let game_class = String.concat "" (List.map (find_class "Game") classes) in
  let ai_class = String.concat "" (List.map (find_class "AI") classes) in

  let ai_vars = StringMap.bindings (if ai_class = "" then StringMap.empty 
                else List.fold_left (find_var_in_class "main" "Main" game_class "var" StringMap.empty) classes) in
  let game_vars = List.fold_left (find_var_in_class "main" "Main" game_class "var" StringMap.empty) classes in
  let init_vars = List.fold_left (find_var_in_class "main" "Main" "initialize" "fun" StringMap.empty) classes in
  let game_object_vars = StringMap.bindings (StringMap.merge (fun k xo yo -> k) game_vars init_vars) in

  let gen_game_gui_code = 
    let ai_name = 
      if (List.length ai_vars) = 1 then (match ai_vars with 
                                          (k, v) :: tl -> k
                                        | _ -> "None")
      else "None"
    in
    if (List.length game_object_vars) = 1 then
      let game_object_name = (match game_object_vars with 
                                (k, v) :: tl -> k
                              | _ -> "None")
      in
      "_root = tk.Tk()
        _root.title(\"GBL\")
        tk.Canvas.create_circle = _create_circle
        _board = GameBoard(_root, mygame)
        _board.pack(side=\"top\", fill=\"both\", expand=\"true\", padx=4, pady=4)
        _root.mainloop()"
    else ""

  let comp_main_class classes = 
    "real_main = " ^ main_class ^ "()\n" ^
    "real_main.main()\n"
  in

  String.concat "" (List.map comp_global_var globals) ^ String.concat "" (List.map comp_class classes) ^ 
  comp_main_class classes
