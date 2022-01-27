@react.component
let make = (~name: string) => {
  let path = H.joinAssetsPaths(`/icons/${name}.svg`)
  let raw = lazy ({ Node.Fs.readFileSync(path, #utf8) }) -> Lazy.force

  let c = raw -> Cheerio.load
  let svg = c(. Cheerio.string("svg"))

  let viewBox = svg -> Cheerio.getAttr("viewBox")
  let innerHTML = svg -> Cheerio.getHTMLOfElement

   React.cloneElement(
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox={viewBox}
      dangerouslySetInnerHTML={{ "__html": innerHTML }}
      className="Icon"
    />,
    { "data-icon": name },
  )
}
