(**/**)

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

    let equal : type a b. a t -> b t -> bool =
     fun (module K1) (module K2) -> K1.id = K2.id
  end
end

type 'a key = 'a Key.t
type binding = B : 'a Key.t * 'a -> binding

(**/**)

open struct
  type exn_pair = E_pair : 'a Key.t * exn -> exn_pair

  let pair_of_e_pair (E_pair (k, e)) =
    let module K = (val k) in
    match e with
    | K.Store v -> B (k, v)
    | _ -> assert false
end

module M = Map.Make (struct
  type t = int

  let compare (i : int) j = Stdlib.compare i j
end)

type t = { m: exn_pair M.t } [@@unboxed]

let create_key = Key.create
let empty : t = { m = M.empty }
let[@inline] mem k (self : t) = M.mem (Key.id k) self.m

let get_exn (type a) (k : a Key.t) (self : t) : a =
  let module K = (val k) in
  let (E_pair (_, e)) = M.find K.id self.m in
  match e with
  | K.Store v -> v
  | _ -> assert false

let get k (self : t) = try Some (get_exn k self) with Not_found -> None

open struct
  let add_e_pair_ p self =
    let (E_pair ((module K), _)) = p in
    { m = M.add K.id p self.m }
end

let add (type a) (k : a Key.t) v (self : t) : t =
  let module K = (val k) in
  add_e_pair_ (E_pair (k, K.Store v)) self

let remove (type a) (k : a Key.t) (self : t) : t =
  let module K = (val k) in
  { m = M.remove K.id self.m }

let iter f (self : t) = M.iter (fun _ p -> f (pair_of_e_pair p)) self.m
