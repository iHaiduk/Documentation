define(['jquery', 'hljs', 'Application/editor'], function($) {
  var _document;
  _document = $(document);
  return _document.ready(function() {
    var Menu;
    Menu = (function() {
      function Menu() {}

      Menu.prototype.init = function() {
        ({
          constructor: function() {
            return Menu.prototype.tree = null;
          }
        });
        return _document.find("#viewDoc").find("h1,h2").each(function() {

          /*if($(this)[0].tagName is "h1")
          
          else
           */
          return console.log($(this)[0].tagName);
        });
      };

      return Menu;

    })();
    return Menu.prototype.init();
  });
});
