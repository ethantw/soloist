#!/usr/bin/env node

import fs from 'fs'
import path from 'path'
import { build } from 'esbuild'
import Module from 'module'
import vm from 'vm'

import config from '../config.js'

// Get and remove script from argv
const argv = process.argv
let script = argv[2]

const cwd = process.cwd()

const watchFlag = argv.find (a => /^\-w=?\b/i.test (a)) ?? false
const watchTargets = watchFlag && (watchFlag.replace (/^\-w=?/i, '') || cwd).split (',')

// process.argv = process.argv.filter(function(_, i) {
//   return i !== 2;
// });

if (!script) {
  console.error('Error: No script provided.')
  process.exit(1)
}

// Check if script file exists
if (!script.match(/\.(ts|js)x?$/)) {
  ['ts', 'js', 'tsx', 'jsx'].find(ext => {
    if (fs.existsSync("./" + script + '.' + ext)) {
      script = script + '.' + ext
      return true
    }
  })
}

const __dirname = cwd
const __filename = cwd + '/' + script

if (!fs.existsSync("./" + script)) {
  throw new Error("No script found");
}

// Build

// Find all node modules to mark as external
const external = ['./src/*']

function findNodeModules(dir) {
  const moduleDir = path.join(dir, 'node_modules')

  if (fs.existsSync(moduleDir)) {
    const packages = fs.readdirSync(moduleDir)

    packages.forEach(function (p) {
      if (p.charAt(0) !== '.')
        external.push(p)
    })
  }

  const parent = path.dirname(dir)

  if (parent !== dir && fs.existsSync(parent)) {
    return findNodeModules(parent)
  }
}

findNodeModules(process.cwd())

// const __DEV__ = process.env.NODE_ENV === 'development'

const { outputFiles, rebuild } = await build ({
  ...config, 
  entryPoints: [__filename],
  write: false,
  platform: 'node',
  target: 'esnext',
  external,
  incremental: Boolean (watchFlag),
})

if (watchFlag) {
  watchTargets.map (t => fs.watch (
    t,
    { recursive: true },
    async (_, filename) => {
      const { outputFiles } = await rebuild ()

      if (/\/bin\//.test (filename)) {
        return
      }

      execScript ({ outputFiles })
    },
  ))
}

execScript ({ outputFiles })

function execScript ({ outputFiles = [] }) {
  const outputScript = outputFiles.find(f => path.basename (f.path) === path.basename (__filename))

  const dir = path.dirname(script)
  const scriptModule = new Module(dir)

  scriptModule.filename = script
  scriptModule.paths = Module._nodeModulePaths(dir)

  Object.assign(
    global,
    {
      __filename: script,
      __dirname: dir,
      exports: scriptModule.exports,
      module: scriptModule,
      require: scriptModule.require.bind(scriptModule),
    },
  )

  vm.runInThisContext(
    Buffer.from(outputScript.contents).toString('utf8'),
    { filename: script },
  )
}
