(* TODO:
 * - error reporting of wrong keywords in type context: mutable/of/done/etc.
 * - class type parameters
 *
 * Cases which were not detected by examining the OCaml grammar in the manual:
 * - let f (type a b) …
 * - module M : MSIG with type t = u = struct … end
 * - module M (X : …) …
 * - (x : t :> t)
 * - (x : name :> t)  (“name :” looks like a label)
 * - let f : type a b. a -> b = …
 * - let f ~x:local_name …
 * - false, true, (), [], :: are constructors
 * - extensible type: type u = .. , type u += U2
 * - destructive substitution (lang. extension): with type t := …
 *)

(* TYPE EXPRESSIONS *)

  type t0 = unit
  type _ t1 = bool
  type (_, _) t2 = int
  type u = char
  type v = string
  type w = bytes

  (* type expressions with arrows, tuples, 0-ary type constructors *)
  type t = t0 * t0 -> t0
  (* type expressions with type arguments *)
  type t = t0 * u t1 -> (v, w) t2
  (* type expressions with builtin type names *)
  type t = unit option * bool ref * int array * char list -> (string, bytes) result
  (* type expressions with type variables *)
  type ('a, 'b) t = 'a list * ('a, 'b) result
  (* type expressions with module paths *)
  type t = Scanf.Scanning . in_channel
  type t = Stdlib.Set.Make ( Stdlib.Set.Make(Stdlib.Set.Make(Int)) ) . t
  (* type expressions with labels *)
  type t = name : int -> int
  type t = ?name : int -> int
  (* conflict between labels in type expressions and builtin type names *)
  type t = int : int -> int
  type t = ?int : int -> int
  (* type expressions with parentheses *)
  type t = (((?name : int -> int) -> int) -> int)
  (* quantified type expression *)
  let f : 'a 'b . 'a -> 'b -> 'a * 'b = fun x y -> (x, y)

  (* object types *)
  type 't t =
    <
      method1 : int * int ;
      method2 : name:int -> int ;
      ..
    > as 't

  (* polymorphic variant types *)
  type 't t = [< `a ] as 't
  type 't t = [> `a ] as 't
  type t = [ `a ]
  type t = [ `a | `b ]
  type 't t = [< `a of int * int & char -> char ] as 't
  type 't t = [< `a of int * int & char -> char | `b of int * int ] as 't
  (* syntax errors *)
  (*! type 't t = [ `a : int * int -> t & (char -> char) -> t ] as 't !*)
  (*! type 't t = [ `a : int * int -> t & (char -> char) -> t | `b : int * int -> t ] as 't !*)

