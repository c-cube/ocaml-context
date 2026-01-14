(** Context *)

(** {2 Main type definition} *)

(**/**)

module Private_implem_ :
  Context_sig.S
    with type t = Hmap.t
     and type 'a key = 'a Hmap.key
     and type binding := Hmap.binding = struct
  type 'a key = 'a Hmap.key
  (** Key to access a certain value in the context *)

  (** Make a fresh key *)
  let create_key : unit -> 'a key = Hmap.Key.create

  type t = Hmap.t
  (** A request context. This is simply a hmap, and standard keys into it are
      provided in the rest of the library. *)

  (** Empty context *)
  let empty : t = Hmap.empty

  let add : 'a key -> 'a -> t -> t = Hmap.add
  let remove : 'a key -> t -> t = Hmap.rem
  let mem : 'a key -> t -> bool = Hmap.mem
  let get : 'a key -> t -> 'a option = Hmap.find
  let get_exn : 'a key -> t -> 'a = Hmap.get

  type binding = Hmap.binding = B : 'a key * 'a -> binding

  let iter : (binding -> unit) -> t -> unit = Hmap.iter
end

(**/**)

include Private_implem_
