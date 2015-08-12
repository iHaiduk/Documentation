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
        button5 = @button.add('blockquote')
        @button.addCallback button5, @insertHead.blockquote
        button6 = @button.add('clear')
        @button.addCallback button6, @insertHead.clear
        button3 = @button.add('alignment')
        @button.addCallback button3, @insertHead.center
        button4 = @button.add('link')
        @button.addCallback button4, @insertHead.link
        return
      insertH1: (key)->
        @inline.format('sup')
        @selection.restore()
        @code.sync()
        @observe.load()
        @inline.format('sub') if @.selection.getParent() and $(@.selection.getParent())[0].tagName.toLowerCase() =='sub'
        @inline.format('blockquote') if @.selection.getParent() and $(@.selection.getParent())[0].tagName.toLowerCase() =='blockquote'
        return
      insertH2: (key)->
        @inline.format('sub')
        @selection.restore()
        @code.sync()
        @observe.load()
        @inline.format('sup') if @.selection.getParent() and $(@.selection.getParent())[0].tagName.toLowerCase() =='sup'
        @inline.format('blockquote') if @.selection.getParent() and $(@.selection.getParent())[0].tagName.toLowerCase() =='blockquote'
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
        if @selection.getHtml().indexOf("<a id") isnt -1
          @insert.html(@selection.getText(), false)
        else
          @insert.html('<a id="'+Redactor::lastLinkActive+'" href="">'+@selection.getText()+'</a>', false)
        @code.sync()
        @observe.load()
        Redactor::findLink(Redactor::redactor)
        $("#link_value").focus()
        return
      blockquote: ->
        @inline.format('blockquote')
        @selection.restore()
        @code.sync()
        @observe.load()
        @inline.format('sup') if @.selection.getParent() and $(@.selection.getParent())[0].tagName.toLowerCase() =='sup'
        @inline.format('sub') if @.selection.getParent() and $(@.selection.getParent())[0].tagName.toLowerCase() =='sub'
        return
      clear: ->
        @selection.restore();
        @insert.html(@selection.getText(), false)
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
        Redactor::CodeMirror = {}
        Redactor::lastFocus = null
        Redactor::lastSection = null
        Redactor::lastLinkActive = null
        Redactor::editLinkActive = false
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
          image: """<form id="form1" runat="server">
<label for='imgInp' id='uploadImage'></label>
    <input type='file' id="imgInp" />
</form>
    <img src="" />"""
          code: """<textarea class='code'></textarea><ul class="language-list" >
          <li class="language" data-type="htmlmixed">HTML</li>
          <li class="language" data-type="CSS">CSS</li>
          <li class="language" data-type="SASS">SASS</li>
          <li class="language" data-type="JavaScript">JavaScript</li>
          <li class="language" data-type="coffeescript">CoffeeScript</li>
          <li class="language" data-type="PHP">PHP</li>
          <li class="language" data-type="SQL">SQL</li>
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

        Redactor::document.find(".code").each ->

          CodeMirror.fromTextArea @,
            mode: $(@).data().type
            lineNumbers: true
            matchBrackets: true
            styleActiveLine: true
            htmlMode: true
            readOnly: true
            theme: "3024-day"
          return

        Redactor::addListen()
        return

      Redactor::reset = ()->
        Redactor::elements.find(".code").removeClass().addClass("code").each ->
          $(@).text($(@).text())
          return
        return

      Redactor::addListen = ()->
        $("#link-toolbar").on "click", (e)->
          if !$(e.target).hasClass("close")
            Redactor::editLinkActive = true
            $(@).addClass "active"
          return

        $("#link_close").on "click", ()->
          $(@).parent().removeClass "active"
          Redactor::editLinkActive = false
          return

        $("#link_value").on "click, keydown, keyup", ->
          Redactor::editLinkActive = true
          $(@).parent().addClass "active"
          return

        Redactor::document.find('.btn-toggle').off('click').on 'click', ->
          $(@).toggleClass 'open'
          return

        Redactor::document.find('.icon-image').off('click').on 'click', ->
          Redactor::mediaButton "image", Redactor::template.image, (element)->
            Redactor::preUploadImage(element)
            $("#media-toolbar").removeClass("active")
            $("#uploadImage").click()
            return
          return

        Redactor::preUploadImage = (element) ->
          $("#imgInp").on "change", (e)->
            element = $(element[2])
            file = e.target.files[0]
            imageType = /image.*/
            if !file.type.match(imageType)
              return
            reader = new FileReader
            reader.onload = (e)->
              $("#form1").remove()
              element.attr("src", e.target.result)
              return
            reader.readAsDataURL file
            return
          return



        Redactor::document.find('.icon-code').off('click').on 'click', ->
          Redactor::mediaButton("code", Redactor::template.code, (element)->
            param_id = "redactor_"+(new Date).getTime()
            $(element[0]).attr("id", param_id)
            $(element[1]).attr("data-id", param_id)
            Redactor::CodeMirror[param_id] = CodeMirror.fromTextArea element[0],
              mode: "sass"
              lineNumbers: true
              matchBrackets: true
              styleActiveLine: true
              htmlMode: true
              theme: "3024-day"
            Redactor::changeTypeListen()
            Redactor::loadRedactors()
            return
          )
          return

        Redactor::document.find('.icon-hr').off('click').on 'click', ->
          Redactor::mediaButton("hr", Redactor::template.hr)
          return

        Redactor::document.find('.remove').off('click').on 'click', ->
          _this = $(@)
          _this.parent(".section").remove()
          Redactor::addListen()
          _this.remove()
          return
        return

      Redactor::mediaButton = (type, code, call)->
        frstSectionArray = []
        lastSectionArray = []
        parentSection = if Redactor::lastSection.hasClass("sub-section") then Redactor::lastSection else Redactor::lastSection.parents(".sub-section")
        pos = parentSection.find("p").index(parentSection.find(".empty"))

        parentSection.find("p").each ->
          if parentSection.find("p").index($(@)) >= 0
            if parentSection.find("p").index($(@)) < pos
              frstSectionArray.push($(@))
            if parentSection.find("p").index($(@)) > pos
              lastSectionArray.push($(@))
            return
        frstSectionArray = frstSectionArray.map (el) ->
          el.get()[0].outerHTML

        lastSectionArray = lastSectionArray.map (el) ->
          el.get()[0].outerHTML

        frstSectionArrayHTML = frstSectionArray.join("")
        lastSectionArrayHTML = lastSectionArray.join("")

        parentSection.html(frstSectionArrayHTML)
        element = $(code)
        noRedactorSection = $("<div class='section'><div class='sub-section noRedactor'></div><span class='btn btn-toggle remove'></span></div></div>")
        noRedactorSection.find(".sub-section").html(element)
        parentSection.find(".empty").remove()
        parentSection.parents(".section").after(noRedactorSection)
        parentSection.remove() if !$(frstSectionArrayHTML).text().trim().length
        lastSectionArrayHTML = "<p class='empty'></p>" if !$(lastSectionArrayHTML).text().trim().length
        Redactor::addSection(noRedactorSection, lastSectionArrayHTML)
        Redactor::addListen()

        $("#media-toolbar").find(".btn-toggle").removeClass("open")

        call(element, noRedactorSection) if call? and typeof call is "function"
        return

      Redactor::addSection = (block, code)->
        newBlock = $(Redactor::template.empty)
        block.after newBlock
        Redactor::elements = Redactor::document.find(Redactor::nameElement+":not(.noRedactor)")
        Redactor::lastSection = newBlock.find(".sub-section")
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
              @$element.find("p, br").each ->
                $(@).remove() if !$(@).text().trim().length
                return
              @$element.find("p").each ->
                if $(@).text().length and !$(@).html().replace(/\u200B/g, '').length
                  $(@).html("<br/>")
              @code.sync()
              @observe.load()
              return
            changeCallback: ()->
              @$element.find("p").each ->
                if $(@).text().length and !$(@).html().replace(/\u200B/g, '').length
                  $(@).html("<br/>")
              Redactor::showPlusButton(@, true)
              _elements.parent().find('.redactor-toolbar').stop().fadeOut 400 if @sel.type isnt "Range"
              $("#viewDoc").find(".section-wrap > span").remove()
              return
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
              if (e.keyCode is 8 or e.keyCode is 46) and $(@selection.getBlock()).hasClass("empty")
                $(@selection.getBlock()).remove()
                if !@$element.find("p:not(.empty)").length and ($("#viewDoc").find(".sub-section:not(.noRedactor)").length-1)
                  @$element.parents(".section").remove()
              return
            keyupCallback: (e) ->
              key = e.which
              Redactor::lastSection = $(@selection.getBlock())
              if (e.keyCode is 13)
                @selection.restore()
                $(@selection.getBlock()).parent().toggleClass("empty", true) if $(@selection.getBlock()).text().trim() is ""
                @code.sync()
                @observe.load()
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
          block = if $(_redactor.selection.getCurrent())[0]? then $(_redactor.selection.getCurrent()) else $(_redactor.selection.getBlock())
          _docum.find("#viewDoc").find(".media-toolbar").toggleClass("active", false)
          _docum.find("#viewDoc").find(".empty").toggleClass("empty", false)
          if Redactor::isEmpty(block, true)
            block = block.parent() unless block[0].tagName?
            block = block.parent() if block[0].tagName.toLowerCase() isnt "p"
            $("#media-toolbar").toggleClass("active", true).css("top", (block.offset().top-107)+"px").find(".btn-toggle").removeClass("open")
            block.toggleClass("empty", true)
        return

      Redactor::listenEvent = (element)->
        $("#link_value").off('keyup').on('keyup', (event) ->
          $("#"+Redactor::lastLinkActive).attr("href",$(@).val())
          Redactor::redactor.code.sync()
          Redactor::redactor.observe.load()
          Redactor::listenEvent(element)
          return
        )
        element.off('mousedown mouseup').on('mousedown mouseup', (event) ->
          if event.type == 'mousedown'
            Redactor::position.start.y = event.pageY
            Redactor::position.start.x = event.pageX
          else
            Redactor::position.end.y = event.pageY
            Redactor::position.end.x = event.pageX
          return
        ).off('click').on 'click', (e)->
          Redactor::showPlusButton(null, true)
          Redactor::lastSection = $(@)
          $("#link-toolbar").removeClass("active").find("#link_value").val("")
          elem = $(e.target)
          if elem[0].tagName.toLowerCase() == "a"
            offset = elem.offset()
            Redactor::lastLinkActive = elem.attr("id")
            $("#link_value").val(elem.attr("href"))
            offset.top = parseInt(offset.top) - 57
            offset.left = parseInt(offset.left) - 120 + elem.width()/2
            Redactor::linkShow(offset)

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
        $("#link-toolbar").removeClass("active")
        if parent and parent[0].tagName.toLowerCase() is "a"
          Redactor::lastLinkActive = parent.attr("id")
          offset = _docum.find(".redactor-toolbar").offset();
          Redactor::linkShow(offset)
          return
        else
          $("#link-toolbar").removeClass("active") if !Redactor::editLinkActive
          return

      Redactor::linkShow = (offset)->
        if offset.left and offset.top
          Redactor::editLinkActive = true
          $("#link-toolbar").addClass("active").css(
            "left": parseInt(offset.left) - parseInt($("#viewDoc").offset().left) + "px"
            "top": parseInt(offset.top) - parseInt($("#viewDoc").offset().top) + "px"
          )
          return

      Redactor::removeRedactor = (element)->
        Redactor::elements = Redactor::document.find(Redactor::nameElement)
        if element? and Redactor::elements.length > 1 and element.hasClass("redactor-editor")
          element.redactor 'core.destroy'
          element.parents(".section").remove()
          return

      Redactor::save = (codeSave = true)->
        Redactor::codeSave() if codeSave
        Redactor::elements = Redactor::document.find(Redactor::nameElement)
        Redactor::elements.each ->
          if $(@).hasClass("redactor-editor") and !$(@).hasClass("noRedactor")
            if $.trim($(@).redactor('code.get')) is ""
              Redactor::removeRedactor $(@)
              return
            else
              $(@).redactor("core.destroy")
              return
        setTimeout(->
          app.Menu.treeGenerate()
          cnt = $("#viewDoc").find("p").length
          $($("#viewDoc").find("p").get().reverse()).each ->
            if !$(@).text().trim().length and cnt > 1
              $(@).remove()
              cnt--
            return
          return
        , 10)
        return

      Redactor::codeSave = ->
        $.each Redactor::CodeMirror, (val)->
          Redactor::CodeMirror[val].setOption("readOnly", true)
          return
        return

      Redactor::changeTypeListen = ->
        _docum.find(".language-list").find(".language").off("click").on "click", ->
          Redactor::changeTypeCode($(@).parent().data().id, $(@).data().type)
          return
        return

      Redactor::changeTypeCode = (id, type)->
        Redactor::CodeMirror[id].setOption("mode", type.toLowerCase())
        return

      Redactor::isEmpty = (_redactor, element = false)->
        if element
          block = html = _redactor
        else
          block = if $(_redactor.selection.getCurrent())[0]? then $(_redactor.selection.getCurrent()) else $(_redactor.selection.getBlock())
          html = $(_redactor.selection.getBlock()).html()

        text = block.text().trim()
        html = html.html().replace(/[\u200B]/g, '').trim() if typeof html is "object" and html.html()?
        lnght = text.length

        ((!lnght or !html[0]? or (lnght and !(html[0].length))) and block.length)

      Redactor::toolbarPosition = (toolbar = Redactor::toolbar)->
        readTop = if Redactor::position.start.y < Redactor::position.end.y then 'start' else 'end'

        if toolbar.next().length
          top = Redactor::position[readTop].y - (toolbar.next().offset().top) - toolbar.height()*1.7+ 'px'
          left = Math.abs(Redactor::position.start.x + Redactor::position.end.x) / 2 - (toolbar.next().offset().left) - (toolbar.width() / 2) - 42 + 'px'

          if ((parseInt(left) + toolbar.width() + parseInt($("#viewDoc").offset().left) + 90) >= $(window).width() )
            left = $(window).width() - toolbar.width() - toolbar.next().offset().left - 90 + "px"

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


          toolbar.find(".re-header1, .re-header2, .re-link").removeClass("redactor-act")
          $("#link-toolbar").removeClass("active")

          toolbar.find(".re-header1").addClass("redactor-act") if Redactor::redactor.selection.getHtml().indexOf("<sup") isnt -1 or Redactor::redactor.selection.getParent().tagName.toLowerCase() == "sup"
          toolbar.find(".re-header2").addClass("redactor-act") if Redactor::redactor.selection.getHtml().indexOf("<sub") isnt -1 or Redactor::redactor.selection.getParent().tagName.toLowerCase() == "sub"
          toolbar.find(".re-link").addClass("redactor-act") if Redactor::redactor.selection.getHtml().indexOf("<a") isnt -1 or Redactor::redactor.selection.getParent().tagName.toLowerCase() == "a"
          return

      Redactor
    redactor = new Redactor(_docum, '.sub-section')
    redactor.init()
    return
  return