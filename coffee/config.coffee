###*
# Created by Igor on 02.08.2015.
###

app =
    editor: null
    Menu: null
    path: "../"

require.config
    waitSeconds: 200
    paths:
        "jquery": "Library/jquery.min"
        "redactor": "Library/redactor"
    shim:
        "jquery": exports: "$"
        "font": exports: "Typekit"
        "redactor": deps: [ "jquery" ]

    packages: [
        {
            name: 'codemirror'
            location: 'CodeMirror'
            main: 'lib/codemirror'
        }
    ]

@loadApplication = (name) ->
    requirejs [
        "jquery"
        "redactor"
        "codemirror"
    ], ($, hljs) ->
        require [ "Application/app" ]
        require [ "Application/menu" ]
        return
    return