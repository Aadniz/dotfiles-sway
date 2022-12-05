return require('packer').startup(function()
    --Plug 'ncm2/ncm2'
    -- use 'itchyny/lightline.vim'

    -- A better status line
    use 'godlygeek/tabular'  
    use 'patstockwell/vim-monokai-tasty'
    use 'ncm2/ncm2'  
    use 'Raimondi/delimitMate'  
    use 'junegunn/goyo.vim'  
    use 'vim-pandoc/vim-pandoc'  
    --Plug 'D3faIt/vim-rest-console'
    use 'scrooloose/nerdtree'
    use 'mg979/vim-visual-multi'

    -- Copy paste
    -- Collection of common configurations for the Nvim LSP client
    use 'neovim/nvim-lspconfig'
    use {
      'neoclide/coc.nvim', branch = 'release'
    }

    -- SCP upload / download
    use 'D3faIt/Vim-Jetbrains-Deployment'

    -- Autocompletion framework
    --use 'hrsh7th/nvim-cmp'
    -- cmp LSP completion
    --use 'hrsh7th/cmp-nvim-lsp'
    -- cmp Snippet completion
    --use 'hrsh7th/cmp-vsnip'
    -- cmp Path completion
    --use 'hrsh7th/cmp-path'
    --use 'hrsh7th/cmp-buffer'
    -- See hrsh7th other plugins for more great completion sources!

    -- Adds extra functionality over rust analyzer
    use 'simrat39/rust-tools.nvim'

    -- Telescope
    use "nvim-telescope/telescope.nvim"

    -- Treesitter
    use "nvim-treesitter/nvim-treesitter"

    -- Show indents
    use "lukas-reineke/indent-blankline.nvim"

    -- vimtex
    use 'lervag/vimtex'

    -- Markdown
    use 'SidOfc/mkdx'
    use {"ellisonleao/glow.nvim"}
    --use 'plasticboy/vim-markdown'  

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
end)
