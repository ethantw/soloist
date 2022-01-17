%%raw(`import toggleSVG from "./toggle.svg"`)
let svg = %raw(`toggleSVG`) -> Js.String2.trim

let openTag = {
  let ms = svg -> Js.String2.match_(%re(`/^<svg.*>/i`))

  switch ms {
    | Some(ms) => ms[0]
    | _ => ""
  }
}

let innerHTML =
  svg
  -> Js.String2.replace(openTag, "")
  -> Js.String2.replaceByRe(%re(`/<\/svg>$/i`), "")

let viewBox = {
  let attrMs = openTag -> Js.String2.match_(%re(`/\bviewBox="(.*?)"/i`))
  switch attrMs {
    | Some(attrMs) => attrMs[1]
    | _ => "0 0 0 0"
  }
}

@react.component
let make = () => {
  React.cloneElement(
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox={viewBox}
      dangerouslySetInnerHTML={{ "__html": innerHTML }}
      className="Icon"
    />,
    { "data-icon": "toggle" },
  )
}