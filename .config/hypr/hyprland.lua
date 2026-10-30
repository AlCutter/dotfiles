-- Hyprland Lua configuration
-- Migrated from the legacy hyprland.conf (hyprlang) for Hyprland 0.55+.
-- Docs: https://wiki.hypr.land/configuring/core/

----------------
---- THEME ----
----------------

-- Rose Pine "Mocha" palette (converted from mocha.conf)
local mocha = require("mocha")

---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "wezterm"
local fileManager = "nautilus"
local menu        = "wofi"

local mainMod = "SUPER"

------------------
---- MONITORS ----
------------------

-- old: monitor=,preferred,auto,1.333333
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1.333333,
})

-------------------
---- AUTOSTART ----
-------------------

-- old: exec-once lines (hyprland.start fires once per session)
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hyprpolkitagent")
    hl.exec_cmd("mako")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("HYPRCURSOR_SIZE", "32")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 4,

        border_size = 2,

        col = {
            active_border   = mocha.green,
            inactive_border = mocha.surface1,
        },

        layout = "dwindle",
    },

    decoration = {
        shadow = {
            enabled = true,
        },
        blur = {
            enabled = true,
        },
        rounding = 3,
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    -- inert while using dwindle, kept for parity with the old config
    master = {
        new_status = "master",
    },

    misc = {
        disable_hyprland_logo = false,
        background_color      = "#000000",
    },

    input = {
        sensitivity = 0,

        kb_layout = "gb",

        follow_mouse = 1,

        force_no_accel = false,
        natural_scroll = true,

        touchpad = {
            natural_scroll = true,
            scroll_factor  = 0.2,
        },
    },

    -- from the old `source = ./hyprviz.conf` (Hyprland's own ecosystem options)
    ecosystem = {
        no_donation_nag = true,
        no_update_news  = true,
    },
})

-- old: animation = global, 1, 2.5, default / animation = layers, 1, 2.5, default, popin
hl.animation({ leaf = "global", enabled = true, speed = 2.5, bezier = "default" })
hl.animation({ leaf = "layers", enabled = true, speed = 2.5, bezier = "default", style = "popin" })

-- old: layerrule=animation slide right notifications
-- slide mako's notifications in from the right
hl.layer_rule({
    match = { namespace = "notifications" },
    animation = "slide right",
})

----------------
---- DEVICES ----
----------------

-- old: device { name = "apple-spi-trackpad", sensitivity = 0 }
hl.device({
    name        = "apple-spi-trackpad",
    sensitivity = 0,
})

---------------
---- BINDS ----
---------------

-- Screenshot of a selected area (old: bind = $mainMod, O, exec, grim ...)
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(
    "grim -g \"$(slurp)\" $HOME/me/img/screenshots/$(date +'%s_scrnsht.png')"))

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + X", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.window.float())
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Focus movement (old: movefocus l/r/u/d)
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-9 and 10 (on key 0); SHIFT moves the window (old: workspace / movetoworkspace)
for i = 1, 10 do
    local key = i % 10 -- workspace 10 lives on key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace / scratchpad (old: togglespecialworkspace magic)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll between workspaces (old: workspace e+1 / e-1)
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows (old: bindm = $mainMod, mouse:272, movewindow / resizewindow)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, drag = true })
hl.bind(mainMod .. " + SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true, drag = true })

-- Volume and brightness (old: bindel — also works while locked)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),   { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),   { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),  { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 5%+"),                        { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"),                        { locked = true })

-- Media keys (old: bindl — long press)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { long_press = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { long_press = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { long_press = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { long_press = true })
