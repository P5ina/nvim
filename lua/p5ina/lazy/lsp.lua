return {
  {
    'williamboman/mason.nvim',
    lazy = false,
    opts = {},
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        sources = {
          { name = 'nvim_lsp' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    init = function()
      -- Reserve a space in the gutter
      -- This will avoid an annoying layout shift in the screen
      vim.opt.signcolumn = 'yes'
    end,
    config = function()
      local lsp_defaults = require('lspconfig').util.default_config

      -- Add cmp_nvim_lsp capabilities settings to lspconfig
      -- This should be executed before you configure any language server
      lsp_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      -- LspAttach is where you enable features that only work
      -- if there is a language server active in the file
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local wk = require("which-key")

          wk.add({
            mode = { 'n' },
            expand = function()
              return event.buffer
            end,
            {
              'K',
              '<cmd>lua vim.lsp.buf.hover()<cr>',
              desc = 'Displays hover information about the symbol'
            },
            {
              'gd',
              '<cmd>lua vim.lsp.buf.definition()<cr>',
              desc = 'Jumps to definition'
            },
            {
              '<F3>',
              '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
              mode = { 'n', 'x' },
              desc = 'Format file or selected buffer'
            },
            {
              'gD',
              '<cmd>lua vim.lsp.buf.declaration()<cr>',
              desc = 'Jump to declaration'
            },
            {
              'gi',
              '<cmd>lua vim.lsp.buf.implementation()<cr>',
              desc = 'Jump to implementation'
            },
            {
              '<F2>',
              '<cmd>lua vim.lsp.buf.rename()<cr>',
              desc = 'Rename symbol'
            },
          })
          -- vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          -- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          -- vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          -- vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = event.buf,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = event.buf,
                  filter = function(c)
                    if c.name == 'ts_ls' then
                      return false
                    end
                    return true
                  end,
                })
              end,
            })
          end
        end,
      })

      require('mason-lspconfig').setup({
        ensure_installed = {'lua_ls', 'rust_analyzer', 'biome', 'ts_ls'},
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
        }
      })
    end
  }
}
