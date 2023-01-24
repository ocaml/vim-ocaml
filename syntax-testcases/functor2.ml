(* https://github.com/ocaml/vim-ocaml/issues/3 *)

module Make (M : sig end) = struct module type S = sig end end
module Test : Make(Make(Int)).S = struct end
(* ----------------^ the inner modules are linted as constructors *)
