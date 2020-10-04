const context = require.context(".", true, /\.(js|ts)$/)
context.keys().forEach(context)
