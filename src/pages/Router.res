type route = {
  path: string,
  content: option<React.element>,
  to: option<string>,
}

let routes: array<route> = [
  // Home:
  { path: `/`, content: Some(<></>), to: None },

  // Résumé:
  { path: `/résumé`, content: Some(<Resume />), to: None },
  { path: `/resume`, to: Some(`/résumé`), content: None },
  { path: `/cv`, to: Some(`/résumé`), content: None },
]