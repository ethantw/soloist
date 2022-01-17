type stylus
type error
type callback = (Js.null<error>, string) => unit

@module("stylus") external load: string => stylus = "default"
@send external \"import": (stylus, string) => stylus = "import"
@send external render: (stylus, callback) => unit = "render"

let cooked = ""

let normalizeCSSPath = H.joinPackagePaths("normalize.css/normalize.css")
let normalizeCSS = lazy ({ Node.Fs.readFileSync(normalizeCSSPath, #utf8) }) -> Lazy.force

@@warning("-27")
let from = raw => {
  (normalizeCSS ++ raw)
  -> load
  //-> \"import"(H.joinPackagePaths("normalize.css/normalize.css"))
  -> render((err, css) => switch Js.Null.toOption(err) {
      | None => %raw(`cooked = css`)
      | _ => Js.Console.error(err)
    })

  cooked -> H.s
}
