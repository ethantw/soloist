@react.component
let make = (~to: string, ~target: option<string>=?, ~children: React.element) => {
  switch target {
  | Some("_blank") => <a target="_blank" rel={"noopener noreferrer nofollow"} href={to}>children</a>
  | Some(target) => <a target={Belt.Option.getExn(Some(target))} href={to}>children</a>
  | _ => <a href={to}>children</a>
  }
}