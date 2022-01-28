type wd
type element
type event
type ls

@send external aEL: ('a, string, event => ()) => () = "addEventListener"
@send external preventDefault: event => () = "preventDefault"

@send external getElmtById: ('a, string) => 'a = "getElementById"
@send external qSA: ('a, string) => Js.Array2.array_like<'a> = "querySelectorAll"
@send external qS: ('a, string) => Js.Nullable.t<'a> = "querySelector"

@send external getAttr: (element, string) => string = "getAttribute"

@send external matchMedia: (wd, string) => 'a = "matchMedia"
@send external addClass: ('a, string) => () = "add"
@send external containsClass: ('a, string) => bool = "contains"

@val external win: 'a = "window"
@val external doc: 'a = "document"

type han
@send external renderHanging: han => unit = "renderHanging"
@send external renderJiya: han => unit = "renderJiya"
@send external renderHWS: han => unit = "renderHWS"

aEL(
  doc,
  "DOMContentLoaded",
  _ => {
    // Han.css
    let han = %raw(`window.Han`)
    renderHanging(han)
    renderJiya(han)
    renderHWS(han)

    // Printer:
    let printer = qS(doc, ".Printer") -> Js.Nullable.toOption

    switch printer {
      | Some(printer) =>
        aEL(
          printer,
          "click",
          _e => win["print"](),
        )
      | None => ()
    }

    // Preference:
    let darkBySystemPref = matchMedia(win, "(prefers-color-scheme: dark)")["matches"]

    qSA(doc, `input[type="checkbox"]`)
      -> Js.Array2.from
      -> Belt.Array.forEach(
        input => {
          let id = input["id"]
          let indeterminable = containsClass(input["classList"], "indeterminable")
          let prevPref = Dom.Storage2.getItem(Dom.Storage2.localStorage, id)

          input["checked"] = switch (id, indeterminable, prevPref) {
            | ("light--dark", _, None) => darkBySystemPref
            | (_, true, None)          => true
            | (_, _, Some(prevPref))   => prevPref == "true"
            | _                        => false
          }

          input["indeterminate"] = switch (indeterminable, prevPref) {
            | (true, None)           => true
            | (true, Some(prevPref)) => prevPref == "indeterminate"
            | (_, _)                 => false
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

          let label = qS(doc, `label.indeterminable[for=${id}]`) -> Js.Nullable.toOption

          switch label {
            | Some(label) =>
              aEL(
                label,
                "click",
                e => switch (input["checked"], input["indeterminate"]) {
                  | (true, false) => {
                      preventDefault(e)

                      input["indeterminate"] = true

                      Dom.Storage2.setItem(
                        Dom.Storage2.localStorage,
                        id,
                        "indeterminate",
                      )
                    }
                  | _ => ()
                },
              )
            | None => ()
          }
        }
      )

    let body = doc["body"]
    body["classList"] -> addClass("ready")
  },
)
