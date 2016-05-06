
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
    A.Block sl -> List.fold_left stmt builder sl
  | A.Expr e -> (String.make (pos * 4) ' ') ^ comp_expr e ^ "\n"
  | A.Return e -> (String.make (pos * 4) ' ') ^ "return " ^ comp_expr e ^ "\n"
  | A.If (predicate, then_stmt, else_stmt) -> L.build_ret_void builder
  | A.For (e1, e2, e3, body) -> 
  | A.While (predicate, body) -> 

  let comp_function fdecl = 
    "def " ^ fdecl.A.fname ^ "(" ^ String.concat "," (List.map comp_param fdecl.A.formals) ^  
    ") :\n" ^ String.concat "" (List.map (comp_local_var 1) fdecl.A.locals) ^ "\n" ^
    String.concat "" (List.map (comp_stmt 1) fdecl.A.body) ^ "\n"



  (* Define each function (arguments and return type) so we can call it *)
  let function_decls =
    let function_decl m fdecl =
      let name = fdecl.A.fname
      and formal_types =
	Array.of_list (List.map (fun (t,_) -> ltype_of_typ t) fdecl.A.formals)
      in let ftype = L.function_type (ltype_of_typ fdecl.A.typ) formal_types in
      StringMap.add name (L.define_function name ftype the_module, fdecl) m in
    List.fold_left function_decl StringMap.empty functions in
  
  (* Fill in the body of the given function *)
  let build_function_body fdecl =
    let (the_function, _) = StringMap.find fdecl.A.fname function_decls in
    let builder = L.builder_at_end context (L.entry_block the_function) in

    let int_format_str = L.build_global_stringptr "%d\n" "fmt" builder in
    
    (* Construct the function's "locals": formal arguments and locally
       declared variables.  Allocate each on the stack, initialize their
       value, if appropriate, and remember their values in the "locals" map *)
    let local_vars =
      let add_formal m (t, n) p = L.set_value_name n p;
	let local = L.build_alloca (ltype_of_typ t) n builder in
	ignore (L.build_store p local builder);
	StringMap.add n local m in

      let add_local m (t, n) =
	let local_var = L.build_alloca (ltype_of_typ t) n builder
	in StringMap.add n local_var m in

      let formals = List.fold_left2 add_formal StringMap.empty fdecl.A.formals
          (Array.to_list (L.params the_function)) in
      List.fold_left add_local formals fdecl.A.locals in

    (* Return the value for a variable or formal argument *)
    let lookup n = try StringMap.find n local_vars
                   with Not_found -> StringMap.find n global_vars
    in

    (* Construct code for an expression; return its value *)
    let rec expr builder = function
	     A.Literal i -> L.const_int i32_t i
      | A.StringLit s -> L.const_stringz context s (*L.build_global_stringptr s "str" builder*)
      | A.FloatLit f -> L.const_float float_t f
      | A.BoolLit b -> L.const_int i1_t (if b then 1 else 0)
      | A.Noexpr -> L.const_int i32_t 0
      | A.Id s -> L.build_load (lookup s) s builder
      | A.Binop (e1, op, e2) ->
    	  let e1' = expr builder e1
    	  and e2' = expr builder e2 in
    	  (match op with
          A.Add     -> L.build_add
    	  | A.Sub     -> L.build_sub
    	  | A.Mult    -> L.build_mul
        | A.Div     -> L.build_sdiv
    	  | A.And     -> L.build_and
    	  | A.Is      -> L.build_icmp L.Icmp.Eq
        | A.Or      -> L.build_or
        | A.Neq     -> L.build_icmp L.Icmp.Ne
        | A.Less    -> L.build_icmp L.Icmp.Slt
        | A.Leq     -> L.build_icmp L.Icmp.Sle
        | A.Greater -> L.build_icmp L.Icmp.Sgt
        | A.Geq     -> L.build_icmp L.Icmp.Sge
    	  ) e1' e2' "tmp" builder
      | A.Unop(op, e) ->
	  let e' = expr builder e in
	  (match op with
	    A.Neg     -> L.build_neg
      | A.Not     -> L.build_not) e' "tmp" builder
      | A.Assign (s, e) -> let e' = expr builder e in
	                   ignore (L.build_store e' (lookup s) builder); e'
      | A.Call ("print", [e]) | A.Call ("printb", [e]) ->
        L.build_call put_func [| expr builder e |] "" builder
      | A.Call (f, act) ->
         let (fdef, fdecl) = StringMap.find f function_decls in
	 let actuals = List.rev (List.map (expr builder) (List.rev act)) in
	 let result = (match fdecl.A.typ with A.Void -> ""
                                            | _ -> f ^ "_result") in
         L.build_call fdef (Array.of_list actuals) result builder
    in

    (* Invoke "f builder" if the current block doesn't already
       have a terminal (e.g., a branch). *)
    let add_terminal builder f =
      match L.block_terminator (L.insertion_block builder) with
	Some _ -> ()
      | None -> ignore (f builder) in
	
    (* Build the code for the given statement; return the builder for
       the statement's successor *)
    let rec stmt builder = function
	A.Block sl -> List.fold_left stmt builder sl
      | A.Expr e -> ignore (expr builder e); builder
      | A.Return e -> ignore (match fdecl.A.typ with
	  A.Void -> L.build_ret_void builder
	| _ -> L.build_ret (expr builder e) builder); builder
      | A.If (predicate, then_stmt, else_stmt) ->
         let bool_val = expr builder predicate in
	 let merge_bb = L.append_block context "merge" the_function in

	 let then_bb = L.append_block context "then" the_function in
	 add_terminal (stmt (L.builder_at_end context then_bb) then_stmt)
	   (L.build_br merge_bb);

	 let else_bb = L.append_block context "else" the_function in
	 add_terminal (stmt (L.builder_at_end context else_bb) else_stmt)
	   (L.build_br merge_bb);

	 ignore (L.build_cond_br bool_val then_bb else_bb builder);
	 L.builder_at_end context merge_bb

      | A.While (predicate, body) ->
	  let pred_bb = L.append_block context "while" the_function in
	  ignore (L.build_br pred_bb builder);

	  let body_bb = L.append_block context "while_body" the_function in
	  add_terminal (stmt (L.builder_at_end context body_bb) body)
	    (L.build_br pred_bb);

	  let pred_builder = L.builder_at_end context pred_bb in
	  let bool_val = expr pred_builder predicate in

	  let merge_bb = L.append_block context "merge" the_function in
	  ignore (L.build_cond_br bool_val body_bb merge_bb pred_builder);
	  L.builder_at_end context merge_bb

      | A.For (e1, e2, e3, body) -> stmt builder
	    ( A.Block [A.Expr e1 ; A.While (e2, A.Block [body ; A.Expr e3]) ] )
    in

    (* Build the code for each statement in the function *)
    let builder = stmt builder (A.Block fdecl.A.body) in

    (* Add a return if the last block falls off the end *)
    add_terminal builder (match fdecl.A.typ with
        A.Void -> L.build_ret_void
      | t -> L.build_ret (L.const_int (ltype_of_typ t) 0))
  in

  List.iter build_function_body functions;
  the_module
