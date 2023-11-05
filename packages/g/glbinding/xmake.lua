package("glbinding")
    set_homepage("https://glbinding.org")
    set_description("A C++ binding for the OpenGL API, generated using the gl.xml specification. ")
    set_license("MIT")

    add_urls("https://github.com/cginternals/glbinding/archive/refs/tags/$(version).tar.gz",
             "https://github.com/cginternals/glbinding.git")

    add_versions("v3.3.0", "a0aa5e67b538649979a71705313fc2b2c3aa49cf9af62a97f7ee9a665fd30564")

    add_deps("cmake")

    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <glbinding/glbinding.h>
            #include <glbinding/gl/gl.h>
            using namespace gl;

            void test(int argc, char** argv) {
                glbinding::initialize(nullptr);

                glBegin(GL_TRIANGLES);
                glEnd();
            }
        ]]}, {configs = {languages = "cxx11"}}))
    end)