(* TYPE DEFINITIONS *)

  (* type definitions with type variables *)
  type 'a t = 'a option
  type ('a, 'b) t = ('a, 'b) result
  type _ t = int
  type ('a, _) t = 'a

  (* type definitions with injectivity and variance precisions *)
  type + 'a t = int
  type + _ t = int
  type - 'a t = int
  type - _ t = int
  type (+'a, -_) t = int
  type ! 'a t = 'a list
  type ! + 'a t = 'a list
  type + ! 'a t = 'a list
  type (-!'a, !+'b) t = 'a -> 'b

  (* type definitions with “nonrec” and “private” *)
  type nonrec 'a r = 'a ref = private { mutable contents : 'a }
  type nonrec 'a r = private 'a r
  type nonrec 'a o = 'a option = private None | Some of 'a
  type nonrec 'a o = private 'a o

  (* type definitions with “as” *)
  type 'a t = int as 'a
  (* the “as” keyword outside of type contexts: *)
  let x as y = 0

  (* type definitions with constraints *)
  type 'a t = int * 'a constraint (int * int) * int = 'a t * int
  type t = A constraint int = int

  (* mutually recursive type definitions *)
  type t = int  and  u = int
  type t = A  and  u = B
  type t = int constraint int = t  and  u = int constraint int = u

  (* definition of record types *)
  type t =
    {
      mutable field1 : int * int ;
      field2 : name:int -> int
    }

  (* definition of sum types *)
  type t =   A
  type t = | A
  type t =   A | B
  type t = | A | B
  type t =   A of int * int
  type t = | A of int * int
  type t =   A : int * int -> t
  type t = | A : int * int -> t
  type t =   A of int * int | B of int * int
  type t = | A of int * int | B of int * int
  type t =   A : int * int -> t | B : int * int -> t
  type t = | A : int * int -> t | B : int * int -> t

  (* definition of sum types with inline records *)
  type t = A of { field1 : int ; mutable field2 : int }
  type t = A :  { field1 : int ; mutable field2 : int } -> t

  (* definition of extensible sum types *)
  type t = ..
  type t += A | B
  type t += C of int
  type t += D : int -> t

  (* definition of exceptions *)
  exception E
  exception E of int
  exception E : int -> exn
  exception E' = E (* FIXME *)
  (* local exceptions *)
  let _ = let exception E in ()
  let _ = let exception E of int * int in ()
  let _ = let exception E : int -> exn in ()
  (* exception patterns *)
  let _ = match () with () -> () | exception E 42 -> ()
  let _ = match () with exception E 42 -> () | () -> ()
  let _ = match () with exception E 42 -> () | () -> () | exception E' 42 -> ()
  (* exception patterns under or-patterns (since OCaml 4.08) *)
  let _ = match () with (exception E 42 | exception E 43) -> () | _ -> ()
  (* empty type definition followed by an exception definition *)
  type t = | exception E

  (* definition with a constant constructor followed by a comment *)
  type t = A (* should work *)
  exception E (* should work *)

  (* corner case: “false”, “true”, “()” “[]” and “::” are constructors, too! *)
  module DamageControl = struct
    type 'a t = ( ) | false | true of 'a | [  ] | (::) of 'a * 'a
  end

  (* definition of an empty type *)
  type t = |

(* TYPE ANNOTATIONS *)

  (* annotations on let binders *)
  let _ : float = 0.
  let f x : float = 0.
  let f (x : int) = 0.
  let f (x : int) : float = 0.
  let f ~(x : int) = 0.
  let f ?(x : int option)() = 0.
  let f ?(x : int = 0)() = 0.

  (* conflict between type annotations and local renaming of labels *)
  (* y is the local name of x, int is the type of x, float is the return type *)
  let f ~x:y          = float y
  let f ~x: y         = float y
  let f ~x :float     = float x
  let f ~x : float    = float x
  let f ~x:y:float    = float y
  let f ~x:y :float   = float y
  let f ~x:y: float   = float y
  let f ~x:y : float  = float y
  let f ~x: y:float   = float y
  let f ~x: y :float  = float y
  let f ~x: y: float  = float y
  let f ~x: y : float = float y
  let f ~x:(y:int)   : float = float y
  let f ~x:(y : int) : float = float y
  (*! let f ~x : y : float = float y (* syntax error *) !*)
  (* the same with optional arguments *)
  let[@warning "-16"] f ?x:y          = 0.
  let[@warning "-16"] f ?x: y         = 0.
  let[@warning "-16"] f ?x :float     = 0.
  let[@warning "-16"] f ?x : float    = 0.
  let[@warning "-16"] f ?x:y:float    = 0.
  let[@warning "-16"] f ?x:y :float   = 0.
  let[@warning "-16"] f ?x:y: float   = 0.
  let[@warning "-16"] f ?x:y : float  = 0.
  let[@warning "-16"] f ?x: y:float   = 0.
  let[@warning "-16"] f ?x: y :float  = 0.
  let[@warning "-16"] f ?x: y: float  = 0.
  let[@warning "-16"] f ?x: y : float = 0.
  let[@warning "-16"] f ?x:(y:int option)   : float = 0.
  let[@warning "-16"] f ?x:(y : int option) : float = 0.
  let[@warning "-16"] f ?x:(y : int = 0)    : float = 0.
  (*! let f ?x : y : float = 0. (* syntax error *) !*)
  (* even worse *)
  let f ~x:y:z:unit->float = fun ~z:_ -> 0.
  let[@warning "-16"] f ?x:y:z:unit->float = fun ~z:_ -> 0.

  (* annotations and coercions on expressions *)
  let f x = (x : int)
  let f x = (x :> int)
  let f x = (x : int :> int)

  (* nested within parentheses *)
  let _ = let x : int = 0 in x
  let _ = (let x : int = 0 in x)

  (* nested type expressions *)
  let _ : < x : int ; y : int > = object method x = 0 method y = 0 end
  type 'a t = {
      field1 : int * < method1 : int -> string ; .. > as 'a ;
      field2 : int * < method1 : int -> string > ;
    }

  (* annotations in pattern-matching *)
  type t = A | B of int
  let _ = function
    | A -> ()
    | (B (x:int) : t) -> ()

  (* annotations on record fields *)
  type t = { x : int ; y : int }
  let _ = { x : int = 0 ; y : int = 0 }
  let _ = let x = 0 and y = 0 in { x : int ; y : int }

  (* annotations on object values and methods *)
  class c : object val v : int method x : int method y : int end =
    object val v : int = 0 method x : int = 0 method y : int = 0 end

(* LOCALLY ABSTRACT TYPES *)

  (* type parameter *)
  let f (type a) (x : a) : a = x
  (* existential type when pattern-matching a GADT (since OCaml 4.13) *)
  (*! type t = A : ('a * ('a->string)) -> t !*)
  (*! let f t = match t with A (type a) (x, print : a * _) -> print x !*)
  (* polymorphic syntax for locally abstract types;
   * NOTE: this is only allowed on let/method defs, right after the colon. *)
  let f : type a b . a -> b -> a * b = fun x y -> (x, y)
  let _ = object method f : type a b. a -> b -> a * b = f end
  (* annotations on let must eat "type" but annotations on val must not *)
  module type SIG = sig
    type t = int
    val x : int
    type u = int
  end

(* CLASS TYPES *)

  class c : x:int -> object
    method f : int
    method g : float
    constraint int = int
    inherit object end
  end =
  fun ~x ->
  object
    method f : int = 0
    method g : float = 0.
  end

  (* FIXME the type parameters of the class should be highlighted as types: *)
  class ['a, 'b] c : x:int ->
    let open List in
    object end
    =
    fun ~x ->
    object end

(* MODULES *)

  module type SIG = sig type t end

  (* modules with type constraints *)
  module F (M : sig end) : SIG with type t = int = struct type t = int end
  module F (M : SIG with type t = int) : SIG = M

  (* destructive type substitutions inside signatures *)
  module type SIG = sig type t val x : t end
  module type SIGINT = SIG with type t := int

  (* nesting *)
  module M : sig
    val f : 'a -> 'a
    type t = A | B of int | C of {x:int}
    module M : sig
      val f : 'a -> 'a
      type t = A | B of int | C of {x:int}
    end
  end = struct
    let f : type a. a -> a = fun x -> x
    type t = A | B of int | C of {x:int}
    module M : sig
      val f : 'a -> 'a
      type t = A | B of int | C of {x:int}
    end = struct
      let f : type a. a -> a = fun x -> x
      type t = A | B of int | C of {x:int}
    end
  end

(* ATTRIBUTES *)

  exception[@my.attr "my payload"] E [@my.attr "my payload"]
  type[@my.attr "my payload"] t = int [@@my.attr "my payload"]
  type t = < x : int [@my.attr "my payload"] ; y : int >
  type t = { x : int [@my.attr "my payload"] ; y : int }
  type t = { x : int ; [@my.attr "my payload"] y : int }
  type t = [ `A of int [@my.attr "my payload"] | `B of int ]
  type t = [ `A of int [@my.attr "my payload"] | `B of int ]
  type t = | A of int [@my.attr "my payload"] | B of int
  let _ : unit [@my.attr "my payload"] = ()

(* VARIOUS TRAPS *)

  (* items that have different meanings at type level and at value level *)
  let float ~float = float
  (*  let-bound identifier
   *  |      optional named arg
   *  |      |      local name for named arg
   *  |      |      |     TYPE OF NAMED ARG         RETURN TYPE
   *  |      |      |     <------------>            <--->
   *  |      |      |     named arg in type         builtin type
   *  |      |      |     |        builtin          |       variable in expr
   *  |      |      |     |        |     default value of optional arg
   *  |      |      |     |        |     |          |       |
   *  v      v      v     v        v     v          v       v                 *)
  let float ?float:(float:float:_->float=float)() : float = float ~float:0.
  let _ : < bool : bool * bool > = object method bool = 1 < 2 * 3, 4 * 5 > 6 end

  (* expression items that start with a colon *)
  let f r x = r := x
  let _ = 0 :: []

  (* different uses of the syntax “name : type -> type” *)
  type t  = ( x : int -> bool )  (* x is a label of type int *)
  type t  = { x : int -> bool }  (* x is a field of type int->bool *)
  let f x = ( x : int -> bool )  (* x is an expr of type int->bool *)
  let f = ( fun x -> x : int -> int  )  (* x is an expr of type int *)
  let f (=) x = ( x = x : int -> bool ) (* totally irrealistic case *)

  (* FIXME the unsolvable problem *)
  let _ = fun x : int -> 42 (* int is the return type, `->` ends the type! *)
