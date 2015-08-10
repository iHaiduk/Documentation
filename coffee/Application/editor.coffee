###*
# Created by Igor on 02.08.2015.
###

define [
  'jquery'
  'codemirror'
  'redactor'
  'Application/menu'
  'codemirror/mode/htmlmixed/htmlmixed'
  'codemirror/mode/clike/clike'
  'codemirror/mode/coffeescript/coffeescript'
  'codemirror/mode/css/css'
  'codemirror/mode/javascript/javascript'
  'codemirror/mode/php/php'
  'codemirror/mode/sass/sass'
  'codemirror/mode/sql/sql'
  'codemirror/mode/xml/xml'
], ($, CodeMirror) ->
  _docum = $(document)
  _docum.ready ->

    $.Redactor::insertHead = ->
      {
      init: ->
# add a button to the toolbar that calls the showMyModal method when clicked
        button = @button.add('header1')
        @button.addCallback button, @insertHead.insertH1
        button2 = @button.add('header2')
        @button.addCallback button2, @insertHead.insertH2
        button3 = @button.add('alignment')
        @button.addCallback button3, @insertHead.center
        return
      insertH1: (key)->
        @inline.format('head1')
        @selection.restore()
        @code.sync()
        @observe.load()
        @inline.format('head2') if @.selection.getParent() and $(@.selection.getParent())[0].tagName.toLowerCase() =='head2'
        return
      insertH2: (key)->
        @inline.format('head2')
        @selection.restore()
        @code.sync()
        @observe.load()
        @inline.format('head1') if @.selection.getParent() and $(@.selection.getParent())[0].tagName.toLowerCase() =='head1'
        return
      center: ->
        @selection.restore();
        @inline.format('center')
        @code.sync()
        @observe.load()
        return

      }

    class Redactor
      constructor: (document, nameElement) ->
        Redactor::redactor = null
        Redactor::toolbar = null
        Redactor::document = document
        Redactor::nameElement = nameElement
        Redactor::elements = document.find(nameElement)
        Redactor::activeElement = null
        Redactor::CodeMirror = null
        Redactor::lastFocus = null
        Redactor::position =
          start:
            x: 0
            y: 0
          end:
            x: 0
            y: 0
        Redactor::template =
          empty: """<div class="section">
                            <div class="sub-section"></div>
                            <div class="media-toolbar">
                                <span class="btn btn-toggle icon-plus"></span>
                                <div class="menu-toolbar">
                                    <span class="btn icon-image"></span>
                                    <span class="btn icon-code"></span>
                                    <span class="btn icon-hr"></span>
                                </div>
                            </div>
                        </div>"""
          image: """<img/>"""
          code: """<textarea class='code'></textarea><ul class="language-list" >
          <li class="language">HTML</li>
          <li class="language">CSS</li>
          <li class="language">SASS</li>
          <li class="language">JavaScript</li>
          <li class="language">CoffeScript</li>
          <li class="language">PHP</li>
          <li class="language">SQL</li>
</ul>"""
          hr: """<hr/>"""

      Redactor::init = ->

        Redactor::document.find("#initRedactor").off('click').on 'click', ->
          if $(@).hasClass("btn-edit")
            $(@).removeClass("btn-edit").addClass "btn-save"
            $("body").addClass "editing"
            Redactor::reset()
            Redactor::initialize()
            Redactor::showPlusButton()
            return
          else
            $(@).removeClass("btn-save").addClass "btn-edit"
            $("body").removeClass "editing"
            Redactor::save()
            return
        Redactor::addListen()
        return

      Redactor::reset = ()->
        Redactor::elements.find(".code").removeClass().addClass("code").each ->
          $(@).text($(@).text())
          return
        return

      Redactor::addListen = ()->

        Redactor::document.find('.btn-toggle').off('click').on 'click', ->
          $(@).toggleClass 'open'
          return

        Redactor::document.find('.icon-image').off('click').on 'click', ->
          Redactor::mediaButton($(@), "image", Redactor::template.image)
          return

        Redactor::document.find('.icon-code').off('click').on 'click', ->
          Redactor::mediaButton($(@), "code", Redactor::template.code, (element)->
            Redactor::CodeMirror = CodeMirror.fromTextArea element[0],
              mode: "javascript"
              lineNumbers: true,
              matchBrackets: true,
              styleActiveLine: true,
              theme: "3024-day"
              viewportMargin: Infinity
            return
          )
          Redactor::loadRedactors()
          return

        Redactor::document.find('.icon-hr').off('click').on 'click', ->
          Redactor::mediaButton($(@), "hr", Redactor::template.hr)
          return

        Redactor::document.find('.remove').off('click').on 'click', ->
          _this = $(@).removeClass('remove').addClass('open')
          Redactor::addRedactor(_this.parents(".section").find(".sub-section").removeClass("noRedactor").html(''), true);
          Redactor::addListen()
          return
        return

      Redactor::mediaButton = (element, type, code, call)->
        parent = element.parent()
        parent.prev().removeClass('open').addClass('remove')
        code = $(code)
        parent.parents(".section").find(".sub-section").addClass("noRedactor").attr("data-type",type).redactor('core.destroy').html(code);
        Redactor::addListen()
        call(code, element) if call? and typeof call is "function"
        return


      Redactor::addSection = (block)->
        newBlock = $(Redactor::template.empty)
        block.after newBlock
        Redactor::elements = Redactor::document.find(Redactor::nameElement)
        Redactor::addRedactor newBlock.find(".sub-section:not(.noRedactor)"), true
        Redactor::addListen()
        return

      Redactor::initialize = () ->
        Redactor::loadRedactors()
        return

      Redactor::loadRedactors = ->
        Redactor::elements.not(".noRedactor").each ->
          Redactor::addRedactor $(@)
          return
        return

      Redactor::addRedactor = (element, focus = false) ->
        if element?
          _elements = Redactor::elements
          element.redactor
            iframe: true
            focus: focus
            tabAsSpaces: 4
            buttons: ['bold', 'italic', 'deleted', 'link']
            plugins: ['insertHead']
            shortcutsAdd: 'ctrl+enter': func: 'insertHead.newRedactor'
            initCallback: ->
              Redactor::redactor = @
              element.off 'click'
              Redactor::activeElement = element
              Redactor::listenEvent element
              Redactor::showPlusButton(@)
              return
            changeCallback: ()->
              Redactor::empty(@)
              Redactor::showPlusButton(@, true)
              _elements.parent().find('.redactor-toolbar').stop().fadeOut 400 if @sel.type isnt "Range"
              return
            clickCallback: ->
              console.log(e)
            blurCallback: () ->
              Redactor::empty(@)
              @$element.removeClass("focus")
              _elements.parent().find('.redactor-toolbar').stop().fadeOut 400
              redactor = @
              setTimeout(->
                Redactor::showPlusButton(redactor, true)
                return
              , 10)
              return
            keydownCallback: (e) ->
              key = e.which
              Redactor::removeRedactor(@$element) if (e.keyCode is 8 or e.keyCode is 46) and @code.get() is ""
              if key is @keyCode.ENTER and (e.ctrlKey or e.shiftKey)
                Redactor::addSection(@$element.parents(".section"), true)
              return
            keyupCallback: () ->
              Redactor::showPlusButton(@, true)
              return
            focusCallback: (e)->
              Redactor::empty(@)
              Redactor::lastFocus = _docum.find("#viewDoc").find(".section").index(@$element.parent().parent())
              Redactor::showPlusButton(@, true)
              @$element.addClass("focus")
              _elements.not(@$element).parent().find('.redactor-toolbar').stop().fadeOut 400
              @$element.parents(".section").find(".media-toolbar .btn-toggle").removeClass("open")
              return

          return

      Redactor::empty = (_this)->
        return if _this.selection?
        elem = _this.selection.getBlock()
        _elements = $("#viewDoc").find("p,head1,head2")
        if _elements.index($(elem)) isnt -1
          _elements.off("click").on "click", ->
            Redactor::empty(elem)
            return
          _elements.each ->
            if _elements.index($(@)) is _elements.index($(elem)) and !$.trim($(@).text()).length
              $(@).addClass("empty")
            else
              $(@).removeClass("empty")
            return
        return

      Redactor::showPlusButton = (_redactor = Redactor::redactor, focus = false)->
        block = $(_redactor.selection.getBlock())
        #active = focus = if !focus and _redactor? then _redactor.focus.isFocused() else focus
        lnght = $(_redactor.selection.getBlock()).text().trim().length
        _docum.find("#viewDoc").find(".media-toolbar").toggleClass("active", false)
        console.log lnght, block.parents(".section")
        if !lnght
          $("#media-toolbar").toggleClass("active", true).find(".btn-toggle").removeClass("open")
        ###_docum.find("#viewDoc").find(".section").each ->

          active = _redactor? and !$.trim($(@).find(".sub-section").html()).length and Redactor::lastFocus is _docum.find("#viewDoc").find(".section").index($(@)) if focus
          noRedactor = $(@).find(".noRedactor")

          unless _redactor? and !noRedactor.length

            noRedactor.addClass("active").find(".btn-toggle").removeClass("open").addClass("remove")
            Redactor::addListen()

          else
            $(@).find(".media-toolbar").toggleClass("active", active).find(".btn-toggle").removeClass("open")
          return
        return###

      Redactor::listenEvent = (element)->
        element.off('mousedown mouseup').on('mousedown mouseup', (event) ->
          if event.type == 'mousedown'
            Redactor::position.start.y = event.pageY
            Redactor::position.start.x = event.pageX
          else
            Redactor::position.end.y = event.pageY
            Redactor::position.end.x = event.pageX
          return
        ).off('click').on 'click', ->
          Redactor::showPlusButton(null, true)
          selection = if not window.getSelection? then window.getSelection() else document.getSelection()
          if selection.type is 'Range'
            toolbar = $(@).prev()
            Redactor::toolbar = toolbar
            Redactor::toolbarPosition(toolbar)
          else
            element.parent().find('.redactor-toolbar').hide()
          return
        return

      Redactor::removeRedactor = (element)->
        Redactor::elements = Redactor::document.find(Redactor::nameElement)
        if element? and Redactor::elements.length > 1
          element.redactor 'core.destroy'
          element.parents(".section").remove()
          return

      Redactor::save = (element)->
        Redactor::elements = Redactor::document.find(Redactor::nameElement)
        Redactor::elements.each ->
          if $(@).hasClass("redactor-editor") and !$(@).hasClass("noRedactor")
            if $.trim($(@).redactor('code.get')) is ""
              Redactor::removeRedactor $(@)
            else
              $(@).redactor("core.destroy")
          if $(@).hasClass("noRedactor")
            $(@).find(".code").each ->
              Redactor::CodeMirror.setOption("readOnly", true)
              return
            return


        setTimeout(->
          app.Menu.treeGenerate()
          return
        , 250)
        return

      Redactor::toolbarPosition = (toolbar = Redactor::toolbar)->
        readTop = if Redactor::position.start.y < Redactor::position.end.y then 'start' else 'end'

        if toolbar.next().length
          top = Redactor::position[readTop].y - (toolbar.next().offset().top) - toolbar.height()*2+ 'px'
          left = Math.abs(Redactor::position.start.x + Redactor::position.end.x) / 2 - (toolbar.next().offset().left) - (toolbar.width() / 2) + 'px'

          if ((Math.abs(Redactor::position.start.x + Redactor::position.end.x) / 2 + (toolbar.next().offset().left) - (toolbar.width() / 2)) >= $(window).width() )
            left = $(window).width() - 5 - toolbar.width() - toolbar.next().offset().left + "px"

          if toolbar.is(':visible') and toolbar.next().offset()?
            toolbar.stop().animate {
              top
              left
              opacity: 1
            }, 150

          else
            if toolbar.next().offset()?
              toolbar.stop().fadeIn(400).css({
                top
                left
              }).find(".redactor-act").removeClass("redactor-act")


          toolbar.find(".re-header1, .re-header2").removeClass("redactor-act")

          toolbar.find(".re-header1").addClass("redactor-act") if Redactor::redactor.selection.getHtml().indexOf("head1") isnt -1
          toolbar.find(".re-header2").addClass("redactor-act") if Redactor::redactor.selection.getHtml().indexOf("head2") isnt -1
          return

      ###Redactor::viewBox = ()->
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
              , 20###


      Redactor
    redactor = new Redactor(_docum, '.sub-section')
    redactor.init()
    return
  return