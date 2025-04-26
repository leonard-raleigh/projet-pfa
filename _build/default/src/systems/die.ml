open Ecs
open Component_defs

type t = killable

let init _ = ()


let update dt el =
  Seq.iter (fun (e:t) ->

    if e#hp#get <= 0 then Entity.delete e

    ) el;