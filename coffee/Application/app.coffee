define [ 'jquery', "font" ], ($, Typekit) ->
    _document = $(document)
    _document.ready ->
        Typekit.load({ async: true })
        $('.btn-product, .close').off('click').on 'click', ->
            bool = $(this).hasClass('btn-product')
            $('body').toggleClass 'noScroll', bool
            $('.popup').toggleClass 'visible', bool
            return
        return
    return