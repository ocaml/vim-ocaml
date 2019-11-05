Below are the tokens that are used as delimiters for type contexts. It has been
constituted in late 2018 by (manually…) inspecting the (possibly inaccurate)
grammar given in the reference manual; in May 2022, I read through the changelog
from 4.08 to 4.14 and checked that listed syntax-related changes are supported.
So the current implementation *should* support OCaml 4.14, but:

  * I may have missed cases when reading the grammar (I think the documented
    grammar is maintained by hand so it might be incomplete or out-of-sync;
    also, I originally missed some cases because they were only documented in
    the “extensions“ section of the reference manual);
  * a few pathological cases cannot be handled (unless by implementing a pattern
    parser…).

**opening delimiters**
  + `type`, `type nonrec`, `constraint`
  + `exception` (excepted when preceded by `with`, `|` or `(`)
      * the rule is so that `exception` opens a type context when it is used for
        defining an exception, but not when it is used for pattern-matching; the
        case `( exception` is to handle exception patterns under or-patterns,
        which is allowed since OCaml 4.08: `| (exception E 42 | _) -> …`
  + `of`, `:` in sum type definitions
  + `:`, `: type`, `:>`
      * `: type` is because of polymorphic locally abstract types: `let f : type a b . … = …`
        that is necessary because otherwise the type linter would treat `type`
        as beginning a toplevel type definition, which has different delimiters
        (it spans across `=`).

**common closing delimiters**
  + `type`, `exception`, `val`
  + `module`, `class`
  + `method`, `constraint`, `inherit`
      * because of class types: `class c : object method x : int … end`
  + `object`
      * because of `class c : object … end`
  + `struct`
      * because of `module M : MSIG with type t = u = struct … end`
  + `open`, `include`
  + `let`, `external`
  + `in`
      * because of `let exception E of typ in expr`
  + `end`
  + `)`
      * because of type annotations: `(x : int)`
      * but also of functors: `(M : SIG with type t = int)`
      * and also of type abstractions: `let f (type a b) …`
  + `]` and `}`
      * for error reporting
  + `;`
      * why not
  + `;;`
  + EOF

Not all closing delimiters are useful in all situations, but it is safe to add
them anyway, and it may help error reporting (e.g. by adding `}` and `]`, we can
spot dangling closing parentheses).

**more closing delimiters for `type` and `type nonrec` and `constraint` and `exception`**
  - `and` ? 
      * to support `type … and …`
      * nope, we rather implement it as a keyword contained in the region
        (because otherwise, we’d need `and` to also be an opening delimiter for
        type contexts, but at that point we would not be able to distinguish
        between `type … and …` and `let … and …`)

**more closing delimiters for sum type definitions**
  + → the additional closing delimiters for `type`
  + `and`

**more closing delimiters for `of` and `:` in sum type definitions**
  + → the additional closing delimiters for sum type definitions
  + `|`

**more closing delimiters for `:` and `: type` and `:>`**
  + `=`
  + `:>`
      * to support `(x : … :> …)`
  + `}` and `;`
      * for record fields in record expressions

**places where a comment is not recognized (uses of the regex `"\_s"`)**
  - the `nonrec` keyword: `type ??? nonrec`
  - polymorphic locally abstract types: `: ??? type`
  - exception patterns: `with ??? exception`, `| ??? exception`, `( ??? exception`
  - special constructors in sum type definitions: `( ??? )`, `[ ??? ]`, `( ??? :: ??? )`
  - module paths in types: `MyMod ??? .`, `MyFunc ??? (M) ??? .`
  - labeled arguments in types: `myname ??? :`, `?myname ??? :`
  - variance and/or injectivity indications in type definitions: `+ ??? ! ??? 'a`

I think this is good enough, inserting comments there would be strange style.
