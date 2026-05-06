return {{
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = {"BufReadPost", "BufNewFile"},

    dependencies = {"nvim-treesitter/nvim-treesitter-textobjects"},

    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {"c", "cpp", "python", "lua", "vim", "vimdoc", "cmake", "make", "bash", "fish", "json",
                                "yaml", "toml", "markdown", "markdown_inline", "git_config", "gitcommit", "diff"},

            auto_install = true,

            highlight = {
                enable = true,
                disable = function(_, buf)
                    local max_filesize = 1024 * 1024
                    local filename = vim.api.nvim_buf_get_name(buf)
                    local ok, stats = pcall(vim.uv.fs_stat, filename)

                    return ok and stats and stats.size > max_filesize
                end,
                additional_vim_regex_highlighting = false
            },

            indent = {
                enable = true
            },

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["ab"] = "@block.outer",
                        ["ib"] = "@block.inner"
                    }
                },

                move = {
                    enable = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer"
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer"
                    }
                }
            }
        })
    end
}, {
    "nvim-treesitter/nvim-treesitter-context",
    event = {"BufReadPost", "BufNewFile"},
    opts = {
        max_lines = 4,
        trim_scope = "outer"
    }
}}
