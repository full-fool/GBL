(* Semantic checking for the MicroC compiler *)

open Ast

module StringMap = Map.Make(String)

(* Semantic checking of a program. Returns void if successful,
   throws an exception if something is wrong.

   Check each global variable, then check each function *)

let check (globals, functions) =

  (* Raise an exception if the given list has a duplicate *)
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
  
  (* Raise an exception of the given rvalue type cannot be assigned to
     the given lvalue type *)
  let check_assign lvaluet rvaluet err =
     if lvaluet == rvaluet then lvaluet else raise err
  in
   
  (**** Checking Global Variables ****)

  List.iter (check_not_void (fun n -> "illegal void global " ^ n)) globals;
   
  report_duplicate (fun n -> "duplicate global " ^ n) (List.map snd globals);

  (**** Checking Functions ****)

  if List.mem "print" (List.map (fun fd -> fd.fname) functions)
  then raise (Failure ("function print may not be defined")) else ();

  report_duplicate (fun n -> "duplicate function " ^ n)
    (List.map (fun fd -> fd.fname) functions);

  (* Function declaration for a named function *)
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
      body = [] })]
  
   in
     
  let function_decls = List.fold_left (fun m fd -> StringMap.add fd.fname fd m)
                         built_in_decls functions
  in

  let function_decl s = try StringMap.find s function_decls
       with Not_found -> raise (Failure ("unrecognized function " ^ s))
  in

  let _ = function_decl "main" in (* Ensure "main" is defined *)

  let check_function func =

    List.iter (check_not_void (fun n -> "illegal void formal " ^ n ^
      " in " ^ func.fname)) func.formals;

    report_duplicate (fun n -> "duplicate formal " ^ n ^ " in " ^ func.fname)
      (List.map snd func.formals);
(* 
    List.iter (check_not_void (fun n -> "illegal void local " ^ n ^
      " in " ^ func.fname)) func.locals; *)

