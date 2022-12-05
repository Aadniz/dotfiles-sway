-- Plugins
require('plugins')
require('user.lualine')
require('user.lspconfig')
require('user.indent-blankline')

-- shortcut for mapping keys
local function map(m, k, v)
   vim.api.nvim_set_keymap(m, k, v, { silent = false})
end
-- Shortcut for mapping keys Silently
local function smap(m, k, v)
   vim.api.nvim_set_keymap(m, k, v, { silent = true})
end

-- Treat all .md files as markdown
vim.cmd('autocmd BufNewFile,BufRead *.md set filetype=markdown')

-- Highlight the line the cursor is on
vim.cmd('autocmd FileType markdown set cursorline')

-- Hide and format markdown elements like **bold**
vim.cmd('autocmd FileType markdown set conceallevel=2')

-- Omg jeg er så norsk!!!
-- vim.cmd('autocmd FileType markdown setlocal spell spelllang=nb')

--autocmd FileType markdown imap <C-O> <Esc>:w<CR><Esc>:Pandoc pdf<CR>
--autocmd FileType markdown map <C-O> <Esc>:w<CR><Esc>:Pandoc pdf<CR>

-- Monokai-tasty
vim.g.vim_monokai_tasty_italic = 1                  -- Allow italics.
vim.cmd('colorscheme vim-monokai-tasty')            -- Enable monokai theme.

-- LightLine.vim 
--vim.opt.laststatus=2              -- To tell Vim we want to see the statusline.
--vim.g.lightline.colorscheme = 'monokai_tasty'


-- NerdTree
smap("n", "<C-e>", '<Esc>:NERDTreeToggle<CR>')
smap("i", "<C-e>", '<Esc>:NERDTreeToggle<CR>')

-- Configuration for vim-markdown
--vim.g.vim_markdown_conceal = 2
--vim.g.vim_markdown_conceal_code_blocks = 0
--vim.g.vim_markdown_math = 1
--vim.g.vim_markdown_toml_frontmatter = 1
--vim.g.vim_markdown_frontmatter = 1
--vim.g.vim_markdown_strikethrough = 1
--vim.g.vim_markdown_autowrite = 1
--vim.g.vim_markdown_edit_url_in = 'tab'
--vim.g.vim_markdown_follow_anchor = 1

-- Rest VIM
vim.g.vrc_elasticsearch_support = 1
vim.g.vrc_syntax_highlight_response = 1
vim.g.vrc_output_buffer_name = '__VRC_OUTPUT.json'

-- Vimtex config
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_quickfix_mode = 0
vim.g.tex_conceal = 'abdmgs'
vim.g.indentLine_setConceal = 0

-- Neovide
require('neovide')

vim.opt.termguicolors=true
vim.opt.expandtab=true

-- Use two spaces instead of tabs
vim.opt.tabstop=4

-- The same but for indents
vim.opt.shiftwidth=4

-- Keep cursor in approximately the middle of the screen
vim.opt.scrolloff=12

-- Aadniz config

vim.opt.number=true
vim.opt.mouse="a"
vim.opt.wrap=false
vim.opt.clipboard:append("unnamedplus")

map("n", "-", ":")

-- Make vim act like nano
-- just save
smap("n", "<C-O>", "<Esc>:w<CR>")
smap("i", "<C-O>", "<Esc>:w<CR>")

-- save and quit
smap("n", "<C-X>y", "<Esc>:wq<CR>")
smap("i", "<C-X>y", "<Esc>:wq<CR>")
  
-- try to quit  
smap("n", "<C-X>", "<Esc>:q<CR>")
smap("i", "<C-X>", "<Esc>:q<CR>")
  
-- force quit  
smap("n", "<C-X><C-X>", "<Esc>:q!<CR>")
smap("i", "<C-X><C-X>", "<Esc>:q!<CR>")
  
-- remove line
--smap <C-K> <Esc>dd
--imap <C-K> <Esc>dd<Esc>i
  
-- Search
map("n", "<C-f>", "<Esc>/", false)
map("i", "<C-f>", "<Esc>/", false)
  
-- Multi cursor options
-- let g:multi_cursor_start_word_key      = '<C-n>'
-- let g:multi_cursor_select_all_word_key = '<A-n>'
-- let g:multi_cursor_start_key           = 'g<C-n>'
-- let g:multi_cursor_select_all_key      = 'g<A-n>'
-- let g:multi_cursor_next_key            = '<C-n>'
-- let g:multi_cursor_prev_key            = '<C-p>'
-- let g:multi_cursor_skip_key            = '<C-x>'
-- let g:multi_cursor_quit_key            = '<Esc>'
vim.g.VM_maps = {
  ["Select Cursor Down"] = '<M-j>', 
  ["Select Cursor Up"] = '<M-k>' 
}
vim.g.multi_cursor_quit_key = "<C-c>"

-- shift+vim keys selection
smap("n", "<S-k>", "vk")
smap("v", "<S-k>", "k ")
-- smap("i", "<S-k>", "<Esc>vk")
smap("n", "<S-j>", "vj")
smap("v", "<S-j>", "j ")
-- smap("i", "<S-j>", "<Esc>vj")
smap("n", "<S-h>", "vh")
smap("v", "<S-h>", "h ")
-- smap("i", "<S-h>", "<Esc>vh")
smap("n", "<S-l>", "vl")
smap("v", "<S-l>", "l ")
-- smap("i", "<S-l>", "<Esc>lvl")
smap("n", "<S-Home>", "v<Home>")
smap("v", "<S-Home>", "<Home>")
smap("i", "<S-Home>", "<Esc>v<Home>")
smap("n", "<S-End>", "v<End><Left>")
smap("v", "<S-End>", "<End><Left>")
smap("i", "<S-End>", "<Esc><Right>v<End><Left>")

-- Navigating splits
smap("n", "<C-h>", "<C-w>h")
smap("n", "<C-j>", "<C-w>j")
smap("n", "<C-k>", "<C-w>k")
smap("n", "<C-l>", "<C-w>l")

-- Moving
--nmap <C-Up> <C-u>
--nmap <C-Down> <C-d>
--imap <C-Up> <Esc><C-u>i
--imap <C-Down> <Esc><C-d>i

-- Highlight and then search
--vim.api.nvim_set_keymap("v", "//" 'y/\V<C-R>=escape(@",\'/\')<CR><CR>')
-- Search and replace
--vnoremap <C-R> y:%s/<C-R>=escape(@",'/\')<CR>//g<Left><Left>

-- prevent cut
--nnoremap d "_d


