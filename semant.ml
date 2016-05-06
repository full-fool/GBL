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
       locals = []; body = [] }); ("printb", { typ = Void; fname = "printb"; formals = [(Bool, "x")];
       locals = []; body = [] }); ("printlni", { typ = Void; fname = "printlni"; formals = [(Int, "x")];
       locals = []; body = [] }); ("printlnb", { typ = Void; fname = "printlnb"; formals = [(Bool, "x")];
       locals = []; body = [] }); ("printf", { typ = Void; fname = "printf"; formals = [(Float, "x")];
       locals = []; body = [] }); ("prints", { typ = Void; fname = "prints"; formals = [(String, "x")];
       locals = []; body = [] }); ("printlnf", { typ = Void; fname = "printlnf"; formals = [(Float, "x")];
       locals = []; body = [] }); ("printlns", { typ = Void; fname = "printlns"; formals = [(String, "x")];
       locals = []; body = [] })]
  
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

    List.iter (check_not_void (fun n -> "illegal void local " ^ n ^
      " in " ^ func.fname)) func.locals;

    report_duplicate (fun n -> "duplicate local " ^ n ^ " in " ^ func.fname)
      (List.map snd func.locals);

    (* Type of each variable (global, formal, or local *)
    let symbols = List.fold_left (fun m (t, n) -> StringMap.add n t m)
	StringMap.empty (globals @ func.formals)
    in

    let type_of_identifier s symbolstable =
      try StringMap.find s symbolstable
      with Not_found -> raise (Failure ("undeclared identifier " ^ s))
    in

    (* Return the type of an expression or throw an exception *)
    let rec expr exp symbolstable = match exp with
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
    stmt symbols (Block func.body)
   
  in
  List.iter check_function functions
