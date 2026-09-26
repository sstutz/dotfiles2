" Polyglot: {{{
let g:polyglot_disabled = ['go', 'elm', 'csv']
" }}}

" VimPlug: {{{
call plug#begin(g:configpath . '/plugged')
" Visual Helpers
Plug 'vim-airline/vim-airline'
Plug 'mhinz/vim-signify'
Plug 'kshenoy/vim-signature'
Plug 'junegunn/vim-peekaboo'
Plug 'markonm/traces.vim'
Plug 'Shougo/echodoc.vim'

" Colors
Plug 'gruvbox-community/gruvbox'

" Misc
Plug 'preservim/tagbar', { 'on': 'TagbarToggle' }
Plug 'dense-analysis/ale'
Plug 'machakann/vim-sandwich'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-test/vim-test'
Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-plug'
Plug 'wellle/targets.vim'
Plug 'romainl/vim-qf'

Plug 'editorconfig/editorconfig-vim'

" Language Server Protocol Support
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" Language Support
Plug 'govim/govim', { 'for': 'go' }
Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
Plug 'vim-vdebug/vdebug', { 'for': 'php', 'on': 'Breakpoint' }
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'javascriptreact'] }
Plug 'earthly/earthly.vim', { 'for': 'Earthfile', 'branch': 'main' }
Plug 'metakirby5/codi.vim'


" Autocompletion
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'cohama/lexima.vim'
Plug 'sheerun/vim-polyglot'
call plug#end()
" }}}

" AirlineVim: {{{
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" }}}

" Ale: {{{
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_echo_msg_format = '[%linter%] %(code): %%s [%severity%]'
let g:ale_open_list = 1
let g:ale_list_window_size = 5
" }}}

" VimTest: {{{
if filereadable('docker/deploy.sh') || filereadable('.docker/deploy.sh')
    function! DockerTransform(cmd) abort
        return './docker/deploy.sh exec php bash -c "XDEBUG_CONFIG=idekey=docker APP_ENV=testing ' . a:cmd . '"'
    endfunction
    let g:test#custom_transformations = {'docker': function('DockerTransform')}
    let g:test#transformation = 'docker'
endif
let test#vim#term_position = 'vertical'
let test#strategy = 'vimterminal'
let test#php#phpunit#options = '--no-coverage'

nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>gt :TestVisit<CR>
" }}}

" Editorconfig: {{{
let g:EditorConfig_core_mode = 'vim_core'
let g:EditorConfig_exclude_patterns = ['scp://.*']
" }}}

" Phpactor: {{{
let g:phpactorOmniError = v:true
let g:phpactorOmniAutoClassImport = v:true
if (executable('fzf'))
    let g:phpactorInputListStrategy = 'phpactor#input#list#fzf'
    let g:phpactorQuickfixStrategy = 'phpactor#quickfix#fzf'
endif
" }}}

" Vdebug: {{{
let g:vdebug_keymap = {
            \   'run' : '<Leader><F5>',
            \   'run_to_cursor' : '<Down>',
            \   'step_over' : '<Up>',
            \   'step_into' : '<Left>',
            \   'step_out' : '<Right>',
            \   'close' : '<leader>q',
            \   'detach' : '<F7>',
            \   'set_breakpoint' : '<Leader>b',
            \   'eval_visual' : '<Leader>e'
            \}

" Mapping '/remote/path' : '/local/path'
let g:vdebug_options= {
            \   'port' : 9001,
            \   'server' : 'localhost',
            \   'timeout' : 30,
            \   'on_close' : 'detach',
            \   'break_on_open' : 1,
            \   'max_children' : 128,
            \   'ide_key' : 'docker',
            \   'path_maps' : {
            \       '/var/www/html': '~/Projects/work/portal'
            \   },
            \   'debug_window_level' : 0,
            \   'debug_file_level' : 0,
            \   'debug_file' : '/tmp/vdebug.log',
            \   'watch_window_style' : 'expanded',
            \}
" }}}

" FZF: {{{
if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --smart-case --hidden -l -i ""'
elseif executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag --hidden -l -g ""'
endif

let g:fzf_preview_window = 'right:60%'

noremap <leader>G :Find <c-r>=expand("<cword>")<cr><cr>
noremap <leader>/ :Lines<cr>
noremap <silent><c-p> :Files<cr>
" }}}

" Emmet: {{{
let g:user_emmet_leader_key = ','
let g:user_emmet_settings = {
    \  'javascriptreact' : {
    \      'extends' : 'jsx',
    \  },
    \  'vue' : {
    \      'extends' : 'js',
    \  },
    \}
" }}}

" Echodoc.vim: {{{
set cmdheight=2
let g:echodoc_enable_at_startup = 1
let g:echodoc#type = 'signature'
" }}}

" vim-lsp {{{
" disable diagnostics support, ALE takes care of that
let g:lsp_diagnostics_enabled = 0

" let g:lsp_use_native_client = 1

let g:lsp_semantic_enabled = 1

" let the LSP take care of folding
set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    nnoremap <buffer> gQ :<C-u>LspDocumentFormat<CR>
    vnoremap <buffer> gQ :LspDocumentRangeFormat<CR>
    nnoremap <buffer> <leader>ca :LspCodeAction<CR>
    nnoremap <buffer> <leader>cl :LspCodeLens<CR>

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    let g:lsp_preview_float = 1
    let g:lsp_diagnostics_echo_cursor = 1
    let g:lsp_documentation_float_docked = 1
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" }}}

" Tagbar: {{{
noremap <C-t> :TagbarToggle<CR>
let g:tagbar_position = 'topleft vertical'
" }}}

" extends % functionality
runtime! macros/matchit.vim

packadd! editorconfig

" man pages viewer
runtime! ftplugin/man.vim

" use vim-surround like keybindings
runtime! macros/sandwich/keymap/surround.vim

" vim: set sw=4 ts=8 sts=4 et tw=78 foldenable foldmethod=marker spell:
