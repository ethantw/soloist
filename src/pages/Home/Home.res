%%raw(`import style from "./Home.styl"`)
let css = Stylus.from(%raw("style"))

type character = {
  char: string,
  lang: string,
  latn: string,
  name: string,
}

let chars: Js.Array.t<character> = [
  { char: `字`, latn: `zi`, name: "", lang: "" },
  { char: `民`, latn: `min`, name: "", lang: "" },
  { char: `山`, latn: `shan`, name: "", lang: "" },
  { char: `糸`, latn: `mi`, name: "", lang: "" },
  { char: `辶`, latn: `chuo`, name: "", lang: "" },
  { char: `「`, latn: `open`, name: `open-quote`, lang: "" },
  { char: `、`, latn: "", name: `secondary-comma`, lang: "" },
  { char: `，`, latn: "", name: `comma`, lang: "" },
  { char: `。`, latn: "", name: `period`, lang: "" },
  { char: `》`, latn: "", name: `book-title-mark`, lang: "" },
  { char: `”`, latn: "", name: `close-quote`, lang: "" },
  { char: `じ`, lang: `ja`, latn: `ji`, name: "" },
  { char: `자`, lang: `kr`, latn: `ja`, name: "" },
  { char: `𡦂`, lang: `vi-hani`, latn: `chu`, name: "" },
]

@react.component
let make = () =>
  <>
    <Helmet>
      <body className=`Home` />
      <link rel="icon" href="/favicon.svg" />
      <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
      <title>{ H.s(`陳奕鈞・Chen Yijun`) }</title>

      <style>{ css }</style>
    </Helmet>
    <article>
      <main>
        <h1>
          <span className="family-name">{ H.s(`陳`) }</span>
          <span className="given-name">{ H.s(`奕鈞`) }</span>
          <span lang="cmn-Latn">{ H.s(`Chen Yijun`) }</span>
          <span hidden={true} lang="nan-Latn">{ H.s(`Tan I-kun`) }</span>
        </h1>

        <section className="contacts">
          <h2>
            { H.s(`聯絡方式`) }
            <span lang="en">{ H.s(`Contacts`) }</span>
          </h2>

          <ul>
            <li>
              <a
                href="mailto:%65th%61%6e%74&#119;@%6de&#46;com"
                dangerouslySetInnerHTML={{ "__html": `&#x65;thantw&#x40;m&#x65;.com` }}
              />
            </li>
            <li>
              <a href="//yijun.me/">
                <span className="protocol">{ H.s(`https://`) }</span>
                <span className="domain">{ H.s(`Yijun.me`) }</span>
              </a>
            </li>
          </ul>
        </section>

        <section className="titles">
          <h2>
            { H.s(`抬頭`) }
            <span lang="en">{ H.s(`Titles`) }</span>
          </h2>

          <ul>
            <li>
              { H.s(`字體排印`) }
              <span lang="en">{ H.s(`Typographer`) }</span>
            </li>

            <li>
              { H.s(`前端開發`) }
              <span lang="en">{ H.s(`Front-end web developer`) }</span>
            </li>
          </ul>
        </section>
      </main>

      <section className="characters" role="presentation">
        <h2>
          { H.s(`字和偏旁的裝置藝術`) }
          <span lang="en">{ H.s(`Artwork made of characters & radicals`) }</span>
        </h2>

        <ul>
        {
          chars
          -> Belt.Array.map(({ char, lang, latn, name }) =>
            React.cloneElement(
              <li lang key={char}>{ H.s(char) }</li>,
              { "data-latn": latn, "data-name": name },
            )
          )
          -> React.array
        }
        </ul>
      </section>
    </article>
  </>
