var lion = require('./lion');
var fs = require('fs');

file = fs.readFileSync('./main.lion', 'utf8');
ast = lion.parse(file);

var jsFunctions = []
ast.forEach(function(func) {
  var name = func['header'];
  var params = func['params'];
  var stmts = func['body'];

  var jsFunction = 'function ' + name + ' (' + params + ') {'
  stmts.forEach(function(stmt) {
    jsFunction += stmt + ';';
  });
  jsFunction += '}';
  jsFunctions.push(jsFunction);
});
