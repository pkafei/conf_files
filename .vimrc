""General Setup
execute pathogen#infect()
execute pathogen#helptags()
syntax on
filetype plugin indent on

""Setup
set modifiable
set number
set paste

"Flake8"
autocmd BufWritePost *.py call Flake8()
autocmd BufWritePre * :%s/\s\+$//e

"""basic syntax settings
syntax on "syntax highlighing
filetype on "try to detect filetypes
filetype plugin indent on "enable loading indent file for filetype

""" saving
set nobackup
set nowritebackup
set noswapfile
set noautowrite "Never write a file unless I request it.
set noautoread " Don't automatically re-read changed files.

"""indentation
set tabstop=4 "<tab> inserts 4 spaces
set shiftwidth=4 "<BS> oer an autoindentation deletes both spaces.
set expandtab "Uses spaces, not tabs, for autoindent/tab key.
set shiftround "rounds indent to a multiple of shiftwidth

"""completions
set wildmode=longest,list "<Tab> cycles between all matches choices.
set wildignore+=*.o,*.obj,.git,*.pyc,.svn,.bzr
set tildeop
set completeopt=longest

"""saving
set nobackup
set nowritebackup
set noswapfile
set noautowrite " Never write a file unless I request it.
set noautowriteall " NEVER.
set noautoread " Don't automatically re-read changed files.

"""python
" au BufRead *.py compiler nose
" au FileType python set omnifunc=pythoncomplete#Complete
augroup py
    autocmd!
    au FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 nosmartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

function! SuperCleverTab()
    if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
        return "\<tab>"
    else
        return "\<C-P>"
    endif
endfunction
inoremap <Tab> <C-R>=SuperCleverTab()<cr>

let g:pyindent_open_paren = '&sw'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue = '&sw'


" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
  endif
  let b:did_indent = 1

  setlocal nosmartindent

" Now, set up our indentation expression and keys that trigger it.
setlocal indentexpr=GetJavascriptIndent()
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e

" Only define the function once.
if exists("*GetJavascriptIndent")
    finish
endif

let s:cpo_save = &cpo
set cpo&vim


" 1. Variables {{{1
" ============

let s:js_keywords = '^\s*\(break\|case\|catch\|continue\|debugger\|default\|delete\|do\|else\|finally\|for\|function\|if\|in\|instanceof\|new\|return\|switch\|this\|throw\|try\|typeof\|var\|void\|while\|with\)'

" Regex of syntax group names that are or delimit string or are comments.
let s:syng_strcom = 'string\|regex\|comment\c'

" Regex of syntax group names that are strings.
let s:syng_string = 'regex\c'

" Regex of syntax group names that are strings or documentation.
let s:syng_multiline = 'comment\c'

" Regex of syntax group names that are line comment.
let s:syng_linecom = 'linecomment\c'

" Expression used to check whether we should skip a match with searchpair().
let s:skip_expr = "synIDattr(synID(line('.'),col('.'),1),'name') =~ '".s:syng_strcom."'"

let s:line_term = '\s*\%(\%(\/\/\).*\)\=$'

" Regex that defines continuation lines, not including (, {, or [.
let s:continuation_regex = '\%([\\*+/.:]\|\%(<%\)\@<![=-]\|\W[|&?]\|||\|&&\)' . s:line_term

" Regex that defines continuation lines.
" TODO: this needs to deal with if ...: and so on
let s:msl_regex = '\%([\\*+/.:([]\|\%(<%\)\@<![=-]\|\W[|&?]\|||\|&&\)' . s:line_term

let s:one_line_scope_regex = '\<\%(if\|else\|for\|while\)\>[^{;]*' . s:line_term

" Regex that defines blocks.
let s:block_regex = '\%({\)\s*\%(|\%([*@]\=\h\w*,\=\s*\)\%(,\s*[*@]\=\h\w*\)*|\)\=' . s:line_term

let s:var_stmt = '^\s*var'

let s:comma_first = '^\s*,'
let s:comma_last = ',\s*$'

