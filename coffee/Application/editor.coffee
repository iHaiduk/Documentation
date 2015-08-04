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
                _elements = Redactor::elements
                Redactor::loadRedactors()
                _elements.on('mousedown mouseup', (event) ->
                    if event.type == 'mousedown'
                        Redactor::position.start.y = event.pageY
                        Redactor::position.start.x = event.pageX
                    else
                        Redactor::position.end.y = event.pageY
                        Redactor::position.end.x = event.pageX
                    return
                ).on 'click', ->
                    if window.getSelection().type is 'Range'
                        toolbar = $(this).prev()
                        readTop = if Redactor::position.start.y < Redactor::position.end.y then 'start' else 'end'
                        if toolbar.is(':visible')
                          toolbar.stop().animate {
                              top: Redactor::position[readTop].y - ($(this).offset().top) - toolbar.height - 15 + 'px'
                              left: Math.abs(Redactor::position.start.x + Redactor::position.end.x) / 2 - ($(this).offset().left) - (toolbar.width() / 2) + 'px'
                              opacity: 1
                          }, 150
                        else
                        toolbar.stop().fadeIn(400).css
                            top: Redactor::position[readTop].y - ($(this).offset().top) - 60 + 'px'
                            left: Math.abs(Redactor::position.start.x + Redactor::position.end.x) / 2 - ($(this).offset().left) - (toolbar.width() / 2) + 'px'
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
                        plugins: [ 'highlight' ]
                        initCallback: ->
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

            Redactor
        redactor = new Redactor(_docum, '.sub-section')
        redactor.init()
        return
    return