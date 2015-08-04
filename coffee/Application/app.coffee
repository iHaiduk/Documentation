define [ 'jquery' ], ($) ->
    _document = $(document)
    _document.ready ->
        $(window).off('scroll').on 'scroll', ->
            top = $(this).scrollTop()
            _document.find('.header').toggleClass 'shadow', top > 0
            _document.find('.nav').css 'margin-top': top + 'px'
            return

        _document.find('.section').off('mouseenter mouseleave').on 'mouseenter mouseleave', (e) ->
            $(this).find('span.btn-edit').toggleClass 'visible', e.type == 'mouseenter'
            return

        $('.btn-product, .close').off('click').on 'click', ->
            bool = $(this).hasClass('btn-product')
            $('body').toggleClass 'noScroll', bool
            $('.popup').toggleClass 'visible', bool
            return

        $('.nav').find(".nav-item").off('click').on 'click', ->
            (this).next().slideToggle 200 if $(this).hasClass("parent")
            $(this).parents(".nav").find(".active").removeClass 'active'
            $(this).parent().addClass('active').parents(".nav-list").addClass('active')
            return
        return
    return