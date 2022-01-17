// Derived from:
// https://github.com/enspirit/rescript-markdown-it

@deriving(abstract)
type options = {
  @optional html: bool,
  @optional linkify: bool,
  @optional typographer: bool
}

type tMarkdownIt
@new @module("markdown-it") external createMarkdownIt: (~options: options=?, unit) => tMarkdownIt = "default"
let createMarkdownIt = (~html: bool=false, ()) => {
  createMarkdownIt(~options=options(~html, ()), ())
}
@send external render: (tMarkdownIt, string) => string = "render"
let convert = (md: string) => render (createMarkdownIt(~html=true, ()), md)