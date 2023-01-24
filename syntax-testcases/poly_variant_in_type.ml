(* https://github.com/ocaml/vim-ocaml/issues/88 *)
(* foo is highlighted incorrectly on every line *)
val bar : [>foo]
let decode x = (Dns.Packet.decode x : (_, Dns.Packet.err) result :> (_, [> foo]) result)
type t = [Dns.Packet.foo | Dns.Packet.bar]
