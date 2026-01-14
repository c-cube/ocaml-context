module type S = sig
  type field

  val key : field Ctxmap.key
  val get : Ctxmap.t -> field option
  val get_exn : Ctxmap.t -> field
  val set : field -> Ctxmap.t -> Ctxmap.t
end

module Make
    (X : sig
      type t
    end)
    () : S with type field = X.t = struct
  type field = X.t

  let key : field Ctxmap.key = Ctxmap.create_key ()
  let[@inline] get (self : Ctxmap.t) = Ctxmap.get key self
  let[@inline] get_exn (self : Ctxmap.t) : field = Ctxmap.get_exn key self
  let[@inline] set t (ctx : Ctxmap.t) : Ctxmap.t = Ctxmap.add key t ctx
end

let create (type t) () : (module S with type field = t) =
  let module M =
    Make
      (struct
        type nonrec t = t
      end)
      ()
  in
  (module M)
