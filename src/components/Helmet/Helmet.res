@react.component
@module("react-helmet")
external make: (
  ~defaultTitle: string=?,
  ~titleTemplate: string=?,
  ~children: React.element=?,
) => React.element = "Helmet"

type helmetProp = {
  "toComponent": unit => React.element,
  "toString": unit => string,
}

type helmet = {
  "base": helmetProp,
  "bodyAttributes": helmetProp,
  "htmlAttributes": helmetProp,
  "link": helmetProp,
  "meta": helmetProp,
  "noscript": helmetProp,
  "script": helmetProp,
  "style": helmetProp,
  "title": helmetProp,
}

@module("react-helmet")
@scope("Helmet") external renderStatic: () => helmet = "renderStatic"
