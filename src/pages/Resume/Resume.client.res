type element
type event 

@send external aEL: ('a, string, event => ()) => () = "addEventListener"
@send external preventDefault: event => () = "preventDefault"

@send external getElmtById: ('a, string) => 'a = "getElementById"
@send external qSA: ('a, string) => Js.Array2.array_like<'a> = "querySelectorAll"
@send external qS: ('a, string) => 'a = "querySelector"

@send external getAttr: (element, string) => string = "getAttribute"

@val external doc: 'a = "document"
@val external win: 'a = "window"

aEL(
  doc,
  "DOMContentLoaded",
  _ => {
    // `:inderterminate` toggles
    let indeterminable_inputs = qSA(doc, `input[type="checkbox"].indeterminable`)

    indeterminable_inputs 
    -> Js.Array2.from
    -> Belt.Array.forEach(
      input => {
        input["indeterminate"] = true
        input["checked"] = true
      }
    )

    let indeterminable_labels = qSA(doc, `label.indeterminable`)

    indeterminable_labels
    -> Js.Array2.from
    -> Belt.Array.forEach(
      label => {
        let htmlFor = getAttr(label, "for")
        let input = getElmtById(doc, htmlFor)

        aEL(
          label,
          "click",
          e => switch (input["checked"], input["indeterminate"]) {
            | (true, false) => {
                preventDefault(e)
                input["indeterminate"] = true
              }
            | _ => ()
          },
        )
      }
    )

    // Printer:
    let p = qS(doc, ".Printer")

    aEL(
      p,
      "click",
      (_e) => win["print"](),
    )

  },
)
