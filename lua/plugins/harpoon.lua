-- Harpoon - Quick file navigation
return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            -- Setup harpoon
            harpoon:setup({
                settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true,
                    key = function()
                        return vim.loop.cwd()
                    end,
                },
            })

            -- Keymaps
            vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Open harpoon window" })

            vim.keymap.set("n", "<leader>H", function()
                harpoon:list():add()
            end, { desc = "Add current file to harpoon" })

            -- Quick navigation to harpoon files
            vim.keymap.set("n", "<leader>1", function()
                harpoon:list():select(1)
            end, { desc = "Harpoon file 1" })

            vim.keymap.set("n", "<leader>2", function()
                harpoon:list():select(2)
            end, { desc = "Harpoon file 2" })

            vim.keymap.set("n", "<leader>3", function()
                harpoon:list():select(3)
            end, { desc = "Harpoon file 3" })

            vim.keymap.set("n", "<leader>4", function()
                harpoon:list():select(4)
            end, { desc = "Harpoon file 4" })

            vim.keymap.set("n", "<leader>5", function()
                harpoon:list():select(5)
            end, { desc = "Harpoon file 5" })

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<C-S-P>", function()
                harpoon:list():prev()
            end, { desc = "Previous harpoon file" })

            vim.keymap.set("n", "<C-S-N>", function()
                harpoon:list():next()
            end, { desc = "Next harpoon file" })

            -- Clear all harpoon marks
            vim.keymap.set("n", "<leader>hc", function()
                harpoon:list():clear()
            end, { desc = "Clear all harpoon marks" })

            -- Remove current file from harpoon
            vim.keymap.set("n", "<leader>hr", function()
                harpoon:list():remove()
            end, { desc = "Remove current file from harpoon" })
        end,
    },
}
