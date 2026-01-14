(** Extensible context *)

module Ctxmap = Ctxmap
module Mkfield = Mkfield
include Ctxmap

let make_field : unit -> (module Mkfield.S with type field = 'a) =
  Mkfield.create
