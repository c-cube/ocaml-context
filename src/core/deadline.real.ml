(** Deadlines *)

(** {2 Deadlines}

    Depends on [mtime]. *)

(** Key to access a deadline from inside the request context. This can be useful
    for systems concerned with timeout or cancellation of a request after a
    certain amount of time has passed. *)
let k_deadline : Mtime.t Hetmap.key = Hetmap.create_key ()

let[@inline] deadline (self : Hetmap.t) : Mtime.t option =
  Hetmap.get k_deadline self

(** @raise Invalid_argument if no deadline was defined *)
let[@inline] deadline_exn (self : Hetmap.t) : Mtime.t =
  Hetmap.get_exn k_deadline self

(** Set deadline *)
let[@inline] with_deadline t (ctx : Hetmap.t) : Hetmap.t =
  Hetmap.add k_deadline t ctx

(** Has the deadline been reached? This uses {!Mtime_clock.now} to compare it to
    the stored deadline. If there is no deadline then this returns [false]. *)
let expired (ctx : Hetmap.t) : bool =
  match deadline ctx with
  | None -> false
  | Some t ->
    let now = Mtime_clock.now () in
    Mtime.is_later now ~than:t
