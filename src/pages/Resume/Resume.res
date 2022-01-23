%%raw(`import clientScript from "./Resume.client.js"`)
%%raw(`import style from "./Resume.styl"`)

let css = Stylus.from(%raw("style"))
let script = %raw("clientScript") -> H.s

module Cheerio = {
  // Referred from:
  // https://forum.rescript-lang.org/t/typing-cheerio-js/2833/2

  type cheerio
  type element
  type selector
  type t<'a> = (. selector) => element

  @module("cheerio") external load: string => t<cheerio> = "load"

  external string: string => selector = "%identity"
  external element: element => selector = "%identity"

  @send external getHTML: t<cheerio> => string = "html"
  @send external getHTMLOfElement: element => string = "html"
  @send external setHTML: (element, string) => element = "html"

  @send external getText: element => string = "text"
  @send external setText: (element, string) => element = "text"

  @send external getAttr: (element, string) => string = "attr"
  @send external setAttr: (element, string, string) => element = "attr"

  @send external add: (element, string) => element = "add"
  @send external addClass: (element, string) => element = "addClass"
  @send external clone: (element) => element = "clone"

  @send external after: (element, string) => element = "after"
  @send external insertAfter: (element, element) => element = "insertAfter"
  @send external is: (element, string) => element = "is"

  @send external each: (element, (int, element) => element) => element = "each"
  @send external filter: (element, string) => element = "filter"
  @send external parent: (element, string) => element = "parent"
  @send external next: (element, string) => element = "next"
  @send external nextUntil: (element, string) => element = "nextUntil"
}

let mapDigitToZhChar = d => switch d {
  | `0` => `〇`
  | `1` => `一`
  | `2` => `二`
  | `3` => `三`
  | `4` => `四`
  | `5` => `五`
  | `6` => `六`
  | `7` => `七`
  | `8` => `八`
  | `9` => `九`
  | `10` => `十`
  | `11` => `十一`
  | `12` => `十二`
  | _ => ""
}

@@warning("-8") // TODO: find out why.
let formatDateInZh = (date: string) => {
  let ym: array<option<Js.String2.t>> = date -> Js.String2.splitByReAtMost(%re("/[月年]/g"), ~limit=2)

  let [yyyy, m] = switch ym {
    | [_, _] => ym
    | _ => [None, None]
  }

  let year = switch yyyy {
    | Some(yyyy) =>
      yyyy
      -> Js.String2.split("")
      -> Js.Array2.map(mapDigitToZhChar)
      -> Js.Array2.joinWith("")
      -> Js.String2.concat(`年`)
    | None => ""
  }

  let month = switch m {
    | Some(m) =>
      mapDigitToZhChar(m)
      -> Js.String2.concat(`月`)
    | None => ""
  }

  year ++ month
}

