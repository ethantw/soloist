let year =
  Js.Date.make()
  -> Js.Date.getFullYear
  -> Js.String2.make

let title =
  `陳奕鈞 ${year}・Chen Yijun’s Résumé ${year} `
  -> Js.String2.trim
  -> H.s

@react.component
let make = () =>
  <Helmet>
    <link rel="icon" href="/favicon.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <title>{ title }</title>
  </Helmet>
