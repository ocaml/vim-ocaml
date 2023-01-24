module M0 : sig end = struct let x = 0 end
(* => linting of struct is correct *)

module M1 : sig end = (struct let x = 0 end : sig end)
(* => linting of struct is correct
  (but linting of last sig is buggy because of the type linter of PR#76) *)

module M2 = (struct let x = 0 end : sig end)
(* =>        ^^^^^^^^^^^^^^^^^^^^
   the whole struct is linted with a wrong, uniform style
   (but linting of last sig is correct) *)
