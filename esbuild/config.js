import { stylusLoader } from 'esbuild-stylus-loader'

const __DIST__ = 'public'

const config = {
  charset: 'utf8',

  bundle: true,

  loader: {
    '.js': 'jsx',
    '.jpg': 'file',
    '.png': 'file',
    '.svg': 'text',
    '.woff2': 'file',
    '.styl': 'text',
    '.client.js': 'text',
  },

  assetNames: 'assets/[name].[hash]',
  chunkNames: 'vendors/[hash]',
  publicPath: '/',
  sourcemap: true,

  define: { 'process.env.NODE_ENV': `"${process.env.NODE_ENV}"` },

  outdir: __DIST__,

  plugins: [],
}

export default config
