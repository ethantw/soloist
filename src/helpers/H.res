// Helper functions
// ================

let fold = Belt.Array.reduce
let s = React.string

let joinDocPaths = path => Node.Path.join([Node.Process.cwd(), "./mds", path])
let joinSrcPaths = path => Node.Path.join([Node.Process.cwd(), "./src", path])
let joinOutputPaths = path => Node.Path.join([Node.Process.cwd(), "./docs", path])
let joinAssetsPaths = path => Node.Path.join([Node.Process.cwd(), "./src/assets", path])
let joinPackagePaths = path => Node.Path.join([Node.Process.cwd(), "./node_modules", path])

let srcPath = joinSrcPaths("")
let outputPath = joinOutputPaths("")
