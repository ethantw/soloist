
module Fs = {
  type o = { recursive: bool, force: bool }
  type p = { flag: string, encoding: string }

  @module("fs") external rmSync: (string, o) => unit = "rmSync"
  @module("fs") external mkdirSync: (string, o) => unit = "mkdirSync"
  @module("fs") external writeFileSync: (string, string, p) => unit = "writeFileSync"
  @module("fs") external copyFileSync: (string, string) => unit = "copyFileSync"
}

// 1. Clean up the `/public` directory:
Fs.rmSync(H.outputPath, { recursive: true, force: true })

// 2. Parsing, building and creating content pages:
let _ =
  Router.routes
  -> Belt.Array.map(({ path, content, to }) => {
      let content = switch (content, to) {
        | (Some(content), _) => content
        | (None, Some(to)) => <Redirect to />
        | (None, None) => <></>
      }

      let raw = content -> ReactDOMServer.renderToStaticMarkup
      let helmet = Helmet.renderStatic()

      let htmlAttr = helmet["htmlAttributes"]["toString"]()
      let bodyAttr = helmet["bodyAttributes"]["toString"]()

      let html = switch htmlAttr {
        | "" => `<html>`
        | _  => `<html ${htmlAttr}>`
      }

      let body =  switch bodyAttr {
        | "" => `<body>`
        | _  => `<body ${bodyAttr}>`
      }

      let cooked =
`<!DOCTYPE html>
${html}
<head>
  <meta charset="UTF-8" />
  ${ helmet["meta"]["toString"]() }
  ${ helmet["title"]["toString"]() }
  ${ helmet["base"]["toString"]() }
  ${ helmet["link"]["toString"]() }
  ${ helmet["script"]["toString"]() }
  ${ helmet["style"]["toString"]() }
</head>
${body}
${ raw -> Js.String2.trim }
</body>
</html>`

      H.joinOutputPaths(path) -> Fs.mkdirSync({ recursive: true, force: false })
      H.joinOutputPaths(`${path}/index.html`) -> Fs.writeFileSync(cooked, { flag: "wx", encoding: "utf8" })

      H.joinAssetsPaths(`favicon.svg`) -> Fs.copyFileSync(H.joinOutputPaths(`favicon.svg`))
    })
