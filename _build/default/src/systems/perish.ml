open Ecs
open Component_defs

type t = perishable

let init _ = ()


let update dt el =
  Seq.iter (fun (e:t) ->

    let lt = e#lifetime#get in
    let lt' = lt -. (dt -. !timer) in
    if lt' <= 0.0 then (
      Entity.delete e
    ) else (
      e#lifetime#set lt'
    );

    ) el;