module type S = sig
  type 'a key
  (** Key to access a certain value in the context *)

  type t
  (** A context. This is simply a hmap or equivalent, and standard keys into it
      are provided in the rest of the library. *)

  type binding = B : 'a key * 'a -> binding

  val create_key : unit -> 'a key
  (** Make a fresh key, distinct from every other key *)

  val empty : t
  (** Empty context *)

  val mem : _ key -> t -> bool
  val get_exn : 'a key -> t -> 'a
  val get : 'a key -> t -> 'a option
  val add : 'a key -> 'a -> t -> t
  val remove : 'a key -> t -> t
  val iter : (binding -> unit) -> t -> unit
end
