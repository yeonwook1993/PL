# 1 "lexer.mll"
 
 open Parser
 exception Eof
 exception LexicalError
 let comment_depth = ref 0
 let keyword_tbl = Hashtbl.create 31
 let _ = List.iter (fun (keyword, tok) -> Hashtbl.add keyword_tbl keyword tok)
                   [
                    ("iszero", ISZERO);
										("true", TRUE);
										("false", FALSE);
                    ("if", IF);
                    ("then",THEN);
                    ("else",ELSE);
                    ("let",LET);
                    ("in",IN);
                    ("letrec",LETREC);
                    ("read",READ);
                    ("proc",PROC);
                  ] 

# 24 "lexer.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base =
   "\000\000\237\255\238\255\239\255\240\255\002\000\003\000\245\255\
    \247\255\248\255\249\255\250\255\251\255\075\000\150\000\004\000\
    \002\000\254\255\244\255\243\255\051\000\252\255\253\255\017\000\
    \050\000\255\255\254\255";
  Lexing.lex_backtrk =
   "\255\255\255\255\255\255\255\255\255\255\014\000\013\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\003\000\002\000\009\000\
    \000\000\255\255\255\255\255\255\255\255\255\255\255\255\003\000\
    \003\000\255\255\255\255";
  Lexing.lex_default =
   "\001\000\000\000\000\000\000\000\000\000\255\255\255\255\000\000\
    \000\000\000\000\000\000\000\000\000\000\255\255\255\255\255\255\
    \255\255\000\000\000\000\000\000\021\000\000\000\000\000\255\255\
    \255\255\000\000\000\000";
  Lexing.lex_trans =
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\016\000\016\000\016\000\016\000\016\000\000\000\016\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \016\000\000\000\016\000\000\000\000\000\000\000\000\000\000\000\
    \004\000\003\000\008\000\010\000\012\000\009\000\017\000\015\000\
    \014\000\014\000\014\000\014\000\014\000\014\000\014\000\014\000\
    \014\000\014\000\026\000\011\000\006\000\007\000\005\000\019\000\
    \018\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\024\000\025\000\023\000\000\000\000\000\
    \000\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\000\000\000\000\
    \000\000\000\000\013\000\000\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\014\000\014\000\
    \014\000\014\000\014\000\014\000\014\000\014\000\014\000\014\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \002\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\022\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000";
  Lexing.lex_check =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\016\000\016\000\000\000\255\255\016\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\016\000\255\255\255\255\255\255\255\255\255\255\
    \000\000\000\000\000\000\000\000\000\000\000\000\015\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\023\000\000\000\000\000\000\000\000\000\005\000\
    \006\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\020\000\024\000\020\000\255\255\255\255\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\255\255\255\255\
    \255\255\255\255\013\000\255\255\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
    \013\000\013\000\013\000\013\000\013\000\013\000\014\000\014\000\
    \014\000\014\000\014\000\014\000\014\000\014\000\014\000\014\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\020\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255";
  Lexing.lex_base_code =
   "";
  Lexing.lex_backtrk_code =
   "";
  Lexing.lex_default_code =
   "";
  Lexing.lex_trans_code =
   "";
  Lexing.lex_check_code =
   "";
  Lexing.lex_code =
   "";
}

let rec start lexbuf =
   __ocaml_lex_start_rec lexbuf 0
and __ocaml_lex_start_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 28 "lexer.mll"
             ( start lexbuf )
# 166 "lexer.ml"

  | 1 ->
# 29 "lexer.mll"
            ( comment_depth :=1; comment lexbuf; start lexbuf )
# 171 "lexer.ml"

  | 2 ->
# 30 "lexer.mll"
             ( NUM (int_of_string (Lexing.lexeme lexbuf)) )
# 176 "lexer.ml"

  | 3 ->
# 31 "lexer.mll"
          ( let id = Lexing.lexeme lexbuf
            in try Hashtbl.find keyword_tbl id
               with _ -> ID id
            )
# 184 "lexer.ml"

  | 4 ->
# 35 "lexer.mll"
             ( COMMA )
# 189 "lexer.ml"

  | 5 ->
# 36 "lexer.mll"
             ( SEMICOLON )
# 194 "lexer.ml"

  | 6 ->
# 37 "lexer.mll"
             ( PLUS )
# 199 "lexer.ml"

  | 7 ->
# 38 "lexer.mll"
             ( MINUS )
# 204 "lexer.ml"

  | 8 ->
# 39 "lexer.mll"
             ( STAR )
# 209 "lexer.ml"

  | 9 ->
# 40 "lexer.mll"
             ( SLASH )
# 214 "lexer.ml"

  | 10 ->
# 41 "lexer.mll"
             ( EQUAL )
# 219 "lexer.ml"

  | 11 ->
# 42 "lexer.mll"
             ( LE )
# 224 "lexer.ml"

  | 12 ->
# 43 "lexer.mll"
             ( GE )
# 229 "lexer.ml"

  | 13 ->
# 44 "lexer.mll"
             ( LT )
# 234 "lexer.ml"

  | 14 ->
# 45 "lexer.mll"
             ( GT )
# 239 "lexer.ml"

  | 15 ->
# 46 "lexer.mll"
             ( LPAREN )
# 244 "lexer.ml"

  | 16 ->
# 47 "lexer.mll"
             ( RPAREN )
# 249 "lexer.ml"

  | 17 ->
# 48 "lexer.mll"
             ( EOF)
# 254 "lexer.ml"

  | 18 ->
# 49 "lexer.mll"
         ( raise LexicalError )
# 259 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_start_rec lexbuf __ocaml_lex_state

and comment lexbuf =
   __ocaml_lex_comment_rec lexbuf 20
and __ocaml_lex_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 52 "lexer.mll"
          (comment_depth := !comment_depth+1; comment lexbuf)
# 271 "lexer.ml"

  | 1 ->
# 53 "lexer.mll"
          (comment_depth := !comment_depth-1;
           if !comment_depth > 0 then comment lexbuf )
# 277 "lexer.ml"

  | 2 ->
# 55 "lexer.mll"
         (raise Eof)
# 282 "lexer.ml"

  | 3 ->
# 56 "lexer.mll"
         (comment lexbuf)
# 287 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_comment_rec lexbuf __ocaml_lex_state

;;
