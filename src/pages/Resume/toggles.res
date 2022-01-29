type toggle = {
  id: string,
  label: string,
  lang: [#zh | #en | #inherit],
  indeterminable: bool,
}

let toggles: Js.Array.t<toggle> = [
  { id: "zh--en", label: `中文/English`, lang: #inherit, indeterminable: true },
  { id: "hant--hans", label: `繁/简`, lang: #zh, indeterminable: false },

  { id: "sans-serif--serif", label: `方體/宋體`, lang: #zh, indeterminable: false },
  { id: "sans-serif--serif", label: `Sans-serif/serif`, lang: #en, indeterminable: false },

  // { id: "f-left--justified", label: `Flush left/justified`, lang: #en, indeterminable: false },
  // { id: "horizontal--vertical", label: `橫排/縱排`, lang: #zh, indeterminable: false },

  { id: "light--dark", label: `深/淺模式`, lang: #zh, indeterminable: false },
  { id: "light--dark", label: `Dark/light mode`, lang: #en, indeterminable: false },
]

let togglesById =
  toggles
  -> H.fold(
      Js.Dict.empty(),
      (acc, t) => {
        acc -> Js.Dict.set(t.id, t)
        acc
      },
    )