define [ 'jquery', 'Application/editor' ], ($) ->
  _document = $(document)
  _document.ready ->

    class Menu
      constructor: () ->
        Menu::tree = []
        Menu::lastIdHeading = -1
        Menu::HeadingCnt = 0
        Menu::MenuHeadingCnt = 0
        Menu::lock = false
        Menu::navigation = _document.find("#navigation")
        Menu::activeElement =
          element:null
          position: -1

      Menu::init = ()->
        Menu::treeGenerate()
        Menu::addBottomPadding()
        $(window).off('scroll').on('scroll', ->
          Menu::fixed()
          Menu::offsetTop()
          return
        ).off('mousewheel').on 'mousewheel', ->
          $(window).stop()
          return
        this

      Menu::fixed = ()->
        top = $(window).scrollTop()
        _document.find(".header.cf").toggleClass('shadow', top > 0)
        Menu::navigation.find("ul.nav").css 'margin-top': top + 'px'
        return

      Menu::addBottomPadding = () ->
        arr = jQuery.grep(_document.find("#viewDoc").find("head1,head2"), (val) ->
          true
        )
        summ = $(arr[arr.length - 1]).parents(".section").height()
        $(arr[arr.length-1]).parents(".section").nextAll(".section").each ->
          summ += $(this).height()

        _document.find(".right-side").css(
          "padding-bottom": $(window).height() - summ - _document.find(".header").outerHeight() - _document.find(".footer").outerHeight() - 31 + "px"
        )
        return

      Menu::treeGenerate = ()->
        Menu::tree = []
        Menu::lastIdHeading = -1
        Menu::HeadingCnt = 0
        Menu::MenuHeadingCnt = 0
        _document.find("#viewDoc").find("head1,head2").each ->
          if($(this)[0].tagName.toLowerCase() is "head1")
            Menu::lastIdHeading++;
            Menu::tree.push(
              element: $(this).attr("id", "header"+Menu::HeadingCnt)
              text: $(this).text()
              child: []
            )
            Menu::HeadingCnt++
            return

          else
            if Menu::lastIdHeading > -1
              Menu::tree[Menu::lastIdHeading].child.push(
                element: $(this).attr("id", "header"+Menu::HeadingCnt)
                text: $(this).text()
                active: false
              )
              Menu::HeadingCnt++
              return

        Menu::navigation.html(Menu::treeHTMLGenerate())
        Menu::fixed()
        Menu::offsetTop()
        Menu::addBottomPadding()
        Menu::listens()
        return

      Menu::listens = ()->
        Menu::navigation.find('.nav-item').off('click').on 'click', (e)->
          Menu::lock = true
          Menu::navigation.find(".active").removeClass 'active'
          $("html, body").stop().animate({
            scrollTop: _document.find("#" + $(@).data().id).offset().top - _document.find(".header").height() - 34
          },500, ->
            Menu::lock = false
            return
          )
          $(@).parent().addClass('active').parents(".nav-list").addClass('active')

          return
        return


      Menu::treeHTMLGenerate = (arrMenu = Menu::tree, sub = false)->
        htmlMenu = ""
        if arrMenu? and arrMenu.length
          htmlMenu += """<ul class='"""+(if sub then "sub-nav" else "nav")+"""'>"""
          arrMenu.forEach (val)->
            htmlMenu += """
                        <li class='nav-list'>
                            <a class='nav-item"""+(if val.child? and val.child.length then " parent" else "")+"""' href="javascript:void(0)" data-id='header"""+Menu::MenuHeadingCnt+"""'>"""+val.text+"""<span class='slide-arrow'></span></a>"""
            Menu::MenuHeadingCnt++
            if val.child? and val.child.length

              htmlMenu += Menu::treeHTMLGenerate(val.child, true)

            htmlMenu += """</li>"""

          htmlMenu += """</ul>"""
        htmlMenu

      Menu::offsetTop = ()->
        return if Menu::lock
        arr = jQuery.grep(_document.find("#viewDoc").find("head1,head2"), (val) ->
          $(val).offset().top-$(window).scrollTop()-_document.find(".header").height() >= 0
        )
        if arr.length
          Menu::navigation.find(".active").removeClass 'active'
          if(arr[0].tagName.toLowerCase() is "head1")
            Menu::navigation.find(".nav > .nav-list").eq(_document.find("#viewDoc").find("head1").index($(arr[0]))).addClass('active')
          else
            Menu::navigation.find(".sub-nav > .nav-list").eq(_document.find("#viewDoc").find("head2").index($(arr[0]))).addClass('active').parents(".nav-list").addClass('active')
        return






    menu = new Menu()
    app.Menu = menu.init()

