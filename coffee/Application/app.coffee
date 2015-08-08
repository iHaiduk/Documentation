define [ 'jquery'], ($, Typekit) ->
    _document = $(document)
    _document.ready ->
        $('.btn-product, .close').off('click').on 'click', ->
            bool = $(@).hasClass('btn-product')
            $('body').toggleClass 'noScroll', bool
            $('.popup').toggleClass 'visible', bool
            return
        return
    return