define(['jquery', 'hljs', 'Application/editor'], function($) {
  var _document;
  _document = $(document);
  return _document.ready(function() {
    var Menu, menu;
    Menu = (function() {
      function Menu() {
        Menu.prototype.tree = [];
        Menu.prototype.lastIdHeading = -1;
        Menu.prototype.HeadingCnt = 0;
        Menu.prototype.MenuHeadingCnt = 0;
        Menu.prototype.navigation = _document.find("#navigation");
        Menu.prototype.activeElement = {
          element: null,
          position: -1
        };
      }

      Menu.prototype.init = function() {
        Menu.prototype.treeGenerate();
        Menu.prototype.addBottomPadding();
        $(window).off('scroll').on('scroll', function() {
          Menu.prototype.fixed();
          return Menu.prototype.offsetTop();
        });
        return this;
      };

      Menu.prototype.fixed = function() {
        var top;
        top = $(window).scrollTop();
        _document.find(".header.cf").toggleClass('shadow', top > 0);
        return Menu.prototype.navigation.find("ul.nav").css({
          'margin-top': top + 'px'
        });
      };

      Menu.prototype.addBottomPadding = function() {
        var arr;
        arr = jQuery.grep(_document.find("#viewDoc").find("h1,h2"), function(val) {
          return $(val).offset().top - $(window).scrollTop() - _document.find(".header.cf").height() >= 0;
        });
        console.group();
        console.log("window", $(window).height());
        console.log("offset", $(arr[arr.length - 1]).offset().top);
        console.log("scrollTop", $(window).scrollTop());
        console.log("---- scrollTop", $(arr[arr.length - 1]).offset().top - $(window).scrollTop());
        console.log("outerHeight", _document.find(".header.cf").outerHeight());
        console.log("footer", _document.find(".footer").outerHeight());
        console.log("outerHeight", $(arr[arr.length - 1]).outerHeight());
        console.log("arr", $(arr[arr.length - 1]));
        return console.groupEnd();

        /*_document.find("#viewDoc").css(
          "padding-bottom": ($(arr[arr.length-1]).offset().top-$(window).scrollTop()) + (_document.find(".header").height()) + (_document.find(".footer").height()) + ($(arr[arr.length-1]).outerHeight()) + "px"
        )
         */
      };

      Menu.prototype.treeGenerate = function() {
        Menu.prototype.tree = [];
        Menu.prototype.lastIdHeading = -1;
        Menu.prototype.HeadingCnt = 0;
        Menu.prototype.MenuHeadingCnt = 0;
        _document.find("#viewDoc").find("h1,h2").each(function() {
          if ($(this)[0].tagName.toLowerCase() === "h1") {
            Menu.prototype.lastIdHeading++;
            Menu.prototype.tree.push({
              element: $(this).attr("id", "header" + Menu.prototype.HeadingCnt),
              text: $(this).text(),
              child: []
            });
            Menu.prototype.HeadingCnt++;
          } else {
            if (Menu.prototype.lastIdHeading > -1) {
              Menu.prototype.tree[Menu.prototype.lastIdHeading].child.push({
                element: $(this).attr("id", "header" + Menu.prototype.HeadingCnt),
                text: $(this).text(),
                active: false
              });
              Menu.prototype.HeadingCnt++;
            }
          }
        });
        Menu.prototype.navigation.html(Menu.prototype.treeHTMLGenerate());
        Menu.prototype.fixed();
        Menu.prototype.offsetTop();
        Menu.prototype.listen();
        Menu.prototype.addBottomPadding();
      };

      Menu.prototype.treeHTMLGenerate = function(arrMenu, sub) {
        var htmlMenu;
        if (arrMenu == null) {
          arrMenu = Menu.prototype.tree;
        }
        if (sub == null) {
          sub = false;
        }
        htmlMenu = "";
        if ((arrMenu != null) && arrMenu.length) {
          htmlMenu += "<ul class='" + (sub ? "sub-nav" : "nav") + "'>";
          arrMenu.forEach(function(val) {
            htmlMenu += "<li class='nav-list'>\n    <a class='nav-item" + ((val.child != null) && val.child.length ? " parent" : "") + "' href=\"javascript:void(0)\" data-id='header" + Menu.prototype.MenuHeadingCnt + "'>" + val.text + "<span class='slide-arrow'></span></a>";
            Menu.prototype.MenuHeadingCnt++;
            if ((val.child != null) && val.child.length) {
              htmlMenu += Menu.prototype.treeHTMLGenerate(val.child, true);
            }
            return htmlMenu += "</li>";
          });
          return htmlMenu += "</ul>";
        }
      };

      Menu.prototype.listen = function() {
        Menu.prototype.navigation.find(".nav-item").off('click').on('click', function() {
          $("html, body").stop().animate({
            scrollTop: _document.find("#" + $(this).data().id).offset().top - _document.find(".header").height() - 28
          }, 500);
        });
      };

      Menu.prototype.offsetTop = function() {
        var arr;
        arr = jQuery.grep(_document.find("#viewDoc").find("h1,h2"), function(val) {
          return $(val).offset().top - $(window).scrollTop() - _document.find(".header").height() >= 0;
        });
        if (arr.length) {
          Menu.prototype.navigation.find(".active").removeClass('active');
          if (arr[0].tagName.toLowerCase() === "h1") {
            return Menu.prototype.navigation.find(".nav > .nav-list").eq(_document.find("#viewDoc").find("h1").index($(arr[0]))).addClass('active');
          } else {
            return Menu.prototype.navigation.find(".sub-nav > .nav-list").eq(_document.find("#viewDoc").find("h2").index($(arr[0]))).addClass('active').parents(".nav-list").addClass('active');
          }
        }
      };

      return Menu;

    })();
    menu = new Menu();
    return app.Menu = menu.init();
  });
});
