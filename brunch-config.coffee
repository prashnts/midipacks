# noop.pw
global.DEBUG = '-p' not in global.process.argv

module.exports = config:
  paths:
    watched: ['client']

  plugins:
    autoReload:
      enabled: yes

  npm:
    enabled: yes

  modules:
    nameCleaner: (path) ->
      path
        .replace /^client\//, ''
        .replace /\.coffee/, ''

  files:
    javascripts:
      joinTo: 'js/app.js'
