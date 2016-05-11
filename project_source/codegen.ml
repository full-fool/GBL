(* Author: Ye Cao(yc3113) *)
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

  let gen_game_gui_code = load_lib "lib/game_gui.py" in

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

  let find_in_fun fname vname ty m fdecl = 
    if ty = "var" then (
      if fdecl.A.fname = fname then
      (List.fold_left (find_var vname) m fdecl.A.body)
      else m )
    else
      (if fdecl.A.fname = fname then
      (List.fold_left (find_fun vname) m fdecl.A.body)
      else m )
  in

  let find_in_class fname cname vname ty m cdecl = 
    if cdecl.A.extends = cname then 
    (List.fold_left (find_in_fun fname vname ty) m cdecl.A.cbody.A.methods)
    else m
  in

  let find_class name cdecl = 
    if cdecl.A.extends = name then cdecl.A.cname else ""
  in

  let main_class = String.concat "" (List.map (find_class "Main") classes) in
  let game_class = String.concat "" (List.map (find_class "Game") classes) in
  let ai_class = String.concat "" (List.map (find_class "AI") classes) in

  let ai_vars = StringMap.bindings (if ai_class = "" then StringMap.empty 
                else List.fold_left (find_in_class "main" "Main" ai_class "var") StringMap.empty classes) in
  let game_vars = List.fold_left (find_in_class "main" "Main" game_class "var") StringMap.empty classes in
  let init_vars = List.fold_left (find_in_class "main" "Main" "initialize" "fun") StringMap.empty classes in
  let game_object_vars = StringMap.bindings (StringMap.merge (fun k xo yo -> match xo, yo with
                                                                              Some x, Some y -> xo
                                                                            | _ -> None) game_vars init_vars)
  in

  let game_gui_code = 
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

      "
        _root = tk.Tk()
        _root.title(\"GBL\")
        tk.Canvas.create_circle = _create_circle
        _board = GameBoard(_root, " ^ game_object_name ^" , " ^ ai_name ^ ")
        _board.pack(side=\"top\", fill=\"both\", expand=\"true\", padx=4, pady=4)
        _root.mainloop()\n"
    else ""
  in

  let gen_main_class_code = 
    "if __name__ == \"__main__\":\n" ^ 
    "    _main = " ^ main_class ^ "()\n" ^
    "    _main.main()\n"
  in

  let map_to_list m  = function _ as s-> StringMap.add s "self." m in

  let game_var_map = 
    List.fold_left map_to_list StringMap.empty 
    ["WithAI";"NextSpriteID";"NextPlayerID";"FormerPosition";"FormerId";"SpriteOwnerId";
    "SpriteId";"PlayerName";"PlayerId";"PlayerNumber";"GridNum";"MapSize";"InputPosition"]
  in

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

    let init_fun m fdecl = 
      StringMap.add fdecl.A.fname "self." m
    in

    let local_vars = List.fold_left init_var StringMap.empty cbody.A.vandadecls in
    let local_funs = List.fold_left init_fun StringMap.empty cbody.A.methods in

    let lookup_fun f = try StringMap.find f local_funs
                    with Not_found -> ""
    in

    let rec comp_local_expr lookup = function
        A.Literal i -> string_of_int i
      | A.StringLit s -> "\"" ^ s ^ "\""
      | A.FloatLit f -> string_of_float f
      | A.BoolLit b -> ( match b with 
          true    -> "True"
        | false    -> "False" )
      | A.Noexpr -> ""
      | A.Id s -> lookup s ^ s
      | A.ArrayElement (s, i) -> lookup s ^ s ^ "[" ^ comp_local_expr lookup i ^ "]"
      | A.ArrayElementAssign (s, i, v) -> lookup s ^ s ^ "[" ^ comp_local_expr lookup i ^ "]" ^ "=" ^ comp_local_expr lookup v
      | A.Binop (e1, op, e2) ->
        let e1' = comp_local_expr lookup e1
        and e2' = comp_local_expr lookup e2 in
        "(" ^ e1' ^ ")" ^ comp_sym op ^ "(" ^ e2' ^ ")"
      | A.Negative (op, e) -> 
        let e' = comp_global_expr e in
        comp_sym op ^ "(" ^ e' ^ ")"
      | A.IdInClass (e, s) -> lookup s ^ s ^ "." ^ e
      | A.ArrayInClass (e, i, s) -> lookup s ^ s ^ "." ^ e ^ "[" ^ comp_local_expr lookup i ^ "]"
      | A.Unop(op, e) -> "not (" ^ comp_local_expr lookup e ^ ")"
      | A.Assign (s, e) -> lookup s ^ s ^ " = " ^ comp_local_expr lookup e
      | A.Call ("printi", [e]) | A.Call ("printb", [e]) | A.Call ("printf", [e]) | A.Call ("prints", [e]) -> 
        "sys.stdout.write " ^ "(str(" ^ comp_local_expr lookup e ^ "))"
      | A.Call ("printlni", [e]) | A.Call ("printlnb", [e]) | A.Call ("printlnf", [e]) | A.Call ("printlns", [e]) -> 
        "print " ^ "(" ^ comp_local_expr lookup e ^ ")"
      | A.Call (f, act) -> lookup_fun f ^ f ^ "(" ^ String.concat ", " (List.map (
    comp_local_expr lookup) act) ^ ")"
      | A.CallDomain (f, act, s) -> lookup s ^ s ^ "." ^ f ^ "(" ^ String.concat ", " (List.map (comp_local_expr lookup) act) ^ ")"
      | _ as s -> ""
    in

    (*complie global variables*)
    let comp_local_var pos lookup = function
        A.Bind e -> (match e with
                     (t, n) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = None\n"
                    | _ -> "")
      | A.ArrayBind e -> (match e with 
                     (t, n, a) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = [ None ] * " ^ comp_local_expr lookup a ^ "\n"
                    | _ -> "")
      | A.Init (t, n, v) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = " ^ comp_local_expr lookup v ^ "\n"
    in

    (*complie statements*)
    let rec comp_stmt pos lookup = function
        A.Block sl -> String.concat "" (List.map (comp_stmt pos lookup) sl)
      | A.Expr e -> (String.make (pos * 4) ' ') ^ comp_local_expr lookup e ^ "\n"
      | A.Return A.Noexpr -> (String.make (pos * 4) ' ') ^ "return\n"
      | A.Break -> (String.make (pos * 4) ' ') ^ "break\n"
      | A.Continue -> (String.make (pos * 4) ' ') ^ "continue\n"
      | A.Return e -> (String.make (pos * 4) ' ') ^ "return " ^ comp_local_expr lookup e ^ "\n"
      | A.Bind e -> (match e with
                     (t, n) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = None"
                    | _ -> "") ^ "\n"
      | A.ArrayBind e -> (match e with 
                     (t, n, a) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = [ None ] * " ^ comp_local_expr lookup a
                    | _ -> "") ^ "\n"
      | A.Init (t, n, v) -> (String.make (pos * 4) ' ') ^ lookup n ^ n ^ " = " ^ comp_local_expr lookup v ^ "\n"
      | A.Classdecl (t, s) -> (String.make (pos * 4) ' ') ^ lookup s ^ s ^ " = " ^ t ^ "()\n"
      | A.Ifelse (predicate, then_stmt, else_stmt) -> (String.make (pos * 4) ' ') ^ "if (" ^ comp_local_expr lookup predicate ^ "):\n" ^
                                                  comp_stmt (pos + 1) lookup then_stmt ^ (String.make (pos * 4) ' ') ^ "else:\n" ^ 
                                                  comp_stmt (pos + 1) lookup else_stmt
      | A.Ifnoelse (predicate, then_stmt) -> (String.make (pos * 4) ' ') ^ "if (" ^ comp_local_expr lookup predicate ^ "):\n" ^
                                              comp_stmt (pos + 1) lookup then_stmt
      | A.For (e1, e2, e3, body) -> (match e1 with
                                      A.Noexpr -> ""
                                    | _ -> (String.make (pos * 4) ' ') ^ comp_local_expr lookup e1 ^ "\n") ^ 
                                    (String.make (pos * 4) ' ') ^
                                    "while (" ^ comp_local_expr lookup e2 ^ "):\n" ^ comp_stmt (pos + 1) lookup body ^ 
                                    (match e3 with
                                      A.Noexpr -> ""
                                    | _ -> (String.make ((pos + 1) * 4) ' ') ^ comp_local_expr lookup e3 ^ "\n")
      | A.While (predicate, body) -> (String.make (pos * 4) ' ') ^ "while (" ^ comp_local_expr lookup predicate ^ "):\n" ^
                                     comp_stmt (pos + 1) lookup body
      | _ as s -> ""
    in

    let comp_class_var pos vdecls = 
      (String.make (pos * 4) ' ') ^ "def __init__(self):\n" ^ 
      String.concat "" (List.map (comp_local_var (pos + 1) 
        (fun n -> try StringMap.find n local_vars
          with Not_found -> "")) vdecls) ^
      (if extends = "Game" then (gen_game_var_code ^ "\n") else "") ^
      (String.make ((pos + 1) * 4) ' ')  ^ "pass" ^ "\n\n"
    in

    let comp_function pos fdecl = 
      (String.make (pos * 4) ' ') ^ "def " ^ fdecl.A.fname ^ "(" ^
      String.concat "," ("self" :: (
        if extends = "Game" && (fdecl.A.fname = "win" || fdecl.A.fname = "isLegal" || fdecl.A.fname = "update")
        then []
        else List.map comp_param fdecl.A.formals)) ^  
          "):\n" ^ String.concat "" (List.map (comp_stmt (pos + 1) 
            (if extends = "Game" && (fdecl.A.fname = "win" || fdecl.A.fname = "isLegal" || fdecl.A.fname = "update")
            then
            (fun n -> try StringMap.find n local_vars
                    with Not_found -> try StringMap.find n game_var_map 
                                         with Not_found -> "")
            else
            (fun n -> try StringMap.find n local_vars
                    with Not_found -> ""))
          ) fdecl.A.body) ^
      (if extends = "Main" && fdecl.A.fname = "main" then game_gui_code else "") ^ 
      (String.make ((pos + 1) * 4) ' ') ^ "pass" ^ "\n\n"
    in

    comp_class_var 1 cbody.A.vandadecls ^ (if extends = "Game" then (gen_game_init_code ^ "\n") else "") ^
    String.concat "" (List.map (comp_function 1) cbody.A.methods)
  in

  let comp_class cdecl = 
    (*comp_cbody (cdecl.A.cname ^ "_" ^ cdecl.A.extends ^ "_") cdecl.A.cbody*)
    "class "^ cdecl.A.cname ^ ":\n" ^ comp_cbody cdecl.A.extends cdecl.A.cbody ^ "\n"
  in

  "import sys\n" ^ String.concat "" (List.map comp_global_var globals) ^ 
  (if (String.length game_gui_code) > 0 then gen_game_gui_code else "") ^ 
  String.concat "" (List.map comp_class classes) ^ 
  gen_main_class_code ^ "\n"
