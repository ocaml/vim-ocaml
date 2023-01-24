(* approximately ok:
 *   - "module type of" linted as ocamlKeyword
 *   - "F" linted as ocamlModule
 *   - "(X)" linted meaninglessly but by chance it doesn’t look SO bad
 *)
module N : module type of F(X)

module M : sig
  module N : module type of X
  module N : module type of F(X)
  val x : int
end
