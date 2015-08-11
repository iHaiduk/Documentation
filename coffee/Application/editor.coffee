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

    link_insert = 0
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
        button4 = @button.add('link')
        @button.addCallback button4, @insertHead.link
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
      link: ->
        @selection.restore();
        Redactor::lastLinkActive = "link_insert_"+(new Date).getTime();
        @insert.html('<a id="'+Redactor::lastLinkActive+'">'+@selection.getText()+'</a>', false)
        @code.sync()
        @observe.load()
        console.log(@selection.getBlock())
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
        Redactor::lastSection = null
        Redactor::lastLinkActive = null
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
          Redactor::mediaButton("image", Redactor::template.image)
          return

        Redactor::document.find('.icon-code').off('click').on 'click', ->
          Redactor::mediaButton("code", Redactor::template.code, (element)->
            Redactor::CodeMirror = CodeMirror.fromTextArea element[0],
              mode: "javascript"
              lineNumbers: true
              matchBrackets: true
              styleActiveLine: true
              htmlMode: true
              theme: "3024-day"
            return
          )
          Redactor::loadRedactors()
          return

        Redactor::document.find('.icon-hr').off('click').on 'click', ->
          Redactor::mediaButton("hr", Redactor::template.hr)
          return

        Redactor::document.find('.remove').off('click').on 'click', ->
          _this = $(@)
          _this.parents(".section").find(".sub-section").removeClass("noRedactor").html('<p></p>')
          console.log(_this.parents(".section").find(".sub-section"))
          Redactor::addRedactor(_this.parents(".section").find(".sub-section"), true);
          Redactor::addListen()
          _this.remove()
          return
        return

      Redactor::mediaButton = (type, code, call)->
        frstSectionArray = []
        lastSectionArray = []
        parentSection = Redactor::lastSection.parents(".section:not(.noRedactor)")
        pos = Redactor::lastSection.parent().find("p").index(Redactor::lastSection.addClass("tempSection"));

        Redactor::lastSection.parent().find("p").each ->
          if Redactor::lastSection.parent().find("p").index($(@)) < pos
            frstSectionArray.push($(@))
          if Redactor::lastSection.parent().find("p").index($(@)) > pos
            lastSectionArray.push($(@))
          return
        Redactor::lastSection.removeClass("tempSection")
        frstSectionArray = frstSectionArray.map (el) ->
          el.get()[0].outerHTML

        lastSectionArray = lastSectionArray.map (el) ->
          el.get()[0].outerHTML

        frstSectionArrayHTML = frstSectionArray.join("")
        lastSectionArrayHTML = lastSectionArray.join("")

        if $(frstSectionArrayHTML).text().trim().length
          parentSection.find(".sub-section").redactor("code.set", frstSectionArrayHTML)
        element = $(code)
        noRedactorSection = $("<div class='section'><div class='sub-section noRedactor'></div><span class='btn btn-toggle remove'></span></div></div>")
        noRedactorSection.find(".sub-section").html(element)
        parentSection.after(noRedactorSection)
        parentSection.remove() if !$(frstSectionArrayHTML).text().trim().length
        Redactor::addSection(noRedactorSection, lastSectionArrayHTML)

        $("#media-toolbar").find(".btn-toggle").removeClass("open")

        call(element, noRedactorSection) if call? and typeof call is "function"
        return

      Redactor::addSection = (block, code)->
        newBlock = $(Redactor::template.empty)
        block.after newBlock
        Redactor::elements = Redactor::document.find(Redactor::nameElement+":not(.noRedactor)")
        Redactor::addRedactor newBlock.find(".sub-section:not(.noRedactor)"), false, code
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

      Redactor::addRedactor = (element, focus = false, code) ->
        if element? and !element.hasClass("noRedactor")
          console.log(element)
          _elements = Redactor::elements
          element.redactor
            iframe: true
            cleanStyleOnEnter: false
            focus: focus
            tabAsSpaces: 4
            buttons: ['bold', 'italic', 'deleted']
            plugins: ['insertHead']
            shortcutsAdd: 'ctrl+enter': func: 'insertHead.newRedactor'
            initCallback: ->
              Redactor::redactor = @
              @code.set(code) if code?
              element.off 'click'
              Redactor::activeElement = element
              Redactor::listenEvent element
              Redactor::showPlusButton(@)
              return
            changeCallback: ()->
              Redactor::showPlusButton(@, true)
              _elements.parent().find('.redactor-toolbar').stop().fadeOut 400 if @sel.type isnt "Range"
              return
            clickCallback: ->
              console.log(e)
            blurCallback: () ->
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
            keyupCallback: (e) ->
              Redactor::showPlusButton(@, true)
              return
            focusCallback: (e)->
              Redactor::lastFocus = _docum.find("#viewDoc").find(".section").index(@$element.parent().parent())
              Redactor::showPlusButton(@, true)
              @$element.addClass("focus")
              _elements.not(@$element).parent().find('.redactor-toolbar').stop().fadeOut 400
              @$element.parents(".section").find(".media-toolbar .btn-toggle").removeClass("open")
              return

          return

      Redactor::showPlusButton = (_redactor = Redactor::redactor, focus = false)->
        if _redactor? and _redactor.selection?
          Redactor::findLink(_redactor)
          block = $(_redactor.selection.getBlock())
          Redactor::lastSection = block
          text = $(_redactor.selection.getBlock()).text().trim()
          html = $(_redactor.selection.getBlock()).html()
          html = html.replace(/[\u200B]/g, '') if html?
          lnght = text.length
          _docum.find("#viewDoc").find(".media-toolbar").toggleClass("active", false)
          _docum.find("#viewDoc").find("p").toggleClass("empty", false)
          if (!lnght or (lnght and !html.length)) and block.length
            $("#media-toolbar").toggleClass("active", true).css("top", (block.offset().top-83)+"px").find(".btn-toggle").removeClass("open")
            block.toggleClass("empty", true)
          return
        return

      Redactor::listenEvent = (element)->
        $("#link_value").off('keyup').on('keyup', (event) ->
          $("#"+Redactor::lastLinkActive).attr("href",$(@).val())
          Redactor::redactor.code.sync()
          Redactor::redactor.observe.load()
        )
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

      Redactor::findLink = (_redactor)->
        parent = if (_ref =_redactor.selection.getParent()) then $(_ref) else false
        if parent and parent[0].tagName.toLowerCase() is "a"
          Redactor::lastLinkActive = parent.attr("id")

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