(*     report_duplicate (fun n -> "duplicate local " ^ n ^ " in " ^ func.fname)
      (List.map snd func.locals); *)

    (* Type of each variable (global, formal, or local *)
    let symbols = List.fold_left (fun m (t, n) -> StringMap.add n t m)
	StringMap.empty (globals @ func.formals)
    in

(*     let type_of_identifier s symbolstable =
      try StringMap.find s symbolstable
      with Not_found -> raise (Failure ("undeclared identifier " ^ s))
    in *)

    (* Return the type of an expression or throw an exception *)
 (*    let rec expr exp symbolstable = match exp with
	Literal _ -> Int
      | BoolLit _ -> Bool
      | FloatLit _ -> Float
      | StringLit _ -> String
      | Id s -> type_of_identifier s symbolstable
      | Binop(e1, op, e2) as e -> let t1 = expr e1 symbolstable and t2 = expr e2 symbolstable in
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
      | Unop(op, e) as ex -> let t = expr e symbolstable in
	 (match op with
	   Neg when t = Int -> Int
   | Neg when t = Float -> Float
	 | Not when t = Bool -> Bool
         | _ -> raise (Failure ("illegal unary operator " ^ string_of_uop op ^
	  		   string_of_typ t ^ " in " ^ string_of_expr ex)))
      | Noexpr -> Void
      | Assign(var, e) as ex -> let lt = type_of_identifier var symbolstable
                                and rt = expr e symbolstable in
        check_assign lt rt (Failure ("illegal assignment " ^ string_of_typ lt ^
				     " = " ^ string_of_typ rt ^ " in " ^ 
				     string_of_expr ex))
      | Call(fname, actuals) as call -> let fd = function_decl fname in
         if List.length actuals != List.length fd.formals then
           raise (Failure ("expecting " ^ string_of_int
             (List.length fd.formals) ^ " arguments in " ^ string_of_expr call))
         else
           List.iter2 (fun (ft, _) e -> let et = expr e symbolstable in
              ignore (check_assign ft et
                (Failure ("illegal actual argument found " ^ string_of_typ et ^
                " expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e))))
             fd.formals actuals;
           fd.typ
    in

    let check_bool_expr e symbolstable = if expr e symbolstable != Bool
     then raise (Failure ("expected Boolean expression in " ^ string_of_expr e))
     else () in
     let rec print_symbol key value = print_string(key ^ " " ^ value ^ "\n") in
    
    (* Verify a statement or throw an exception *)
    let rec stmt parenttable childtable blocks = match blocks with
	    Block sl -> let rec check_block maintable subtable block = match block with
           [Return _ as s] -> stmt maintable subtable s
         | Return _ :: _ -> raise (Failure "nothing may follow a return")
         | Block sl :: ss -> check_block subtable (sl @ ss)
         | s :: ss -> stmt parenttable s ; check_block subtable ss
         | [] -> ()
        in check_block StringMap.empty sl
      | Expr e -> ignore (expr e parenttable)
      | Return e -> let t = expr e parenttable in if t = func.typ then () else
         raise (Failure ("return gives " ^ string_of_typ t ^ " expected " ^
                         string_of_typ func.typ ^ " in " ^ string_of_expr e))
           
      | If(p, b1, b2) -> check_bool_expr p; stmt parenttable b1; stmt parenttable b2
      | For(e1, e2, e3, st) -> ignore (expr e1 parenttable); check_bool_expr e2;
                               ignore (expr e3 parenttable); stmt parenttable st
      | While(p, s) -> check_bool_expr p; stmt parenttable s
      | Break -> ()
      | Continue -> () 
    
    in
    let submaps = StringMap.empty in
    stmt symbols (Block func.body) *)

let rec expr symbol_list  = function
  Literal _ -> Int
      | BoolLit _ -> Bool
      | Id s ->    let type_of_identifier s =
                  try StringMap.find s symbol_list
                with Not_found -> raise (Failure ("undeclared identifier " ^ s))
                in
            type_of_identifier s
      | Binop(e1, op, e2) as e -> let t1 = expr symbol_list e1 and t2 = expr symbol_list e2 in
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
      | Unop(op, e) as ex -> let t = expr symbol_list e in
         (match op with
          Neg when t = Int -> Int
        | Neg when t = Float -> Float
        | Not when t = Bool -> Bool
        | _ -> raise (Failure ("illegal unary operator " ^ string_of_uop op ^
                 string_of_typ t ^ " in " ^ string_of_expr ex)))
      | Noexpr -> Void
      | Assign(var, e) as ex ->  let type_of_identifier s =
                        try StringMap.find s symbol_list
                    with Not_found -> raise (Failure ("undeclared identifier " ^ s))
                      in


                    let lt = type_of_identifier var
                                and rt = expr symbol_list e in
        check_assign lt rt (Failure ("illegal assignment " ^ string_of_typ lt ^
             " = " ^ string_of_typ rt ^ " in " ^ 
             string_of_expr ex))
      | Call(fname, actuals) as call -> let fd = function_decl fname in
         if List.length actuals != List.length fd.formals then
           raise (Failure ("expecting " ^ string_of_int
             (List.length fd.formals) ^ " arguments in " ^ string_of_expr call))
         else
           List.iter2 (fun (ft, _) e -> let et = expr symbol_list e in
              ignore (check_assign ft et
                (Failure ("illegal actual argument found " ^ string_of_typ et ^
                " expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e))))
             fd.formals actuals;
           fd.typ
    in

 let check_bool_expr symbol_list e  = if expr symbol_list e != Bool
     then raise (Failure ("expected Boolean expression in " ^ string_of_expr e))
     else () in
  let print_symbol_list symbol_list = 
    (* Verify a statement or throw an exception，更新后的stmt函数返回一个symbol_list *)
    let rec stmt symbol_list = function
   Block sl -> let rec check_block block_symbol_list = function  (* block里是一个stmt list，所以此处check_block的参数就是一个list。函数结构和产生式定义结构类似 *)
           [Return _ as s] -> stmt block_symbol_list s
         | Return _ :: _ -> raise (Failure "nothing may follow a return")
         | Block sl :: ss -> check_block block_symbol_list sl; check_block block_symbol_list ss;
         | s :: ss -> let rstsymbol_list = stmt block_symbol_list s in print_symbol_list rstsymbol_list; check_block rstsymbol_list ss; 
         | [] -> block_symbol_list
        in check_block symbol_list sl
      | Expr e -> ignore (expr symbol_list e); symbol_list
      | Return e -> let t = expr symbol_list e in if t = func.typ then symbol_list else
         raise (Failure ("return gives " ^ string_of_typ t ^ " expected " ^
                         string_of_typ func.typ ^ " in " ^ string_of_expr e))
           
      | If(p, b1, b2) -> check_bool_expr symbol_list p ; stmt symbol_list b1; stmt symbol_list b2; symbol_list
      | For(e1, e2, e3, st) -> ignore (expr symbol_list e1); check_bool_expr symbol_list e2 ;
                               ignore (expr  symbol_list e3); stmt symbol_list st
      | While(p, s) -> check_bool_expr symbol_list p; stmt symbol_list s
      | Bind(b) ->  let typstring = fst b and idstring = snd b in 
                    let new_symbol_list = StringMap.add idstring typstring symbol_list in
                      new_symbol_list
      | Init(t, s, e) -> ignore(expr symbol_list e); let new_symbol_list = StringMap.add s t symbol_list in new_symbol_list
      | Break -> symbol_list
      | Continue -> symbol_list

    in

    stmt symbols (Block func.body); ()

   
  in
  List.iter check_function functions
