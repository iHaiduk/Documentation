define(['jquery', 'Application/editor'], function($) {
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
        Menu.prototype.lock = false;
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
          Menu.prototype.offsetTop();
        }).off('mousewheel').on('mousewheel', function() {
          $(window).stop();
        });
        return this;
      };

      Menu.prototype.fixed = function() {
        var top;
        top = $(window).scrollTop();
        _document.find(".header.cf").toggleClass('shadow', top > 0);
        Menu.prototype.navigation.find("ul.nav").css({
          'margin-top': top + 'px'
        });
      };

      Menu.prototype.addBottomPadding = function() {
        var arr, summ;
        return;
        arr = jQuery.grep(_document.find("#viewDoc").find("sup,sub"), function(val) {
          return true;
        });
        summ = $(arr[arr.length - 1]).parents(".section").height();
        $(arr[arr.length - 1]).parents(".section").nextAll(".section").each(function() {
          return summ += $(this).height();
        });
        _document.find(".right-side").css({
          "padding-bottom": $(window).height() - summ - _document.find(".header").outerHeight() - _document.find(".footer").outerHeight() - 31 + "px"
        });
      };

      Menu.prototype.treeGenerate = function() {
        Menu.prototype.tree = [];
        Menu.prototype.lastIdHeading = -1;
        Menu.prototype.HeadingCnt = 0;
        Menu.prototype.MenuHeadingCnt = 0;
        _document.find("#viewDoc").find("sup,sub").each(function() {
          if ($(this)[0].tagName.toLowerCase() === "sup") {
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
        Menu.prototype.addBottomPadding();
        Menu.prototype.listens();
      };

      Menu.prototype.listens = function() {
        Menu.prototype.navigation.find('.nav-item').off('click').on('click', function(e) {
          Menu.prototype.lock = true;
          Menu.prototype.navigation.find(".active").removeClass('active');
          $("html, body").stop().animate({
            scrollTop: _document.find("#" + $(this).data().id).offset().top - _document.find(".header").height() - 58
          }, 500, function() {
            Menu.prototype.lock = false;
          });
          $(this).parent().addClass('active').parents(".nav-list").addClass('active');
        });
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
          htmlMenu += "</ul>";
        }
        return htmlMenu;
      };

      Menu.prototype.offsetTop = function() {
        var arr;
        if (Menu.prototype.lock) {
          return;
        }
        arr = jQuery.grep(_document.find("#viewDoc").find("sup,sub"), function(val) {
          return $(val).offset().top - $(window).scrollTop() - _document.find(".header").height() >= 0;
        });
        if (arr.length) {
          Menu.prototype.navigation.find(".active").removeClass('active');
          if (arr[0].tagName.toLowerCase() === "sup") {
            Menu.prototype.navigation.find(".nav > .nav-list").eq(_document.find("#viewDoc").find("sup").index($(arr[0]))).addClass('active');
          } else {
            Menu.prototype.navigation.find(".sub-nav > .nav-list").eq(_document.find("#viewDoc").find("sub").index($(arr[0]))).addClass('active').parents(".nav-list").addClass('active');
          }
        }
      };

      return Menu;

    })();
    menu = new Menu();
    return app.Menu = menu.init();
  });
});
