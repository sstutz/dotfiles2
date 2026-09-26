" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']
let g:ale_fix_on_save = 1

let g:LanguageClient_rootMarkers = {
    \ 'javascript': ['tsconfig.json', 'package.json'],
    \ 'javascriptreact': ['tsconfig.json', 'package.json'],
    \ }
