" setlocal omnifunc=phpactor#Complete
setlocal commentstring=//\ %s
setlocal keywordprg=:terminal++close\ pman
setlocal grepprg=rg\ --vimgrep\ --type\ php
setlocal suffixesadd+=.php

let g:ale_php_phpmd_ruleset='phpmd.xml'
let b:ale_linters = ['phpcs']
let b:ale_fixers = ['phpcbf', 'php_cs_fixer']

" Include use statement
nmap <buffer> <Leader>u :PhpactorImportClass<cr>

" Invoke the context menu
nmap <buffer> <F5> :PhpactorContextMenu<cr>

" Goto definition of class or class member under the cursor
" nnoremap <buffer> gd :PhpactorGotoDefinition<cr>
" nnoremap <buffer> gr :PhpactorFindReferences<cr>
" nnoremap <buffer> gi :PhpactorGotoImplementations<cr>
" nnoremap <buffer> K :PhpactorHover<CR>

" Transform the classes in the current file
nmap <buffer> <Leader>tt :PhpactorTransform<CR>

" Extract method from selection
vmap <silent><buffer><Leader>em :<C-U>PhpactorExtractMethod<CR>
