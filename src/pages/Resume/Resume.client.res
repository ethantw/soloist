type wd
type element
type event
type ls

@send external aEL: ('a, string, event => ()) => () = "addEventListener"
@send external preventDefault: event => () = "preventDefault"

@send external getElmtById: ('a, string) => 'a = "getElementById"
@send external qSA: ('a, string) => Js.Array2.array_like<'a> = "querySelectorAll"
@send external qS: ('a, string) => 'a = "querySelector"

@send external getAttr: (element, string) => string = "getAttribute"

@send external matchMedia: (wd, string) => 'a = "matchMedia"

@val external win: 'a = "window"
@val external doc: 'a = "document"

aEL(
  doc,
  "DOMContentLoaded",
  _ => {
    // `:inderterminate` toggles
    let indeterminableInputs =
      qSA(doc, `input[type="checkbox"].indeterminable`)
      -> Js.Array2.from

    indeterminableInputs 
      -> Belt.Array.forEach(
        input => {
          input["indeterminate"] = true
          input["checked"] = true
        }
      )

    let indeterminableLabels = qSA(doc, `label.indeterminable`)

    indeterminableLabels
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
    aEL(
      qS(doc, ".Printer"),
      "click",
      _e => win["print"](),
    )

    // Preference:
    let darkBySystemPref = matchMedia(win, "(prefers-color-scheme: dark)")["matches"]

    qSA(doc, `input[type="checkbox"]`)
      -> Js.Array2.from
      -> Belt.Array.forEach(
        input => {
          let id = input["id"]
          let prevPref = Dom.Storage2.getItem(Dom.Storage2.localStorage, id)

          input["checked"] = switch (id, prevPref) {
            | ("light--dark", None) => darkBySystemPref
            | (_, Some(prevPref))   => prevPref == "true"
            | _                     => false
          }

          aEL(
            input,
            "click",
            _e =>
            Dom.Storage2.setItem(
              Dom.Storage2.localStorage,
              id,
              switch input["checked"] {
                | true  => "true"
                | false => "false"
              },
            )
          )
        }
      )
  },
)
