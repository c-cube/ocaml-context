(** Start time *)

(** {2 Start time for a request or task}

    Depends on [mtime]. *)

(** Instant at which an action was started, a request was received, etc. This
    can be useful for middlewares related to timing, tracing, latency
    statistics, etc. *)
let k_start_time : Mtime.t Context.key = Context.create_key ()

let[@inline] start_time (self : Context.t) : Mtime.t option =
  Context.get k_start_time self

(** @raise Invalid_argument if no start time present *)
let[@inline] start_time_exn (self : Context.t) : Mtime.t =
  Context.get_exn k_start_time self

let with_start_time t (ctx : Context.t) : Context.t =
  Context.add k_start_time t ctx

let with_start_time_now (ctx : Context.t) : Context.t =
  let now = Mtime_clock.now () in
  with_start_time now ctx
