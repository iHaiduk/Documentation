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
        "font": "http://use.typekit.net/dwg6kzf"
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
        "font"
        "codemirror"
    ], ($, hljs) ->
        require [ "Application/app" ]
        require [ "Application/menu" ]
        return
    return