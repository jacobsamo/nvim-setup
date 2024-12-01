-- Undo tree - an advanced undo tree allowing for more control than just Ctrl + Z
return {
    "mbbill/undotree",

    config = function() 
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end
}
