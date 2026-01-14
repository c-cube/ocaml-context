open struct
  module type KEY_IMPL = sig
    type t

    exception Store of t

    val id : int
  end

  module Key = struct
    type 'a t = (module KEY_IMPL with type t = 'a)

    let _n = ref 0

    let create (type k) () =
      incr _n;
      let id = !_n in
      let module K = struct
        type t = k

        let id = id

        exception Store of k
      end in
      (module K : KEY_IMPL with type t = k)

    let[@inline] id (type k) (module K : KEY_IMPL with type t = k) = K.id
  end
end

(**/**)

module Private_implem_ : Context_sig.S = struct
  type 'a key = 'a Key.t
  type exn_pair = E_pair : 'a Key.t * exn -> exn_pair

  module M = Map.Make (struct
    type t = int

    let[@inline] compare (i : int) j = Stdlib.compare i j
  end)

  type t = exn_pair M.t
  type binding = B : 'a key * 'a -> binding

  let create_key = Key.create
  let empty : t = M.empty
  let[@inline] mem k (self : t) = M.mem (Key.id k) self

  let get_exn (type a) (k : a Key.t) (self : t) : a =
    let module K = (val k) in
    let (E_pair (_, e)) = M.find K.id self in
    match e with
    | K.Store v -> v
    | _ -> assert false

  let get k (self : t) = try Some (get_exn k self) with Not_found -> None

  let pair_of_e_pair (E_pair (k, e)) =
    let module K = (val k) in
    match e with
    | K.Store v -> B (k, v)
    | _ -> assert false

  let add_e_pair_ p self =
    let (E_pair ((module K), _)) = p in
    M.add K.id p self

  let add (type a) (k : a Key.t) v (self : t) : t =
    let module K = (val k) in
    add_e_pair_ (E_pair (k, K.Store v)) self

  let remove (type a) (k : a Key.t) (self : t) : t =
    let module K = (val k) in
    M.remove K.id self

  let iter f (self : t) = M.iter (fun _ p -> f (pair_of_e_pair p)) self
end

(**/**)

include Private_implem_
