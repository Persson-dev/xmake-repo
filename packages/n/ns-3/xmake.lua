package("ns-3")
    set_homepage("https://www.nsnam.org/")
    set_description("Discrete-event network simulator for Internet systems")

    add_urls("https://www.nsnam.org/releases/ns-$(version).tar.bz2")

    add_versions("3.49", "81c9eb0839d2b527e9cc01db7eb0a521d8fc6a520ebb23d17f3a5c96e47b4d68")

    add_configs("assert", { description = "Enable assert on failure", default = false, type = "boolean" })
    add_configs("gtk", { description = "Build with GTK3 support", default = false, type = "boolean", readonly = true })
    add_configs("log", { description = "Enable logging to be built", default = false, type = "boolean" })
    add_configs("native_optimization", { description = "Build with -march=native -mtune=native", default = true, type = "boolean" })
    add_configs("sqlite", { description = "Build with SQLite support", default = false, type = "boolean" })

    add_deps("cmake")

    on_load( function (package)
        if package:config("sqlite") then
            package:add("deps", "sqlite3")
        end
    end)

    on_install( function (package)
        local configs = { }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DNS3_STATIC=" .. (package:config("shared") and "OFF" or "ON"))
        table.insert(configs, "-DNS3_ASSERT=" .. (package:config("assert") and "ON" or "OFF"))
        table.insert(configs, "-DNS3_GTK3=" .. (package:config("gtk") and "ON" or "OFF"))
        table.insert(configs, "-DNS3_LOG=" .. (package:config("log") and "ON" or "OFF"))
        table.insert(configs, "-DNS3_SQLITE=" .. (package:config("sqlite") and "ON" or "OFF"))
        table.insert(configs, "-DNS3_NATIVE_OPTIMIZATIONS=" .. (package:config("native_optimization") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test( function (package)
        assert(package:check_cxxsnippets({ test = [[
            void test() {
                ns3::NodeContainer nodes;
                nodes.Create(2);
            }
        ]] }, { configs = { languages = "c++23" }, includes = "ns3/core-module.h" }))
    end)
