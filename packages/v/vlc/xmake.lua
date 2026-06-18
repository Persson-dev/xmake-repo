package("vlc")
    set_homepage("https://www.videolan.org/vlc/")
    set_description("VLC media player")
    set_license("LGPL 2.1")

	add_urls("https://code.videolan.org/videolan/vlc.git")

	add_versions("3.0.23-2", "79128878ddb2c280bbb6c89c76a46b31a80ade1c")

    add_deps("meson >= 1.10.0", "lua")

    add_configs("shared", {description = "Build shared library", default = true, type = "boolean", readonly = true})

    -- codecs
    add_configs("ffmpeg", {description = "Build with ffmpeg support", default = true, type = "boolean"})
    add_configs("mpg123", {description = "Build with mpg123 support", default = true, type = "boolean"})
    add_configs("vaapi", {description = "Build with libva support", default = true, type = "boolean"})
    add_configs("flac", {description = "Build with flac support", default = true, type = "boolean"})
    add_configs("vorbis", {description = "Build with ogg vorbis support", default = true, type = "boolean"})
    add_configs("opus", {description = "Build with opus support", default = true, type = "boolean"})
    add_configs("png", {description = "Build with png support", default = true, type = "boolean"})
    add_configs("jpeg", {description = "Build with jpeg support", default = true, type = "boolean"})
    add_configs("bpg", {description = "Build with bpg support", default = false, type = "boolean"})
    add_configs("x264", {description = "Build with x264 support", default = true, type = "boolean"})
    add_configs("x265", {description = "Build with x265 support", default = true, type = "boolean"})

    -- video
    add_configs("gles2", {description = "Build with OpenGL ES v2 support", default = false, type = "boolean"})
    add_configs("x11", {description = "Build with x11 support", default = false, type = "boolean", readonly = true})
    add_configs("wayland", {description = "Build with Wayland support", default = false, type = "boolean"})
    add_configs("sdl-image", {description = "Build with SDL image support", default = true, type = "boolean"})
    add_configs("freetype", {description = "Build with freetype support", default = false, type = "boolean"})

    -- audio
    add_configs("pulse", {description = "Build with PulseAudio support", default = true, type = "boolean"})
    add_configs("alsa", {description = "Build with Alsa support", default = true, type = "boolean"})
    add_configs("oss", {description = "Build with Open Sound System support", default = false, type = "boolean", readonly = true})
    add_configs("jack", {description = "Build with Jack support", default = true, type = "boolean"})

    on_load(function (package)
        if package:config("ffmpeg") then
            package:add("deps", "ffmpeg")
        end
        if package:config("mpg123") then
            package:add("deps", "mpg123")
        end
        if package:config("vaapi") then
            package:add("deps", "libva[drm]")
        end
        if package:config("flac") then
            package:add("deps", "libflac")
        end
        if package:config("vorbis") then
            package:add("deps", "libvorbis")
        end
        if package:config("opus") then
            package:add("deps", "libopus")
        end
        if package:config("png") then
            package:add("deps", "libpng")
        end
        if package:config("jpeg") then
            package:add("deps", "libjpeg")
        end
        if package:config("bpg") then
            package:add("deps", "libbpg")
        end
        if package:config("x264") then
            package:add("deps", "x264")
        end
        if package:config("x265") then
            package:add("deps", "x265")
        end

        if package:config("gles2") then
            package:add("deps", "opengl")
        end
        if package:config("wayland") then
            package:add("deps", "wayland")
        end
        if package:config("sdl-image") then
            package:add("deps", "libsdl2_image")
        end
        if package:config("freetype") then
            package:add("deps", "freetype")
        end

        if package:config("pulse") then
            package:add("deps", "pulseaudio")
        end
        if package:config("alsa") then
            package:add("deps", "alsa-lib")
        end
        if package:config("jack") then
            package:add("deps", "jack2")
        end
    end)


    on_install("linux", function (package)
        local configs = {}
        
        table.insert(configs, "--enable-avcodec=" .. (package:config("ffmpeg") and "yes" or "no"))
        table.insert(configs, "--enable-avformat=" .. (package:config("ffmpeg") and "yes" or "no"))
        table.insert(configs, "--enable-mpg123=" .. (package:config("mpg123") and "yes" or "no"))
        table.insert(configs, "--enable-libva=" .. (package:config("vaapi") and "yes" or "no"))
        table.insert(configs, "--enable-flac=" .. (package:config("flac") and "yes" or "no"))
        table.insert(configs, "--enable-vorbis=" .. (package:config("vorbis") and "yes" or "no"))
        table.insert(configs, "--enable-opus=" .. (package:config("opus") and "yes" or "no"))
        table.insert(configs, "--enable-png=" .. (package:config("png") and "yes" or "no"))
        table.insert(configs, "--enable-jpeg=" .. (package:config("jpeg") and "yes" or "no"))
        table.insert(configs, "--enable-bpg=" .. (package:config("bpg") and "yes" or "no"))
        table.insert(configs, "--enable-x265=" .. (package:config("x265") and "yes" or "no"))
        table.insert(configs, "--enable-x264=" .. (package:config("x264") and "yes" or "no"))
        if package:config("x264") then
            bit_depth = package:dep("x264"):config("bit-depth")
            table.insert(configs, "--enable-x26410b=" .. ((bit_depth == "10" or bit_depth == "all") and "yes" or "no"))
        end

        table.insert(configs, "--enable-gles2=" .. (package:config("gles2") and "yes" or "no"))
        table.insert(configs, "--enable-wayland=" .. (package:config("wayland") and "yes" or "no"))
        table.insert(configs, "--enable-sdl-image=" .. (package:config("sdl-image") and "yes" or "no"))
        table.insert(configs, "--enable-freetype=" .. (package:config("freetype") and "yes" or "no"))
        table.insert(configs, "--with-x=" .. (package:config("x11") and "yes" or "no"))
        table.insert(configs, "--enable-xcb=" .. (package:config("x11") and "yes" or "no"))
        table.insert(configs, "--enable-xvideo=" .. (package:config("x11") and "yes" or "no"))

        table.insert(configs, "--enable-pulse=" .. (package:config("pulse") and "yes" or "no"))
        table.insert(configs, "--enable-alsa=" .. (package:config("alsa") and "yes" or "no"))
        table.insert(configs, "--enable-oss=" .. (package:config("oss") and "yes" or "no"))
        if not package:config("jack") then
            table.insert(configs, "--disable-jack=")
        end

        table.insert(configs, "--enable-vlc=no") -- we only need libvlc

        os.vrun("sh ./bootstrap")
        import("package.tools.autoconf").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            void test() {
                /* Load the VLC engine */
                libvlc_instance_t * inst = libvlc_new (0, NULL);
            }
        ]]}, {includes = "vlc/vlc.h"}))
    end)