
/**
 * Created by Igor on 02.08.2015.
 */
define(['jquery', 'hljs', 'redactor'], function($, hljs) {
  var _docum;
  _docum = $(document);
  _docum.ready(function() {
    var Redactor, redactor;
    $.Redactor.prototype.highlight = function() {
      return {
        save: function() {
          var html;
          html = this.code.get();
          console.log(html);
        },
        init: function() {
          var button;
          button = this.button.add('bold', 'Insert Code');
          this.button.addCallback(button, this.highlight.code);
        },
        code: function() {
          this.inline.format('pre', 'class', 'code');
        }
      };
    };
    Redactor = (function() {
      var Redactor;
      Redactor = function(document, nameElement) {
        Redactor.prototype.document = document;
        Redactor.prototype.nameElement = nameElement;
        Redactor.prototype.elements = document.find(nameElement);
        Redactor.prototype.activeElement = null;
        Redactor.prototype.position = {
          start: {
            x: 0,
            y: 0
          },
          end: {
            x: 0,
            y: 0
          }
        };
      };
      Redactor.prototype.init = function() {
        $(window).on("resize", function() {});
        Redactor.prototype.document.find("#initRedactor").off('click').on('click', function() {
          var _elements;
          if ($(this).hasClass("btn-edit")) {
            $(this).removeClass("btn-edit").addClass("btn-save");
            _elements = Redactor.prototype.elements;
            Redactor.prototype.loadRedactors();
            _elements.off('mousedown mouseup').on('mousedown mouseup', function(event) {
              if (event.type === 'mousedown') {
                Redactor.prototype.position.start.y = event.pageY;
                Redactor.prototype.position.start.x = event.pageX;
              } else {
                Redactor.prototype.position.end.y = event.pageY;
                Redactor.prototype.position.end.x = event.pageX;
              }
            }).off('click').on('click', function() {
              var toolbar;
              if (window.getSelection().type === 'Range') {
                toolbar = $(this).prev();
                Redactor.prototype.toolbarPosition(toolbar);
              } else {
                _elements.parent().find('.redactor-toolbar').hide();
              }
            });
          } else {
            $(this).removeClass("btn-save").addClass("btn-edit");
            return Redactor.prototype.save();
          }
        });
      };
      Redactor.prototype.loadRedactors = function() {
        Redactor.prototype.elements.each(function() {
          Redactor.prototype.addRedactor($(this));
        });
      };
      Redactor.prototype.addRedactor = function(element) {
        var _elements;
        if (element != null) {
          _elements = Redactor.prototype.elements;
          element.redactor({
            iframe: true,
            cleanStyleOnEnter: false,
            linebreaks: true,
            formatting: ['p', 'blockquote', 'h1', 'h2'],
            buttons: ['formatting', 'bold', 'italic', 'deleted', 'link', 'alignment'],
            plugins: ['formatting', 'bold', 'italic', 'deleted', 'unorderedlist', 'orderedlist', 'link', 'alignment'],
            initCallback: function() {
              element.off('click');
              Redactor.prototype.activeElement = element;
            },
            blurCallback: function(e) {
              _elements.parent().find('.redactor-toolbar').stop().fadeOut(400);
            },
            keydownCallback: function(e) {

              /*e.preventDefault()
              console.log e.keyCode
              false
               */
            }
          });
        }
      };
      Redactor.prototype.removeRedactor = function(element) {
        if (element != null) {
          element.redactor('core.destroy');
        }
      };
      Redactor.prototype.save = function(element) {
        return Redactor.prototype.elements.redactor("core.destroy");
      };
      Redactor.prototype.toolbarPosition = function(toolbar) {
        var readTop;
        readTop = Redactor.prototype.position.start.y < Redactor.prototype.position.end.y ? 'start' : 'end';
        if (toolbar.is(':visible') && (toolbar.next().offset() != null)) {
          toolbar.stop().animate({
            top: Redactor.prototype.position[readTop].y - (toolbar.next().offset().top) - toolbar.height - 15 + 'px',
            left: Math.abs(Redactor.prototype.position.start.x + Redactor.prototype.position.end.x) / 2 - (toolbar.next().offset().left) - (toolbar.width() / 2) + 'px',
            opacity: 1
          }, 150);
        } else {
          if (toolbar.next().offset() != null) {
            toolbar.stop().fadeIn(400).css({
              top: Redactor.prototype.position[readTop].y - (toolbar.next().offset().top) - 60 + 'px',
              left: Math.abs(Redactor.prototype.position.start.x + Redactor.prototype.position.end.x) / 2 - (toolbar.next().offset().left) - (toolbar.width() / 2) + 'px'
            });
          }
        }
      };
      return Redactor;
    })();
    redactor = new Redactor(_docum, '.sub-section');
    redactor.init();
  });
});
