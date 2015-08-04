
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
        var _elements;
        _elements = Redactor.prototype.elements;
        Redactor.prototype.loadRedactors();
        _elements.on('mousedown mouseup', function(event) {
          if (event.type === 'mousedown') {
            Redactor.prototype.position.start.y = event.pageY;
            Redactor.prototype.position.start.x = event.pageX;
          } else {
            Redactor.prototype.position.end.y = event.pageY;
            Redactor.prototype.position.end.x = event.pageX;
          }
        }).on('click', function() {
          var readTop, toolbar;
          if (window.getSelection().type === 'Range') {
            toolbar = $(this).prev();
            readTop = Redactor.prototype.position.start.y < Redactor.prototype.position.end.y ? 'start' : 'end';
            if (toolbar.is(':visible')) {
              toolbar.stop().animate({
                top: Redactor.prototype.position[readTop].y - ($(this).offset().top) - toolbar.height - 15 + 'px',
                left: Math.abs(Redactor.prototype.position.start.x + Redactor.prototype.position.end.x) / 2 - ($(this).offset().left) - (toolbar.width() / 2) + 'px',
                opacity: 1
              }, 150);
            } else {

            }
            toolbar.stop().fadeIn(400).css({
              top: Redactor.prototype.position[readTop].y - ($(this).offset().top) - 60 + 'px',
              left: Math.abs(Redactor.prototype.position.start.x + Redactor.prototype.position.end.x) / 2 - ($(this).offset().left) - (toolbar.width() / 2) + 'px'
            });
          } else {
            _elements.parent().find('.redactor-toolbar').hide();
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
            plugins: ['highlight'],
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
      return Redactor;
    })();
    redactor = new Redactor(_docum, '.sub-section');
    redactor.init();
  });
});
