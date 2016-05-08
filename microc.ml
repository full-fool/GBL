(* Top-level of the MicroC compiler: scan & parse the input,
   check the resulting AST, generate LLVM IR, and dump the module *)

type action = Ast | LLVM_IR | Compile

let _ =
  let action = if Array.length Sys.argv > 1 then
    List.assoc Sys.argv.(1) [ ("-a", Ast);
                              ("-l", LLVM_IR);  (* Generate LLVM, don't check *)
			                        ("-c", Compile) ] (* Generate, check LLVM IR *)
  else Compile in
  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.program Scanner.token lexbuf in

  Semant.check ast;
  (*match action with
=======
  
  match action with
>>>>>>> 614f09a7fa8e35b8f8b436004ed08eaa354eb13b
  LLVM_IR -> print_string (Codegen.translate ast)
  | Compile -> let m = Codegen.translate ast in
    print_string m*)
