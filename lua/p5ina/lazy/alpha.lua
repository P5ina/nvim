return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- Custom ASCII art header
        dashboard.section.header.val = {
            [[██████╗ ███████╗██╗███╗   ██╗ █████╗ ]],
            [[██╔══██╗██╔════╝██║████╗  ██║██╔══██╗]],
            [[██████╔╝███████╗██║██╔██╗ ██║███████║]],
            [[██╔═══╝ ╚════██║██║██║╚██╗██║██╔══██║]],
            [[██║     ███████║██║██║ ╚████║██║  ██║]],
            [[╚═╝     ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝]],
        }

        -- Menu buttons
        dashboard.section.buttons.val = {
            dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
            dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
            dashboard.button("g", "  Find text", ":Telescope live_grep<CR>"),
            dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
            dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
            dashboard.button("q", "  Quit", ":qa<CR>"),
        }

        -- Footer
        dashboard.section.footer.val = "Welcome back, p5ina!"

        -- Layout
        dashboard.config.layout = {
            { type = "padding", val = 4 },
            dashboard.section.header,
            { type = "padding", val = 2 },
            dashboard.section.buttons,
            { type = "padding", val = 1 },
            dashboard.section.footer,
        }

        alpha.setup(dashboard.config)
    end,
}
