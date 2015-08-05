define [ 'jquery', 'hljs', 'Application/editor' ], ($) ->
  _document = $(document)
  _document.ready ->

    class Menu
      constructor: () ->
        Menu::tree = []
        Menu::lastIdHeading = -1
        Menu::HeadingCnt = 0
        Menu::MenuHeadingCnt = 0
        Menu::navigation = _document.find("#navigation")
        Menu::activeElement =
          element:null
          position: -1

      Menu::init = ()->
        Menu::treeGenerate()
        $(window).off('scroll').on 'scroll', ->
          Menu::fixed()
          Menu::offsetTop()

        this

      Menu::fixed = ()->
        top = $(window).scrollTop()
        console.log(top)
        Menu::navigation.toggleClass('shadow', top > 0).find("ul.nav").css 'margin-top': top + 'px'

      Menu::treeGenerate = ()->
        Menu::tree = []
        Menu::lastIdHeading = -1
        Menu::HeadingCnt = 0
        Menu::MenuHeadingCnt = 0
        _document.find("#viewDoc").find("h1,h2").each ->
          if($(this)[0].tagName.toLowerCase() is "h1")
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
        Menu::listen()
        return

      Menu::treeHTMLGenerate = (arrMenu = Menu::tree, sub = false)->
        htmlMenu = ""
        if arrMenu? and arrMenu.length
          htmlMenu += """<ul class='"""+(if sub then "sub-nav" else "nav")+"""'>"""
          arrMenu.forEach (val)->
            htmlMenu += """
                        <li class='nav-list'>
                            <a class='nav-item"""+(if val.child? and val.child.length then " parent" else "")+"""' href="javascript:void(0)" data-id='header"""+Menu::MenuHeadingCnt+"""'>"""+val.text+"""</a>"""
            Menu::MenuHeadingCnt++
            if val.child? and val.child.length

              htmlMenu += Menu::treeHTMLGenerate(val.child, true)

            htmlMenu += """</li>"""

          return htmlMenu += """</ul>"""

      Menu::listen = ()->
        Menu::navigation.find(".nav-item").off('click').on 'click', ->
          $(this).next().slideToggle 200 if $(this).hasClass("parent")
          $(this).parents(".nav").find(".active").removeClass 'active'
          $(this).parent().addClass('active').parents(".nav-list").addClass('active')
          return
        return

      Menu::offsetTop = ()->


        arr = jQuery.grep(_document.find("#viewDoc").find("h1,h2"), (val) ->
          $(val).offset().top-$(window).scrollTop()-_document.find(".header.cf").height() >= 0
        )
        if arr.length
          Menu::navigation.find(".active").removeClass 'active'
          if(arr[0].tagName.toLowerCase() is "h1")
            console.log(arr[0].tagName.toLowerCase())
            Menu::navigation.find(".nav > .nav-list").eq(_document.find("#viewDoc").find("h1").index($(arr[0]))).addClass('active')
          else
            Menu::navigation.find(".sub-nav > .nav-list").eq(_document.find("#viewDoc").find("h2").index($(arr[0]))).addClass('active').parents(".nav-list").addClass('active')






    menu = new Menu()
    app.Menu = menu.init()

