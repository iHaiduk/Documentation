###*
# Created by Igor on 02.08.2015.
###

app =
    editor: null
    Menu: null
    path: "../"

require.config
    paths:
        "jquery": "Library/jquery.min"
        "hljs": "Library/highlight.pack"
        "redactor": "Library/redactor"
    shim:
        "jquery": exports: "$"
        "redactor": deps: [ "jquery" ]

@loadApplication = (name) ->
    requirejs [
        "jquery"
        "hljs"
        "redactor"
    ], ($, hljs) ->
        require [ "Application/app" ]
        require [ "Application/menu" ]
        return
    return