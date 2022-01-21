let csv = H.joinSrcPaths("helpers/HantHans.csv")

@@warning("-8")
let hantHansMap =
  lazy({ Node.Fs.readFileSync(csv, #utf8) })
  -> Lazy.force
  -> Js.String2.splitByRe(%re("/\\n/g"))
  -> H.fold(
      Js.Dict.empty(),
      (acc, maybeRow) => switch maybeRow {
        | Some(row) =>
          switch row -> Js.String2.split(",") {
            | [t, s] => {
                acc -> Js.Dict.set(t, s)
                acc
              }
            | _ => acc
          }
        | _ => acc
      },
    )

let hantFlock = hantHansMap -> Js.Dict.keys -> Js.Array2.joinWith("")

let toHans = (original: string) =>
  original
  -> Js.String2.unsafeReplaceBy0(
      Js.Re.fromStringWithFlags(`[${hantFlock}]`, ~flags="g"),
      (hant, _o, _w) => {
        let maybeHans = hantHansMap -> Js.Dict.get(hant)
        switch maybeHans {
          | Some(hans) => hans -> Js.String2.get(0)
          | _ => ""
        }
      }
    )
