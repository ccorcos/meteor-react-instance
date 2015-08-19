Package.describe({
  name: 'ccorcos:react-instance',
  summary: 'React mixin to survive hot-reloads',
  version: '0.0.1',
  git: 'https://github.com/ccorcos/meteor-react-instance'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use([
    'coffeescript',
    'random',
    'react-runtime'
  ]);
  api.imply(['react-runtime'])
  api.addFiles([
    'react-instance.coffee',
    'globals.js'
  ], 'client');
  api.export([
    'saveReact',
    'ReactInstance',
    'InstanceMixin'
  ], 'client');
});
