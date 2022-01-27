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
