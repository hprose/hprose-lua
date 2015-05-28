package = "hprose"
version = "1.0.1"
source = {
    url = "git://github.com/hprose/hprose-lua",
    tag = "v1.0.1"
}
description = {
    summary = "Hprose for Lua",
    detailed = [[
        Hprose is a High Performance Remote Object Service Engine.

        It is a modern, lightweight, cross-language, cross-platform, object-oriented, high performance, remote dynamic communication middleware. It is not only easy to use, but powerful. You just need a little time to learn, then you can use it to easily construct cross language cross platform distributed application system.

        Hprose supports many programming languages, for example:

                AAuto Quicker
                ActionScript
                ASP
                C++
                Dart
                Delphi/Free Pascal
                dotNET(C#, Visual Basic...)
                Golang
                Java
                JavaScript
                Node.js
                Objective-C
                Perl
                PHP
                Python
                Ruby
                ...

        Through Hprose, You can conveniently and efficiently intercommunicate between those programming languages.

        This project is the implementation of Hprose for Lua.
    ]],
    homepage = "http://hprose.com",
    license = "MIT"
}
dependencies = {
    "lua >= 5.1",
    "luasocket"
}
build = {
    type = "builtin",
    modules = {
        hprose = "src/hprose.lua",
        ["hprose.common"] = "src/hprose/common.lua",
        ["hprose.tags"] = "src/hprose/tags.lua",
        ["hprose.result_mode"] = "src/hprose/result_mode.lua",
        ["hprose.input_stream"] = "src/hprose/input_stream.lua",
        ["hprose.output_stream"] = "src/hprose/output_stream.lua",
        ["hprose.class_manager"] = "src/hprose/class_manager.lua",
        ["hprose.reader"] = "src/hprose/reader.lua",
        ["hprose.writer"] = "src/hprose/writer.lua",
        ["hprose.formatter"] = "src/hprose/formatter.lua",
        ["hprose.client"] = "src/hprose/client.lua",
        ["hprose.http_client"] = "src/hprose/http_client.lua",
        ["hprose.tcp_client"] = "src/hprose/tcp_client.lua",
    }
}
