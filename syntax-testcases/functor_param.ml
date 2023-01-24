module M : sig
  module F () (X : Ord) : sig end
end
= struct
  module F () (X : Ord) : sig end = struct end
end

module F () (X : Ord) : sig end = struct end
