module Make : functor(X: Ord) -> sig
  module Bar : module type of Make(X)

  val x : int
  val y : int
end
