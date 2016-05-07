(* Semantic checking for the MicroC compiler *)

open Ast

module StringMap = Map.Make(String)

(* Semantic checking of a program. Returns void if successful,
   throws an exception if something is wrong.

   Check each global variable, then check each function *)
let check (vandadecl, cdecl) =
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

  let type_of_identifier s symbol_list =
    try StringMap.find s symbol_list
      with Not_found -> raise (Failure ("undeclared identifier " ^ s))
  in 

  let rec expr symbol_list  = function
  Literal _ -> Int
  | Id s -> type_of_identifier s symbol_list
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
  | ArrayElement(var, e) as ae -> 
                    let lt = type_of_identifier var symbol_list and rt = expr symbol_list e in
                    (match rt with
                     Int -> lt
                   | _ -> raise (Failure("array subscript is not integer in " ^ var))) 

    in

    let rec check_vandadecls symbol_list = function
      Bind(b) ->  let typstring = fst b and idstring = snd b in 
                    let new_symbol_list = StringMap.add idstring typstring symbol_list in
                      new_symbol_list
    | Init(t, s, e) as init -> ignore(expr symbol_list e); let new_symbol_list = StringMap.add s t symbol_list in new_symbol_list
    | ArrayBind((t, s, e)) as ab -> let t = expr symbol_list e 
                                    in 
                                    (match t with Int -> () 
                                                | _ -> raise (Failure("array subscript is not integer in " ^ s))) 
                                    in 
                                    let new_symbol_list = StringMap.add s t symbol_list in new_symbol_list
    in
    List.iter check_vandadecls 
  let check_cblock (globals, functions) = function

  
   
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
      body = [] }); ("stri", { typ = String; fname = "stri"; formals = [(Int, "x")];
      body = [] }); ("strb", { typ = String; fname = "strb"; formals = [(Bool, "x")];
      body = [] }); ("strf", { typ = String; fname = "strf"; formals = [(Float, "x")];
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

    (* Type of each variable (global, formal, or local *)
    let symbols = List.fold_left (fun m (t, n) -> StringMap.add n t m)
	StringMap.empty (globals @ func.formals)
    in

let rec expr symbol_list  = function
    Literal _ -> Int
  | BoolLit _ -> Bool
  | FloatLit _ -> Float
  | StringLit _ -> String
  | Id s -> type_of_identifier s symbol_list
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

      | Assign(var, e) as ex ->  let lt = type_of_identifier var symbol_list
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
      | ArrayElement(var, e) as ae -> let lt = type_of_identifier var symbol_list and rt = expr symbol_list e in
                    (match rt with
                     Int -> lt
                   | _ -> raise (Failure("array subscript is not integer in " ^ var))) 
      | ArrayElementAssign(var, e1, e2) as aea -> let lt = type_of_identifier var symbol_list and rt = expr symbol_list e1 in
                    (match rt with
                     Int -> let rrt = expr symbol_list e2 in
                     check_assign lt rrt (Failure("illegal assignment " ^ string_of_typ lt ^
             " = " ^ string_of_typ rrt ^ " in " ^ 
             string_of_expr aea))
                   | _ -> raise (Failure("array subscript is not integer in " ^ var))) 
      


    in

 let check_bool_expr symbol_list e  = if expr symbol_list e != Bool
     then raise (Failure ("expected Boolean expression in " ^ string_of_expr e))
     else () in
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
