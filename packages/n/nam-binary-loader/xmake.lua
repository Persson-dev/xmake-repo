package("nam-binary-loader")
    set_homepage("https://github.com/tone-3000/nam-binary-loader")
    set_description("Binary file format and loader for Neural Amp Modeler")
    set_license("MIT")

    add_urls("https://github.com/tone-3000/nam-binary-loader.git")

    add_versions("2026.04.16", "92c9e85bb7903ccbfd3264d3f7bcb5fee6c0892d")

    add_patches("2026.04.16", path.join(os.scriptdir(), "patches", "2026.04.16", "nam.patch"), "b9bd21e4e95e8127247ec0990efc3ad0b74c624ec8b0da0aa10751f710eba7be")

    add_deps("nam-core")

    on_install("!bsd", function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")

            add_requires("nam-core")
            add_packages("nam-core")

            set_languages("c++17")

            target("NamBinaryLoader")
                add_files("namb/**.cpp")
                add_includedirs("namb")
                add_headerfiles("(namb/**.h)", "(namb/**.hpp)")
                set_kind("$(kind)")
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:has_cxxfuncs("nam::get_dsp_namb(\"\")", {includes = "namb/get_dsp_namb.h", configs = {languages = "c++17"}}))
    end)
