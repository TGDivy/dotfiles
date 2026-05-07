return
    { -- ── Mason: LSP installer ───────────────────────────────────────────────────
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            },
            -- Formatters/tools installed via mason (not LSPs)
            ensure_installed = { "prettier", "stylua" },
        }
    },
    -- mason-tool-installer: handles non-LSP tools (formatters, linters)
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = { "prettier", "stylua" },
            auto_update = false,
        },
    },

    -- ── Mason-lspconfig bridge ─────────────────────────────────────────────────
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {"williamboman/mason.nvim"},
        opts = {
            -- Note: ruff and basedpyright excluded — Mason can't install them on
            -- RHEL 8 (Python 3.6 too old). Install via: uv tool install ruff basedpyright
            ensure_installed = {"clangd", "neocmake", "lua_ls", "marksman", "jsonls", "yamlls", "ts_ls", "taplo"},
            automatic_installation = true
        }
    },

    -- ── LSP Config ─────────────────────────────────────────────────────────────
    {
        "neovim/nvim-lspconfig",
        dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp", {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {}
        }},

        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- ── Shared keymaps ─────────────────────────────────────────────────────
            local on_attach = function(_, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, {
                        buffer = bufnr,
                        desc = "LSP: " .. desc
                    })
                end

                local b = require("telescope.builtin")

                map("gd", b.lsp_definitions, "Go to definition")
                map("gD", vim.lsp.buf.declaration, "Go to declaration")
                map("gr", b.lsp_references, "Go to references")
                map("gi", b.lsp_implementations, "Go to implementation")
                map("gt", b.lsp_type_definitions, "Go to type definition")

                map("K", vim.lsp.buf.hover, "Hover docs")
                map("<C-s>", vim.lsp.buf.signature_help, "Signature help")

                map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
                map("<leader>la", vim.lsp.buf.code_action, "Code action")

                map("<leader>lf", function()
                    vim.lsp.buf.format({
                        async = true
                    })
                end, "Format buffer")

                map("<leader>li", "<cmd>LspInfo<cr>", "LSP info")
            end

            -- ── clangd: switch header/source ──────────────────────────────────────
            vim.keymap.set("n", "<leader>lh",
              "<cmd>ClangdSwitchSourceHeader<cr>",
              { desc = "LSP: switch header/source (C++)" })

            -- ── clangd ────────────────────────────────────────────────────────────
            vim.lsp.config("clangd", {
                capabilities = capabilities,
                on_attach = on_attach,

                cmd = {"clangd", "--background-index", "--clang-tidy", "--header-insertion=never",
                       "--completion-style=detailed", "--function-arg-placeholders", "--fallback-style=llvm",
                       "--offset-encoding=utf-16"},

                filetypes = {"c", "cpp", "objc", "objcpp"},

                root_dir = function(bufnr)
                    return vim.fs.root(bufnr, {"compile_commands.json", "compile_flags.txt", "CMakeLists.txt", ".git"})
                end
            })

            -- ── basedpyright ──────────────────────────────────────────────────────
            vim.lsp.config("basedpyright", {
                capabilities = capabilities,
                on_attach = on_attach,

                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "standard",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "openFilesOnly"
                        }
                    }
                }
            })

            -- ── ruff ──────────────────────────────────────────────────────────────
            vim.lsp.config("ruff", {
                capabilities = capabilities,

                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)

                    -- Prefer basedpyright hover
                    client.server_capabilities.hoverProvider = false
                end
            })

            -- ── neocmake ──────────────────────────────────────────────────────────
            vim.lsp.config("neocmake", {
                capabilities = capabilities,
                on_attach = on_attach
            })

            -- ── marksman ──────────────────────────────────────────────────────────
            vim.lsp.config("marksman", {
                capabilities = capabilities,
                on_attach = on_attach
            })

            -- ── lua_ls ────────────────────────────────────────────────────────────
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                on_attach = on_attach,

                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {"vim"}
                        },

                        workspace = {
                            checkThirdParty = false
                        },

                        telemetry = {
                            enable = false
                        }
                    }
                }
            })

            -- ── jsonls ────────────────────────────────────────────────────────────
            vim.lsp.config("jsonls", {
                capabilities = capabilities,
                on_attach = on_attach
            })

            -- ── yamlls ────────────────────────────────────────────────────────────
            vim.lsp.config("yamlls", {
                capabilities = capabilities,
                on_attach = on_attach
            })

            -- ── ts_ls (TypeScript) ────────────────────────────────────────────────
            vim.lsp.config("ts_ls", {
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
            })

            -- ── taplo (TOML) ──────────────────────────────────────────────────────
            vim.lsp.config("taplo", {
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- ── Enable servers ────────────────────────────────────────────────────
            vim.lsp.enable({"clangd", "basedpyright", "ruff", "neocmake", "marksman", "lua_ls", "jsonls", "yamlls", "ts_ls", "taplo"})

            -- ── Diagnostics UI ────────────────────────────────────────────────────
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                    source = "if_many"
                },

                signs = true,
                update_in_insert = false,
                severity_sort = true,

                float = {
                    border = "rounded",
                    source = true
                }
            })

            local signs = {
                Error = " ",
                Warn = " ",
                Hint = "󰠠 ",
                Info = " "
            }

            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type

                vim.fn.sign_define(hl, {
                    text = icon,
                    texthl = hl,
                    numhl = ""
                })
            end
        end
    }}
