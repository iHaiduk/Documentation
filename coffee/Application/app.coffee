define [ 'jquery' ], ($) ->
    _document = $(document)
    _document.ready ->
        _document.find('.section').off('mouseenter mouseleave').on 'mouseenter mouseleave', (e) ->
            $(this).find('span.btn-edit').toggleClass 'visible', e.type == 'mouseenter'
            return

        $('.btn-product, .close').off('click').on 'click', ->
            bool = $(this).hasClass('btn-product')
            $('body').toggleClass 'noScroll', bool
            $('.popup').toggleClass 'visible', bool
            return

        $('.btn-toggle').click ->
            $(this).toggleClass 'open'
            return
        return
    return