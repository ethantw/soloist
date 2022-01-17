@react.component
let make = (~to) =>
  <Helmet>
    <meta httpEquiv="refresh" content=`0; url=${to}` />
  </Helmet>
