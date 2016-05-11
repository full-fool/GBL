(* Author: Sihao Zhang(sz2558), Yiqing Cui(yc3121) *)
(* Semantic checking for the GBL compiler *)

open Ast

module StringMap = Map.Make(String)

(* Semantic checking of a program. Returns void if successful,
   throws an exception if something is wrong.

   Check each global variable, then check each function *)
let check (vandadecls, revcdecls) =
  let cdecls = List.rev revcdecls in
  (*let print_cdecl cdecl =
    print_string (cdecl.cname ^ "@" ^ cdecl.extends)
  in
  List.iter print_cdecl cdecls;*)
  (* Raise an exception if the given list has a duplicate *)
  let built_in_decls =
  List.fold_left (fun map (key, value) ->
    StringMap.add key value map
  ) StringMap.empty [("printi", { typ = Void; fname = "printi"; formals = [(Int, "x")];
  body = [] }); ("printb", { typ = Void; fname = "printb"; formals = [(Bool, "x")];
   body = [] }); ("printlni", { typ = Void; fname = "printlni"; formals = [(Int, "x")];
    body = [] }); ("printlnb", { typ = Void; fname = "printlnb"; formals = [(Bool, "x")];
    body = [] }); ("printf", { typ = Void; fname = "printf"; formals = [(Float, "x")];
     body = [] }); ("prints", { typ = Void; fname = "prints"; formals = [(String, "x")];
    body = [] }); ("printlnf", { typ = Void; fname = "printlnf"; formals = [(Float, "x")];
    body = [] }); ("printlns", { typ = Void; fname = "printlns"; formals = [(String, "x")];
      body = [] }); ("Game@initialize", { typ = Void; fname = "initialize"; formals = [(Int, "x");(Int, "x");(Int, "x");(String, "x");(Bool, "x")];
      body = [] })]
  
  in

  let add_function_of_class crr_func_list cdecl = 
      let class_name = cdecl.extends in
      let tmpAddFunction m fd = StringMap.add (class_name ^ "@" ^ fd.fname) fd m in
        List.fold_left tmpAddFunction crr_func_list cdecl.cbody.methods
  in

  let function_decls = List.fold_left add_function_of_class
                         built_in_decls cdecls 
  in

  let print_funcdecl key value =
      print_string ((string_of_typ value.typ) ^ " " ^ key ^ "\n")
  in
  
  let mapChildtoParentClass classmap cdecl =
      StringMap.add cdecl.cname cdecl.extends classmap
  in

  let class_decls = 
      List.fold_left mapChildtoParentClass StringMap.empty cdecls
  in

  let class_decl child = try StringMap.find child class_decls
        with Not_found -> raise (Failure ("unrecognized class " ^ child))
  in

  (*StringMap.iter print_funcdecl function_decls;*)
  let function_decl scope s = try StringMap.find s function_decls
       with Not_found -> try StringMap.find (scope ^ "@" ^ s) function_decls
         with Not_found -> raise (Failure ("unrecognized function " ^ s))
  in

  let report_duplicate exceptf list =
    let rec helper = function
        n1 :: n2 :: _ when n1 = n2 -> raise (Failure (exceptf n1))
      | _ :: t -> helper t
      | [] -> ()
    in helper (List.sort compare list)
  in
  
  (* Raise an exception if a given binding is to a void type *)
  let check_not_void exceptf = function
    (Void, n) -> raise (Failure (exceptf n))
    | _ -> ()
  in
  
  let print_symbolList key value =
    print_string(key ^ " " ^ (string_of_typ value) ^ "\n")
  in
  (* Raise an exception of the given rvalue type cannot be assigned to
     the given lvalue type *)
  let check_assign lvaluet rvaluet err =
    if lvaluet == rvaluet then lvaluet else raise err
  in
  
  let check_exist s symbol_list =
    if  StringMap.mem s symbol_list then raise (Failure ("identifier " ^ s ^ " exists"))
    else ()

  in

  let check_valid_extend s = 
     try List.mem s ["Game";"AI";"Main"]
       with Not_found -> raise(Failure ("invalid base class " ^ s))
  in

  let type_of_identifier s symbol_list =
    try StringMap.find s symbol_list
      with Not_found -> raise (Failure ("undeclared identifier " ^ s))
  in 

  let type_of_object s object_list =
    try StringMap.find s object_list
      with Not_found -> raise (Failure ("undeclared object " ^ s))
  in 
  
  let print_object key value =
    print_string(key ^ " " ^ value ^ "\n")
  in

  let rec check_expr (expr_symbol_list, className)  = function
    Literal _ -> Int
  | BoolLit _ -> Bool
  | FloatLit _ -> Float
  | StringLit _ -> String
  | Id s -> type_of_identifier (className ^ "@" ^ s) expr_symbol_list

  | Binop(e1, op, e2) as e -> let t1 = check_expr (expr_symbol_list, className) e1 
                                and t2 = check_expr (expr_symbol_list, className) e2 in
  (match op with
        Add | Sub | Mult | Div | AddEqual | SubEqual | MultEqual | DivEqual when t1 = Int && t2 = Int -> Int
        | Add | Sub | Mult | Div | AddEqual | SubEqual | MultEqual | DivEqual when t1 = Float && t2 = Int -> Float
        | Add | Sub | Mult | Div | AddEqual | SubEqual | MultEqual | DivEqual when t1 = Int && t2 = Float -> Float
        | Add | Sub | Mult | Div | AddEqual | SubEqual | MultEqual | DivEqual when t1 = Float && t2 = Float -> Float
        | Mod | ModEqual when t1 = Int && t2 = Int -> Int
        | Is | Neq when t1 = t2 -> Bool
        | Less | Leq | Greater | Geq when t1 = Int && t2 = Int -> Bool
        | Less | Leq | Greater | Geq when t1 = Int && t2 = Float -> Bool
        | Less | Leq | Greater | Geq when t1 = Float && t2 = Int -> Bool
        | Less | Leq | Greater | Geq when t1 = Float && t2 = Float -> Bool
        | And | Or when t1 = Bool && t2 = Bool -> Bool
        | _ -> raise (Failure ("illegal binary operator " ^
              string_of_typ t1 ^ " " ^ string_of_op op ^ " " ^
              string_of_typ t2 ^ " in " ^ string_of_expr e)))

  | Unop(op, e) as ex -> let t = check_expr (expr_symbol_list, className) e in
  (match op with
        Neg when t = Int -> Int
      | Neg when t = Float -> Float
      | Not when t = Bool -> Bool
      | _ -> raise (Failure ("illegal unary operator " ^ string_of_uop op ^
                 string_of_typ t ^ " in " ^ string_of_expr ex)))
  | ArrayElement(var, e) -> 
                    let lt = type_of_identifier (className ^ "@" ^ var) expr_symbol_list 
                      and rt = check_expr (expr_symbol_list, className) e in
                    (match rt with
                     Int -> lt
                   | _ -> raise (Failure("array subscript is not integer in " ^ var)))
  | _ ->  raise (Failure("Declaration not valid"))

    in

    let check_vandadecl (symbollist, classname) = function
      Bind(b) ->  (*print_string ((string_of_typ (fst b)) ^ " " ^ (snd b) ^ "\n");*)
                  check_not_void (fun n -> "illegal void " ^ n) b;
                  check_exist (classname ^ "@" ^ (snd b)) symbollist;
                  let typstring = (fst b) and idstring = (classname ^ "@" ^ (snd b)) in
                  let new_symbol_list = StringMap.add idstring typstring symbollist in
                  (*ignore(StringMap.iter print_symbolList new_symbol_list);*)
                      (new_symbol_list, classname)

    | Init(t, s, e) -> let rt = check_expr (symbollist, classname) e in
                                               check_assign t rt (Failure ("illegal init " ^ string_of_typ t ^
                                               " = " ^ string_of_typ rt ^ " in declaration " ^ (string_of_typ t)
                                               ^ " " ^ s ^ " = " ^ 
                                               string_of_expr e));
                       ignore(check_not_void (fun n -> "illegal void " ^ n) (t, s));
                       ignore(check_exist (classname ^ "@" ^ s) symbollist);
                       ignore(check_expr (symbollist, classname) e);
                       let new_symbol_list = StringMap.add (classname ^ "@" ^ s) t symbollist in (new_symbol_list, classname)

    | ArrayBind((t, s, e)) ->  ignore(check_not_void (fun n -> "illegal void" ^ n) (t, s));
                               ignore(check_exist (classname ^ "@" ^ s) symbollist);
                               let ty = check_expr (symbollist, classname) e 
                                 in let _ =
                                    (match ty with Int -> () 
                                                | _ -> raise (Failure("array subscript is not integer in " ^ s))) 
                                    in 
                                    let new_symbol_list = StringMap.add (classname ^ "@" ^ s) t symbollist in (new_symbol_list, classname)
    
    in

    let (symbols, _) = List.fold_left check_vandadecl (StringMap.empty, "Global") vandadecls
    in

    let check_cdecl symbol_list cdecl = 
      let _ = check_valid_extend cdecl.extends in
        let check_class (classSymbolList, className, globals, functions) =
          
          let (symbol_table, _) = List.fold_left check_vandadecl (classSymbolList, className) globals in
    
            (**** Checking Functions ****)
            report_duplicate (fun n -> "duplicate function " ^ n) (List.map (fun fd -> fd.fname) functions);
            (* Function declaration for a named function *)
  
            ignore(function_decl "Main" "main"); (* Ensure "main" is defined *)
            let symbol_table_temp = symbol_table in
            let check_function func =

              List.iter (check_not_void (fun n -> "illegal void formal " ^ n ^ " in " ^ func.fname)) func.formals;

              report_duplicate (fun n -> "duplicate formal " ^ n ^ " in " ^ func.fname)
              (List.map snd func.formals);
              
              let addToMap stringmap (key, value) =
                StringMap.add (className ^ "@" ^ value) key stringmap
              in

              let formal_symbol_list = List.fold_left addToMap symbol_table_temp func.formals in

              (* Type of each variable (global, formal, or local *)
              let rec expr (expr_symbol_list, expr_object_list)  = function
                  Literal _ -> Int
                | BoolLit _ -> Bool
                | FloatLit _ -> Float
                | StringLit _ -> String
                | Id s -> type_of_identifier (className ^ "@" ^ s) expr_symbol_list
                | Binop(e1, op, e2) as e -> let t1 = expr (expr_symbol_list, expr_object_list) e1 
                                              and t2 = expr (expr_symbol_list, expr_object_list) e2 in
                  (match op with
                      Add | Sub | Mult | Div | AddEqual | SubEqual | MultEqual | DivEqual when t1 = Int && t2 = Int -> Int
                    | Add | Sub | Mult | Div | AddEqual | SubEqual | MultEqual | DivEqual when t1 = Float && t2 = Int -> Float
                    | Add | Sub | Mult | Div | AddEqual | SubEqual | MultEqual | DivEqual when t1 = Int && t2 = Float -> Float
                    | Add | Sub | Mult | Div | AddEqual | SubEqual | MultEqual | DivEqual when t1 = Float && t2 = Float -> Float
                    | Mod | ModEqual when t1 = Int && t2 = Int -> Int
                    | Is | Neq when t1 = t2 -> Bool
                    | Less | Leq | Greater | Geq when t1 = Int && t2 = Int -> Bool
                    | Less | Leq | Greater | Geq when t1 = Int && t2 = Float -> Bool
                    | Less | Leq | Greater | Geq when t1 = Float && t2 = Int -> Bool
                    | Less | Leq | Greater | Geq when t1 = Float && t2 = Float -> Bool
                    | And | Or when t1 = Bool && t2 = Bool -> Bool
                    | _ -> raise (Failure ("illegal binary operator " ^
                           string_of_typ t1 ^ " " ^ string_of_op op ^ " " ^
                           string_of_typ t2 ^ " in " ^ string_of_expr e)))

                | Unop(op, e) as ex -> let t = expr (expr_symbol_list, expr_object_list) e in
                  (match op with
                      Neg when t = Int -> Int
                    | Neg when t = Float -> Float
                    | Not when t = Bool -> Bool
                    | _ -> raise (Failure ("illegal unary operator " ^ string_of_uop op ^
                           string_of_typ t ^ " in " ^ string_of_expr ex)))

                | Noexpr -> Void

                | Assign(var, e) as ex ->  let lt = type_of_identifier (className ^ "@" ^ var) expr_symbol_list
                                               and rt = expr (expr_symbol_list, expr_object_list) e in
                                               check_assign lt rt (Failure ("illegal assignment " ^ string_of_typ lt ^
                                               " = " ^ string_of_typ rt ^ " in " ^ 
                                               string_of_expr ex))

                | Call(fname, actuals) as call -> (*print_string (className ^ "@" ^ fname); *)
                                                let fd = function_decl className fname in
                  if List.length actuals != List.length fd.formals then
                    raise (Failure ("expecting " ^ string_of_int
                    (List.length fd.formals) ^ " arguments in " ^ string_of_expr call))
                  else
                    List.iter2 (fun (ft, _) e -> let et = expr (expr_symbol_list, expr_object_list) e in
                    ignore (check_assign ft et
                            (Failure ("illegal actual argument found " ^ string_of_typ et ^
                                      " expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e))))
                    fd.formals actuals;
                    fd.typ

                | ArrayElement(var, e) -> let lt = type_of_identifier (className ^ "@" ^ var) expr_symbol_list 
                                            and rt = expr (expr_symbol_list, expr_object_list) e in
                  (match rt with
                      Int -> lt
                    | _ -> raise (Failure("array subscript is not integer in " ^ var))) 
                | ArrayElementAssign(var, e1, e2) as aea -> let lt = type_of_identifier (className ^ "@" ^ var) expr_symbol_list 
                                                              and rt = expr (expr_symbol_list, expr_object_list) e1 in
                      (match rt with
                          Int -> let rrt = expr (expr_symbol_list, expr_object_list) e2 in
                                     check_assign lt rrt (Failure("illegal assignment " ^ string_of_typ lt ^
                                                                  " = " ^ string_of_typ rrt ^ " in " ^ 
                                                                  string_of_expr aea))
                         | _ -> raise (Failure("array subscript is not integer in " ^ var))) 

                | IdInClass(vid, objectname) ->  let class_name = type_of_object objectname expr_object_list in
                                                     type_of_identifier (class_name ^ "@" ^ vid) expr_symbol_list

                | ArrayInClass(vid, subexpr, objectname) -> let subtype = expr (expr_symbol_list, expr_object_list) subexpr in
                                                              if subtype = Int then let class_name = type_of_object objectname expr_object_list in
                                                                      type_of_identifier (class_name ^ "@" ^ vid) expr_symbol_list
                                                                    else raise (Failure("array subscript is not integer in " ^ vid)) 

                | CallDomain(f_name, acts_opt, objectname) as calld->  
                let class_name = type_of_object objectname expr_object_list in
                                                                let fd = function_decl class_name f_name in
                                                                  if List.length acts_opt != List.length fd.formals then
                                                                    raise (Failure ("expecting " ^ string_of_int
                                                                      (List.length fd.formals) ^ " arguments in " ^ string_of_expr calld))
                                                                  else
                                                                    List.iter2 (fun (ft, _) e -> let et = expr (expr_symbol_list, expr_object_list) e in
                                                                      ignore (check_assign ft et
                                                                      (Failure ("illegal actual argument found " ^ string_of_typ et ^
                                                                                 " expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e))))
                                                                    fd.formals acts_opt;
                                                                    fd.typ

                | Negative(_, negexpr) ->  expr (expr_symbol_list, expr_object_list) negexpr

              in

                let check_bool_expr (symbol_list, object_list) e = if expr (symbol_list, object_list) e != Bool
                                                      then raise (Failure ("expected Boolean expression in " ^ string_of_expr e))
                                                    else () in

                let rec stmt (stmt_symbol_list, stmt_object_list, for_while_flag) = function
                  Block sl -> let rec check_block (block_symbol_list, block_object_list) = function
                                   [Return _ as s] -> stmt (block_symbol_list, block_object_list, for_while_flag) s
                                 | Return _ :: _ -> raise (Failure "nothing may follow a return")
                                 | Block sl :: ss -> ignore(check_block (block_symbol_list, block_object_list) sl);
                                                     check_block (block_symbol_list, block_object_list) ss;
                                 | s :: ss -> let (rstsymbol_list, rstobject_list) = stmt (block_symbol_list, block_object_list, for_while_flag) s 
                                                in check_block (rstsymbol_list, rstobject_list) ss; 
                                 | [] -> (block_symbol_list, block_object_list)

                                in check_block (stmt_symbol_list, stmt_object_list) sl

                | Expr e -> (*print_string (string_of_expr e); *)
                           ignore (expr (stmt_symbol_list, stmt_object_list) e); 
                           (stmt_symbol_list, stmt_object_list)

                | Return Noexpr -> if Void = func.typ then (stmt_symbol_list, stmt_object_list) else
                                     raise (Failure ("return gives void expected " ^
                                   string_of_typ func.typ ^ " in return"))

                | Return e -> let t = expr (stmt_symbol_list, stmt_object_list) e 
                                in
                                  if t = func.typ then (stmt_symbol_list, stmt_object_list) else
                                    raise (Failure ("return gives " ^ string_of_typ t ^ " expected " ^
                                                    string_of_typ func.typ ^ " in " ^ string_of_expr e))

                | Ifnoelse(p, b) ->  check_bool_expr (stmt_symbol_list, stmt_object_list) p;
                                     ignore(stmt (stmt_symbol_list, stmt_object_list, for_while_flag) b);
                                     (stmt_symbol_list, stmt_object_list)

                | Ifelse(p, b1, b2) -> ignore(check_bool_expr (stmt_symbol_list, stmt_object_list) p);
                                       ignore(stmt (stmt_symbol_list, stmt_object_list, for_while_flag) b1);
                                       ignore(stmt (stmt_symbol_list, stmt_object_list, for_while_flag) b2);
                                       (stmt_symbol_list, stmt_object_list)

                | For(e1, e2, e3, st) -> ignore (expr (stmt_symbol_list, stmt_object_list) e1);
                                         check_bool_expr (stmt_symbol_list, stmt_object_list)  e2;
                                         ignore (expr (stmt_symbol_list, stmt_object_list) e3);
                                         stmt (stmt_symbol_list, stmt_object_list, true) st

                | While(p, s) -> check_bool_expr (stmt_symbol_list, stmt_object_list) p;
                                 stmt (stmt_symbol_list, stmt_object_list, true) s

                | Bind(b) ->  let typstring = fst b and idstring = (className ^ "@" ^ (snd b)) in
                                (*print_string (string_of_typ typstring);
                                print_string idstring;*)
                                let new_symbol_list = StringMap.add idstring typstring stmt_symbol_list in
                                (*ignore(StringMap.iter print_symbolList new_symbol_list);*)
                                  (new_symbol_list, stmt_object_list)

                | Init(t, s, e) -> let rt = expr (stmt_symbol_list, stmt_object_list) e in
                                               check_assign t rt (Failure ("illegal init " ^ string_of_typ t ^
                                               " = " ^ string_of_typ rt ^ " in " ^ 
                                               string_of_expr e));
                                    ignore(expr (stmt_symbol_list, stmt_object_list) e);

                                   let new_symbol_list = StringMap.add (className ^ "@" ^ s) t stmt_symbol_list
                                     in (*ignore(StringMap.iter print_symbolList new_symbol_list);*) 
                                    (new_symbol_list, stmt_object_list)

                | ArrayBind((t, s, e)) -> let ty = expr (stmt_symbol_list, stmt_object_list) e 
                                      in let _ =
                                      (match ty with Int -> () 
                                                | _ -> raise (Failure("array subscript is not integer in " ^ s))) 
                                      in 
                                      let new_symbol_list = StringMap.add (className ^ "@" ^ s) t stmt_symbol_list
                                        in (new_symbol_list, stmt_object_list)

                | Break -> if for_while_flag then (stmt_symbol_list, stmt_object_list)
                              else raise (Failure ("break is out of for or while loop"))

                | Continue -> if for_while_flag then (stmt_symbol_list, stmt_object_list)
                              else raise (Failure ("continue is out of for or while loop"))

                | Classdecl(class_name, objectname) -> (*print_string (class_decl class_name); print_string objectname;*)
                                                       let new_object_list = StringMap.add objectname (class_decl class_name) stmt_object_list 
                                                         in (*StringMap.iter print_object new_object_list; *)
                                                         (stmt_symbol_list, new_object_list)

              in
              let (stmt_result_symbol_list, _) = stmt (formal_symbol_list, StringMap.empty, false) (Block func.body) in
              ()
            in

        List.iter check_function (List.rev functions);
        symbol_table;
      in
    check_class (symbol_list, cdecl.extends, cdecl.cbody.vandadecls, cdecl.cbody.methods);
  in
List.fold_left check_cdecl symbols cdecls
