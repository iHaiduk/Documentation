
/**
 * Created by Igor on 02.08.2015.
 */
define(['jquery', 'codemirror', 'redactor', 'Application/menu', 'codemirror/mode/htmlmixed/htmlmixed', 'codemirror/mode/clike/clike', 'codemirror/mode/coffeescript/coffeescript', 'codemirror/mode/css/css', 'codemirror/mode/javascript/javascript', 'codemirror/mode/php/php', 'codemirror/mode/sass/sass', 'codemirror/mode/sql/sql', 'codemirror/mode/xml/xml'], function($, CodeMirror) {
  var _docum;
  _docum = $(document);
  _docum.ready(function() {
    var Redactor, redactor;
    $.Redactor.prototype.insertHead = function() {
      return {
        init: function() {
          var button, button2;
          button = this.button.add('header1');
          this.button.setAwesome('insertHead', 'fa-h1');
          this.button.addCallback(button, this.insertHead.insertH1);
          button2 = this.button.add('header2');
          this.button.setAwesome('insertHead', 'fa-h2');
          this.button.addCallback(button2, this.insertHead.insertH2);
        },
        insertH1: function(html) {
          if (this.selection.getParent() && $(this.selection.getParent())[0].tagName.toLowerCase() === 'head2') {
            this.inline.format('head2');
          }
          this.selection.restore();
          this.inline.format('head1');
        },
        insertH2: function(html) {
          if (this.selection.getParent() && $(this.selection.getParent())[0].tagName.toLowerCase() === 'head1') {
            this.inline.format('head1');
          }
          this.selection.restore();
          this.inline.format('head2');
        }
      };
    };
    Redactor = (function() {
      function Redactor(document, nameElement) {
        Redactor.prototype.redactor = null;
        Redactor.prototype.document = document;
        Redactor.prototype.nameElement = nameElement;
        Redactor.prototype.elements = document.find(nameElement);
        Redactor.prototype.activeElement = null;
        Redactor.prototype.CodeMirror = null;
        Redactor.prototype.lastFocus = null;
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
      }

      Redactor.prototype.init = function() {
        Redactor.prototype.document.find("#initRedactor").off('click').on('click', function() {
          if ($(this).hasClass("btn-edit")) {
            $(this).removeClass("btn-edit").addClass("btn-save");
            $("body").addClass("editing");
            Redactor.prototype.reset();
            Redactor.prototype.initialize();
            Redactor.prototype.showPlusButton();
          } else {
            $(this).removeClass("btn-save").addClass("btn-edit");
            $("body").removeClass("editing");
            Redactor.prototype.save();
          }
        });
        Redactor.prototype.addListen();
      };

      Redactor.prototype.reset = function() {
        Redactor.prototype.elements.find(".code").removeClass().addClass("code").each(function() {
          $(this).text($(this).text());
        });
      };

      Redactor.prototype.addListen = function() {
        Redactor.prototype.document.find(".media-toolbar").off('click').on('click', function() {
          $(this).addClass("open");
        });
        Redactor.prototype.document.find('.btn-toggle').off('click').on('click', function() {
          $(this).toggleClass('open');
        });
        Redactor.prototype.document.find('.icon-code').off('click').on('click', function() {
          Redactor.prototype.mediaButton($(this), "code", "<textarea class='code'></textarea>", function(element) {
            Redactor.prototype.CodeMirror = CodeMirror.fromTextArea(element[0], {
              mode: "javascript",
              lineNumbers: true,
              matchBrackets: true,
              styleActiveLine: true,
              theme: "monocai",
              lineNumbers: true,
              viewportMargin: Infinity
            });
          });
        });
        Redactor.prototype.document.find('.icon-hr').off('click').on('click', function() {
          Redactor.prototype.mediaButton($(this), "hr", "<hr/>");
        });
        Redactor.prototype.document.find('.remove').off('click').on('click', function() {
          var _this;
          _this = $(this).removeClass('remove').addClass('open');
          Redactor.prototype.addRedactor(_this.parents(".section").find(".sub-section").removeClass("noRedactor").html(''));
          Redactor.prototype.addListen();
        });
      };

      Redactor.prototype.mediaButton = function(element, type, code, call) {
        var parent;
        parent = element.parent();
        parent.prev().removeClass('open').addClass('remove');
        code = $(code);
        parent.parents(".section").find(".sub-section").addClass("noRedactor").attr("data-type", type).redactor('core.destroy').html(code);
        Redactor.prototype.addListen();
        if ((call != null) && typeof call === "function") {
          call(code, element);
        }
      };

      Redactor.prototype.addSection = function(block) {
        var newBlock;
        newBlock = $("<div class=\"section\">\n    <div class=\"sub-section\"></div>\n    <div class=\"media-toolbar\">\n        <span class=\"btn btn-toggle icon-plus\"></span>\n        <div class=\"menu-toolbar\">\n            <span class=\"btn icon-image\"></span>\n            <span class=\"btn icon-code\"></span>\n            <span class=\"btn icon-hr\">hr</span>\n        </div>\n    </div>\n</div>");
        block.after(newBlock);
        Redactor.prototype.elements = Redactor.prototype.document.find(Redactor.prototype.nameElement);
        Redactor.prototype.addRedactor(newBlock.find(".sub-section:not(.noRedactor)"), true);
        Redactor.prototype.addListen();
      };

      Redactor.prototype.initialize = function() {
        Redactor.prototype.loadRedactors();
      };

      Redactor.prototype.loadRedactors = function() {
        Redactor.prototype.elements.not(".noRedactor").each(function() {
          Redactor.prototype.addRedactor($(this));
        });
      };

      Redactor.prototype.addRedactor = function(element, focus) {
        var _elements;
        if (focus == null) {
          focus = false;
        }
        if (element != null) {
          _elements = Redactor.prototype.elements;
          element.redactor({
            iframe: true,
            cleanStyleOnEnter: false,
            cleanSpaces: false,
            linebreaks: true,
            focus: focus,
            tabAsSpaces: 4,
            buttons: ['bold', 'italic', 'deleted', 'link', 'alignment'],
            plugins: ['insertHead'],
            initCallback: function() {
              Redactor.prototype.redactor = this;
              element.off('click');
              Redactor.prototype.activeElement = element;
              Redactor.prototype.listenEvent(element);
              Redactor.prototype.showPlusButton(this);
            },
            changeCallback: function() {
              Redactor.prototype.showPlusButton(this, true);
              if (this.sel.type !== "Range") {
                _elements.parent().find('.redactor-toolbar').stop().fadeOut(400);
              }
            },
            blurCallback: function() {
              var redactor;
              this.$element.removeClass("focus");
              _elements.parent().find('.redactor-toolbar').stop().fadeOut(400);
              redactor = this;
              setTimeout(function() {
                Redactor.prototype.showPlusButton(redactor, true);
              }, 10);
            },
            keydownCallback: function(e) {
              if ((e.keyCode === 8 || e.keyCode === 46) && this.code.get() === "") {
                Redactor.prototype.removeRedactor(this.$element);
              }
              if (e.keyCode === 13) {
                Redactor.prototype.addSection(this.$element.parents(".section"), true);
                return false;
              }
            },
            keyupCallback: function() {
              Redactor.prototype.showPlusButton(this, true);
            },
            focusCallback: function(e) {
              Redactor.prototype.lastFocus = _docum.find("#viewDoc").find(".section").index(this.$element.parent().parent());
              Redactor.prototype.showPlusButton(this, true);
              this.$element.addClass("focus");
              _elements.not(this.$element).parent().find('.redactor-toolbar').stop().fadeOut(400);
              this.$element.parents(".section").find(".media-toolbar .btn-toggle").removeClass("open");
            }
          });
        }
      };

      Redactor.prototype.showPlusButton = function(_redactor, focus) {
        var active;
        if (focus == null) {
          focus = false;
        }
        active = focus = !focus && (_redactor != null) ? _redactor.focus.isFocused() : focus;
        _docum.find("#viewDoc").find(".section").each(function() {
          var noRedactor;
          if (focus) {
            active = (_redactor != null) && !$.trim($(this).find(".sub-section").html()).length && Redactor.prototype.lastFocus === _docum.find("#viewDoc").find(".section").index($(this));
          }
          noRedactor = $(this).find(".noRedactor");
          if (!((_redactor != null) && !noRedactor.length)) {
            noRedactor.addClass("active").find(".btn-toggle").removeClass("open").addClass("remove");
            Redactor.prototype.addListen();
          } else {
            $(this).find(".media-toolbar").toggleClass("active", active).find(".btn-toggle").removeClass("open");
          }
        });
      };

      Redactor.prototype.listenEvent = function(element) {
        element.off('mousedown mouseup').on('mousedown mouseup', function(event) {
          if (event.type === 'mousedown') {
            Redactor.prototype.position.start.y = event.pageY;
            Redactor.prototype.position.start.x = event.pageX;
          } else {
            Redactor.prototype.position.end.y = event.pageY;
            Redactor.prototype.position.end.x = event.pageX;
          }
        }).off('click').on('click', function() {
          var selection, toolbar;
          selection = window.getSelection == null ? window.getSelection() : document.getSelection();
          if (selection.type === 'Range') {
            toolbar = $(this).prev();
            Redactor.prototype.toolbarPosition(toolbar);
          } else {
            element.parent().find('.redactor-toolbar').hide();
          }
        });
      };

      Redactor.prototype.removeRedactor = function(element) {
        Redactor.prototype.elements = Redactor.prototype.document.find(Redactor.prototype.nameElement);
        if ((element != null) && Redactor.prototype.elements.length > 1) {
          element.redactor('core.destroy');
          element.parents(".section").remove();
        }
      };

      Redactor.prototype.save = function(element) {
        Redactor.prototype.elements = Redactor.prototype.document.find(Redactor.prototype.nameElement);
        Redactor.prototype.elements.each(function() {
          if ($(this).hasClass("redactor-editor") && !$(this).hasClass("noRedactor")) {
            if ($.trim($(this).redactor('code.get')) === "") {
              Redactor.prototype.removeRedactor($(this));
            } else {
              $(this).redactor("core.destroy");
            }
          }
          if ($(this).hasClass("noRedactor")) {
            $(this).find(".code").each(function() {
              Redactor.prototype.CodeMirror.setOption("readOnly", true);
            });
          }
        });
        setTimeout(function() {
          app.Menu.treeGenerate();
        }, 250);
      };

      Redactor.prototype.toolbarPosition = function(toolbar) {
        var left, readTop, top;
        readTop = Redactor.prototype.position.start.y < Redactor.prototype.position.end.y ? 'start' : 'end';
        if (toolbar.next().length) {
          top = Redactor.prototype.position[readTop].y - (toolbar.next().offset().top) - toolbar.height() * 2 + 'px';
          left = Math.abs(Redactor.prototype.position.start.x + Redactor.prototype.position.end.x) / 2 - (toolbar.next().offset().left) - (toolbar.width() / 2) + 'px';
          if ((Math.abs(Redactor.prototype.position.start.x + Redactor.prototype.position.end.x) / 2 + (toolbar.next().offset().left) - (toolbar.width() / 2)) >= $(window).width()) {
            left = $(window).width() - 5 - toolbar.width() - toolbar.next().offset().left + "px";
          }
          if (toolbar.is(':visible') && (toolbar.next().offset() != null)) {
            toolbar.stop().animate({
              top: top,
              left: left,
              opacity: 1
            }, 150);
          } else {
            if (toolbar.next().offset() != null) {
              toolbar.stop().fadeIn(400).css({
                top: top,
                left: left
              }).find(".redactor-act").removeClass("redactor-act");
            }
          }
        }
      };


      /*Redactor::viewBox = ()->
          selection = if not window.getSelection? then window.getSelection() else document.getSelection()
          console.log(selection.type)
          if selection.type is 'Range'
              range = selection.getRangeAt(0)
              container = $(range.commonAncestorContainer.parentElement)
              text = container.text()
              startText = text.substring(0, range.startOffset)
              endText = text.substring(range.endOffset, text.length)
              container.html(startText + "<span class='range'>" + selection + "</span>" + endText)
              setTimeout ->
                  Redactor::redactor.caret.setOffset(40)
              , 20
       */

      Redactor;

      return Redactor;

    })();
    redactor = new Redactor(_docum, '.sub-section');
    redactor.init();
  });
});