let year =
  Js.Date.make()
  -> Js.Date.getFullYear
  -> Js.String2.make

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

  { id: "dark--light", label: `深/淺模式`, lang: #zh, indeterminable: false },
  { id: "dark--light", label: `Dark/light mode`, lang: #en, indeterminable: false },
]

let toggles_by_id =
  toggles
  -> Belt.Array.reduce(
      Js.Dict.empty(),
      (acc, t) => {
        acc -> Js.Dict.set(t.id, t)
        acc
      },
    )

// 1. Deal with time periods:
//   a. Find all time periods and add classes;
//   b. Duplicate the time periods and insert them afterwards;
//   c. Format these time periods in comprehensible forms.
let getResumeHTML = () => {
  let resumePath = H.joinDocPaths("resume.md")
  let resumeMDHTML = lazy ({ Node.Fs.readFileSync(resumePath, #utf8) }) -> Lazy.force -> MarkdownIt.convert

  let c = Cheerio.load(`<article>${resumeMDHTML}</article>`)

  let _ =
    c(.Cheerio.string("p > time:only-child"))
    -> Cheerio.parent("p")
    -> Cheerio.addClass("period")
    -> Cheerio.each((_, elmt) => {
      let text = c(.Cheerio.element(elmt)) -> Cheerio.getText

      let zh =
        text
        -> Js.String2.split("/")
        -> Js.Array2.map(
          date => switch date {
            | "PRESENT" => `今`
            | date => date -> Js.Date.fromString -> DateFns.format(`yyyy年M月`) -> formatDateInZh
          }
        )
        -> Js.Array2.joinWith(`至`)
      
      let en =
        text
        -> Js.String2.split("/")
        -> Js.Array2.map(
          date => switch date {
            | "PRESENT" => "present"
            | date => date -> Js.Date.fromString -> DateFns.format(`MMMM yyyy`)
          }
        )
        -> Js.Array2.joinWith(` － `)

      c(.Cheerio.element(elmt))
      -> Cheerio.setHTML(`<time datetime="${text}">${zh}</time>`)
      -> Cheerio.after(`\n<p class='period'><time datetime="${text}">${en}</time></p>`)
    })

  // 2. Add `target="_blank"` to all links:
  let _ =
    c(.Cheerio.string("a:link"))
    -> Cheerio.setAttr("target", "_blank")
    -> Cheerio.setAttr("rel", "noopener noreferrer nofollow")

  // 3. Pairing all Chinese & English headings, paragraphs, etc:
  let blocks = c(.Cheerio.string("article > h1, h2, h3, h4, h5, h6, p, blockquote"))

  let _ =
    blocks
    -> Cheerio.filter(":nth-child(odd)")
    -> Cheerio.setAttr("lang", "zh-cmn-Hant")

  let _ =
    blocks
    -> Cheerio.filter(":nth-child(even)")
    -> Cheerio.setAttr("lang", "en")
  
  // 4. Convert to Simplified Chinese:
  let _hantBlocks =
    blocks
    -> Cheerio.filter(":nth-child(odd)")
    -> Cheerio.each((_i, elmt) => {

        let html =
          c(.Cheerio.element(elmt))
          -> Cheerio.getHTMLOfElement
          -> HantHans.toHans

        c(.Cheerio.element(elmt))
        -> Cheerio.clone
        -> Cheerio.setHTML(html)
        -> Cheerio.setAttr("lang", "zh-cmn-Hans")
        -> Cheerio.insertAfter(elmt)
      })

  // 5. The result:
  c(.Cheerio.string("article")) -> Cheerio.getHTMLOfElement
}

@react.component
let make = () => {
  <>
    <Helmet>
      <body className=`Résumé` />
      <link rel="icon" href="/favicon.ico" />
      <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
      <title>{ H.s(`陳奕鈞的簡歷・Chen Yijun’s Résumé`) }</title>

      <style>{ css }</style>
      <script>{ script }</script>
    </Helmet>

    /* Real toggles behind the scene */
    {
      toggles_by_id
      -> Js.Dict.values
      -> Belt.Array.map(
          ({ id, indeterminable }) => switch indeterminable {
            | true  => <input type_="checkbox" hidden={true} id={id} key={id} className="indeterminable" />
            | false => <input type_="checkbox" hidden={true} id={id} key={id} />
          }
        )
      -> React.array
    }

    /* Page header: */
    <header>
      <ul>
        {
          toggles
          -> Belt.Array.map(({ id, lang, label, indeterminable }) =>
            switch lang {
              | #inherit =>
                <li key={id} className={id}>
                  <label htmlFor={id} className={indeterminable ? "indeterminable" : ""}>
                    { H.s(label) }
                    <Toggle />
                  </label>
                </li>
              | _ =>
                <li key={id ++ (lang :> string)} lang={lang :> string} className={id}>
                  <label htmlFor={id} className={indeterminable ? "indeterminable" : ""}>
                    { H.s(label) }
                    <Toggle />
                  </label>
                </li>
            }
          )
          -> React.array
        }

        <li><button>{ H.s(`列印`) }</button></li>
        <li lang="en"><button>{ H.s(`Print`) }</button></li>
      </ul>
    </header>

    /* Main content: */
    <main>
      <article dangerouslySetInnerHTML={{ "__html": getResumeHTML() }} />

      <address>
        <h1 lang="zh">{ H.s(`聯繫方式`) }</h1>
        <h1 lang="en">{ H.s(`Contact`) }</h1>

        <dl>
          <dt lang="zh">{ H.s(`信箱`) }</dt>
          <dt lang="en">{ H.s(`Email`) }</dt>
            <dd><Link to="mailto:ethantw@me.com">{ H.s("ethantw@me.com") }</Link></dd>

          <dt lang="en">{ H.s(`GitHub`) }</dt>
            <dd><Link target="_blank" to="//github.com/ethantw">{ H.s("github.com/ethantw") }</Link></dd>

          <dt lang="zh">{ H.s(`個人首頁`) }</dt>
          <dt lang="en">{ H.s(`Homepage`) }</dt>
            <dd><Link target="_blank" to="//yijun.me">{ H.s("Yijun.me") }</Link></dd>

          <dt lang="zh">{ H.s(`手機`) }</dt>
          <dt lang="en">{ H.s(`Mobile`) }</dt>
            <dd><Link to="tel:+88697827****">{ H.s("+886-978-27****") }</Link></dd>
        </dl>
      </address>
    </main>

    /* Page footer: */
    <footer>
      <p hidden={true}>{ H.s(`© ${year}`) }</p>
    </footer>
  </>
}
