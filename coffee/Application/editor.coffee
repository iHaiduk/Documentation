###*
# Created by Igor on 02.08.2015.
###

define [
    'jquery'
    'hljs'
    'redactor'
], ($, hljs) ->
    _docum = $(document)
    _docum.ready ->

        $.Redactor::highlight = ->
            {
            save: ->
                html = @code.get()
                console.log html
                return
            init: ->
                button = @button.add('bold', 'Insert Code')
                @button.addCallback button, @highlight.code
                return
            code: ->
                @inline.format 'pre', 'class', 'code'
                return

            }

        Redactor = do ->
            `var Redactor`

            Redactor = (document, nameElement) ->
                Redactor::redactor = null
                Redactor::document = document
                Redactor::nameElement = nameElement
                Redactor::elements = document.find(nameElement)
                Redactor::activeElement = null
                Redactor::position =
                    start:
                        x: 0
                        y: 0
                    end:
                        x: 0
                        y: 0
                return

            Redactor::init = ->

                Redactor::document.find("#initRedactor").off('click').on 'click', ->
                    if $(this).hasClass("btn-edit")
                        $(this).removeClass("btn-edit").addClass "btn-save"
                        Redactor::initialize()
                    else
                        $(this).removeClass("btn-save").addClass "btn-edit"
                        Redactor::save()
                return

            Redactor::initialize = () ->
                _elements = Redactor::elements
                Redactor::loadRedactors()
                _elements.off('mousedown mouseup').on('mousedown mouseup', (event) ->
                    if event.type == 'mousedown'
                        Redactor::position.start.y = event.pageY
                        Redactor::position.start.x = event.pageX
                    else
                        Redactor::position.end.y = event.pageY
                        Redactor::position.end.x = event.pageX
                    return
                ).off('click').on 'click', ->
                    selection = if not window.getSelection? then window.getSelection() else document.getSelection()
                    if selection.type is 'Range'
                        toolbar = $(this).prev()
                        Redactor::toolbarPosition(toolbar)
                    else
                        _elements.parent().find('.redactor-toolbar').hide()
                    return
                return

            Redactor::loadRedactors = ->
                Redactor::elements.each ->
                    Redactor::addRedactor $(this)
                    return
                return

            Redactor::addRedactor = (element) ->
                if element?
                    _elements = Redactor::elements
                    element.redactor
                        iframe: true
                        cleanStyleOnEnter: false
                        linebreaks: true
                        formatting: ['p', 'blockquote', 'h1', 'h2']
                        buttons: ['formatting', 'bold', 'italic', 'deleted', 'link', 'alignment']
                        plugins: ['formatting', 'bold', 'italic', 'deleted',
                                  'unorderedlist', 'orderedlist', 'link', 'alignment']
                        initCallback: ->
                            Redactor::redactor = this
                            element.off 'click'
                            Redactor::activeElement = element
                            return
                        blurCallback: (e) ->
                            _elements.parent().find('.redactor-toolbar').stop().fadeOut 400
                            return
                        keydownCallback: (e) ->
                            ###e.preventDefault()
                            console.log e.keyCode
                            false###
                    return

            Redactor::removeRedactor = (element)->
                if element?
                    element.redactor 'core.destroy'
                return

            Redactor::save = (element)->
                Redactor::elements.redactor("core.destroy")

            Redactor::toolbarPosition = (toolbar)->
                readTop = if Redactor::position.start.y < Redactor::position.end.y then 'start' else 'end'

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
                    return
                else
                    if toolbar.next().offset()?
                        toolbar.stop().fadeIn(400).css({
                            top
                            left
                        })

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