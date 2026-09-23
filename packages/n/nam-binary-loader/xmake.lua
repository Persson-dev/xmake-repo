package("nam-binary-loader")
    set_homepage("https://github.com/tone-3000/nam-binary-loader")
    set_description("Binary file format and loader for Neural Amp Modeler")
    set_license("MIT")

    add_urls("https://github.com/tone-3000/nam-binary-loader.git")

    add_versions("2026.02.26", "5aaaa61b1f07cc5ac17c4562a6f971b4ba0ee576")

    add_deps("nam-core 2026.02.24")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")

            add_requires("nam-core", "eigen", "nlohmann_json")
            add_packages("nam-core", "eigen", "nlohmann_json")

            target("NamBinaryLoader")
                add_files("namb/**.cpp")
                add_includedirs("namb")
                add_headerfiles("(namb/**.h)", "(namb/**.hpp)")
                set_kind("$(kind)")
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:has_cxxfuncs("nam::get_dsp_namb(\"\")", {includes = "namb/get_dsp_namb.h"}))
    end)
