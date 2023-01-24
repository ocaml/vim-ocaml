(* ok *)
module M : sig
  module type F
    = functor () (X : Ord) -> sig end
  module F
    : functor () (X : Ord) -> sig end
end
= struct
  module type F
    = functor () (X : Ord) -> sig end
  module F
    : functor () (X : Ord) -> sig end
    = functor () (X : Ord) -> struct end
end

module type F
  = functor () (X : Ord) -> sig end
module F
  : functor () (X : Ord) -> sig end
  = functor () (X : Ord) -> struct end
