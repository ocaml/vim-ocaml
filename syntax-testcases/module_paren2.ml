(* https://github.com/ocaml/vim-ocaml/issues/6 *)

module IM           = Stdlib.Map.Make(Int)
(*                    ^^^^^^^^^^^^^^^^^^^^
   shown as a module/functor, with a uniform style *)

module IM : sig end = Stdlib.Map.Make(Int)
(*                    ^^^^^^^^^^^^^^^^^^^^
   shown as as an expression (a datatype constructor `Make`
   prefixed with a module path, and a constructor `Int`) *)
