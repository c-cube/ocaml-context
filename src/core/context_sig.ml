module type S = sig
  type 'a key
  type t
  type binding = B : 'a key * 'a -> binding

  val create_key : unit -> 'a key
  val empty : t
  val mem : _ key -> t -> bool
  val get_exn : 'a key -> t -> 'a
  val get : 'a key -> t -> 'a option
  val add : 'a key -> 'a -> t -> t
  val remove : 'a key -> t -> t
  val iter : (binding -> unit) -> t -> unit
end
