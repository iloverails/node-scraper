$(function () {
  var JST = window.JST = window.JST || new Object;
  var root = "../templates/";
  JST.fetch = function (path, cb) {
    // Initialize done for use in async-mode
    var done;

    // Concatenate the file extension.
    path = path + ".ejs";

    // If cached, use the compiled template.
    if (JST[path]) {
      return cb(JST[path]);
    } else {
      $.ajax({ url:root + path }).then(function (contents) {
        JST[path] = _.template(contents)
        cb(JST[path]);
      });
    }
  }
})
