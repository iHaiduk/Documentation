
/**
 * Created by Igor on 02.08.2015.
 */
var app;

app = {
  path: "../"
};

require.config({
  paths: {
    "jquery": "Library/jquery.min",
    "hljs": "Library/highlight.pack",
    "redactor": "Library/redactor"
  },
  shim: {
    "jquery": {
      exports: "$"
    },
    "redactor": {
      deps: ["jquery"]
    }
  }
});

this.loadApplication = function(name) {
  requirejs(["jquery", "hljs", "redactor"], function($, hljs) {
    require(["Application/app"]);
    require(["Application/site"]);
  });
};
