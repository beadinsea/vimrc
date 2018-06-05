"==========================================
" Author:  clark
" Version: 0.1
" Email: beadinsea@163.com
" ReadMe: README.md
" Last_modify: 2018-05-28
" Sections:
"       -> Set Enviromental Variables 设置环境变量
"       -> General Settings 基础设置
"       -> Display Settings 展示/排版等界面格式设置
"       -> FileEncode Settings 文件编码设置
"       -> HotKey Settings  自定义快捷键
"       -> FileType Settings  针对文件类型的设置
"       -> Others 其它配置
"       -> Initial Plugin 加载插件
"       -> Theme Settings  主题设置
"
"       -> 插件配置和具体设置在vimrc.bundles中
" Note: Don't put anything in your .vimrc you don't understand!
"==========================================

"==========================================
" Set Enviromental Variables 设置环境变量
"==========================================
" 判断操作系统类型
if(has('win32') || has('win64'))
    let g:isWIN = 1
    let g:isMAC = 0
else
    if system('uname') =~ 'Darwin'
        let g:isWIN = 0
        let g:isMAC = 1
    else
        let g:isWIN = 0
        let g:isMAC = 0
    endif
endif

" 判断是否处于 GUI 界面
if has('gui_running')
    let g:isGUI = 1
else
    let g:isGUI = 0
endif

if g:isWIN
    let g:VIMHome = $VIM . '/vimfiles'
else
    let g:VIMHome =  '~/.vim'
endif
let g:VIMHome = substitute(g:VIMHome, '\\', '/', 'g')

" NOTE: 以下配置有详细说明，一些特性不喜欢可以直接注解掉

"==========================================
" General Settings 基础设置
"==========================================
set history=2000                    " history存储容量

" 修改leader键
let mapleader = ','
let g:mapleader = ','

syntax on                           " 开启语法高亮
filetype on                         " 检测文件类型
filetype indent on                  " 针对不同的文件类型采用不同的缩进格式
filetype plugin on                  " 允许插件
filetype plugin indent on           " 启动自动补全

set autoread                        " 文件修改之后自动载入
set nobackup                        " 取消备份。 视情况自己改
set noswapfile                      " 关闭交换文件
set wildignore=*.swp,*.bak,*.pyc,*.class,.svn,*.o,*~

" 自动补全配置
" 让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt=longest,menu
set wildmenu                        " 增强模式中的命令行自动完成操作

" 设置 退出vim后，内容显示在终端屏幕, 可以用于查看和复制, 不需要可以去掉
" 好处：误删什么的，如果以前屏幕打开，可以找回
set t_ti= t_te=

" 修复ctrl+m 多光标操作选择的bug，但是改变了ctrl+v进行字符选中时将包含光标下的字符
set selection=inclusive
set selectmode=mouse,key

" 去掉输入错误的提示声音
set novisualbell
set noerrorbells

set t_vb=
set tm=500
set title                           " change the terminal's title
set magic                           " For regular expressions turn magic on
set viminfo^=%                      " Remember info about open buffers on close
let &viminfofile=g:VIMHome . '/viminfo'

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set winaltkeys=no

"==========================================
" Display Settings 展示/排版等界面格式设置
"==========================================
set ruler                           " 显示当前的行号列号
set showcmd                         " 在状态栏显示正在输入的命令
set cmdheight=1                     " 命令行的高度，默认为1，这里设为2
set showmode                        " 左下角显示当前vim模式
set scrolloff=2                     " 在上下移动光标时，光标的上方或下方至少会保留显示的行数

" 命令行（在状态行下）的高度，默认为1，这里是2
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}:%{&fenc}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ CWD:\ %r%{getcwd()}%h\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
" Always show the status line - use 2 lines for the status bar
set laststatus=2

set number                          " 显示行号
set relativenumber                  " 开启相对行号
set nowrap                          " 取消换行
set showmatch                       " 括号配对情况, 跳转并高亮一下匹配的括号
set matchtime=2                     " How many tenths of a second to blink when matching brackets

" 设置搜索
set hlsearch                        " 高亮search命中的文本
set incsearch                       " 打开增量搜索模式,随着键入即时搜索
set ignorecase                      " 搜索时忽略大小写
set smartcase                       " 有一个或以上大写字母时仍大小写敏感
set nowrapscan                      " 搜索到文件两端时不重新搜索

set foldenable                      " 代码折叠
set foldmethod=indent               " 折叠方法
set foldlevel=99
" 代码折叠自定义快捷键 <leader>zz
let g:FoldMethod = 0
map <leader>zz :call ToggleFold()<cr>
fun! ToggleFold()
    if g:FoldMethod == 0
        exe "normal! zM"
        let g:FoldMethod = 1
    else
        exe "normal! zR"
        let g:FoldMethod = 0
    endif
endfun

" 缩进配置
set smartindent                     " Smart indent
set autoindent                      " 打开自动缩进

" tab相关变更
set tabstop=4                       " 设置Tab键的宽度        [等同的空格个数]
set shiftwidth=4                    " 每一次缩进对应的空格数
set softtabstop=4                   " 按退格键时可以一次删掉 4 个空格
set smarttab                        " insert tabs on the start of a line according to shiftwidth, not tabstop
set expandtab                       " 将Tab自动转化成空格[需要输入真正的Tab键时，使用 Ctrl+V + Tab]
set shiftround                      " 缩进时，取整 use multiple of shiftwidth when indenting with '<' and '>'

set hidden                          " A buffer becomes hidden when it is abandoned
set wildmode=list:longest
set ttyfast
set nrformats=                      " 00x增减数字时使用十进制

"==========================================
" FileEncode Settings 文件编码,格式
"==========================================
" 设置文件编码和文件格式
set fenc=utf-8
set encoding=utf-8                  " 设置新文件的编码为 UTF-8
set fileencodings=utf-8,gbk,cp936,latin-1   " 自动判断编码时，依次尝试以下编码：
set fileformat=unix
set fileformats=unix,mac,dos        " Use Unix as the standard file type
if g:isWIN
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    language messages zh_CN.utf-8
endif

set termencoding=utf-8              " 只影响普通模式 (非图形界面) 下的 Vim

set formatoptions+=m                " 如遇Unicode值大于255的文本，不必等到空格再折行
set formatoptions+=B                " 合并两行中文时，不在中间加空格

"==========================================
" HotKey Settings  自定义快捷键设置
"==========================================
"Treat long lines as break lines (useful when moving around in them)
"se swap之后，同物理行上线直接跳
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

" F1 - F6 设置

" F1 废弃这个键,防止调出系统帮助
" I can type :help on my own, thanks.  Protect your fat fingers from the evils of <F1>
noremap <F1> <Esc>"

" F2 行号开关，用于鼠标复制代码用
" 为方便复制，用<F2>开启/关闭行号显示:
function! HideNumber()
  if(&relativenumber == &number)
    set relativenumber! number!
  elseif(&number)
    set number!
  else
    set relativenumber!
  endif
  set number?
endfunc
nnoremap <F2> :call HideNumber()<CR>
" F3 显示可打印字符开关
nnoremap <F3> :set list! list?<CR>
" F4 换行开关
nnoremap <F4> :set wrap! wrap?<CR>

" F6 语法开关，关闭语法可以加快大文件的展示
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>

set pastetoggle=<F5>            "    when in insert mode, press <F5> to go to
                                "    paste mode, where you can paste mass data
                                "    that won't be autoindented

" disbale paste mode when leaving insert mode
au InsertLeave * set nopaste

" F5 set paste问题已解决, 粘贴代码前不需要按F5了
" F5 粘贴模式paste_mode开关,用于有格式的代码粘贴
" Automatically set paste mode in Vim when pasting in insert mode
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" window management
noremap <tab>h <c-w>h
noremap <tab>j <c-w>j
noremap <tab>k <c-w>k
noremap <tab>l <c-w>l
noremap <tab>w <c-w>w

" insert mode as emacs
inoremap <c-h> <left>
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-l> <right>
inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-d> <del>
inoremap <c-_> <c-k>

" Go to home and end using capitalized directions
noremap H ^
noremap L $

" faster command mode
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <c-d>
cnoremap <c-b> <left>
cnoremap <c-d> <del>
cnoremap <c-_> <c-k>

" Keep search pattern at the center of the screen.
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" 去掉搜索高亮
nnoremap <silent><leader>nh :nohl<cr>

" for # indent, python文件中输入新行时#号注释不切回行首
autocmd BufNewFile,BufRead *.py inoremap # X<c-h>#

" Use Space scroll the window pages forwards and Shift-Space backwards
nnoremap <space> <pagedown>
nnoremap <s-space> <pageup>
noremap <s-down> <pagedown>
noremap <s-up> <pageup>

" use hotkey to change buffer
nnoremap <silent><leader>bn :bn<cr>
nnoremap <silent><leader>bp :bp<cr>
nnoremap <silent><leader>bm :bm<cr>
nnoremap <silent><leader>bv :vs<cr>
nnoremap <silent><leader>bd :bdelete<cr>
nnoremap <silent><leader>bl :ls<cr>
nnoremap <silent><leader>bb :ls<cr>:b
nnoremap <silent><leader>be :e#<CR>
" 使用方向键切换buffer
noremap <s-left> :bp<CR>
noremap <s-right> :bn<CR>

" => 选中及操作改键

" 调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv

" ctrl-enter to insert a empty line below, shift-enter to insert above
nnoremap <tab>o o<ESC>
nnoremap <tab>O O<ESC>

" \a                  复制所有至公共剪贴板
nnoremap <leader>a <esc>ggVG"+y<esc>

" \v                  从公共剪贴板粘贴
"imap <leader>v <esc>"+p
nnoremap <leader>v "+p
vnoremap <leader>v "+p

" 复制选中区到系统剪切板中
vnoremap <leader>c "+y

" 选中并高亮最后一次插入的内容
nnoremap gv `[v`]

" select block
nnoremap <leader>l V`}

" 滚动Speed up scrolling of the viewport slightly
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" Quickly close the current window
nnoremap <leader>q :q<CR>
" Quickly save the current file
nnoremap <leader>w :w<CR>

" 交换 ' `, 使得可以快速使用'跳到marked位置
nnoremap ' `
nnoremap ` '

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Quickly edit/reload the vimrc file
" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

"==========================================
" FileType Settings  文件类型设置
"==========================================

" 具体编辑文件类型的一般设置，比如不要 tab 等
autocmd FileType python set tabstop=4 shiftwidth=4 expandtab ai
autocmd FileType ruby,javascript,html,css,xml set tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
autocmd BufRead,BufNewFile *.md,*.mkd,*.markdown set filetype=markdown.mkd
autocmd BufRead,BufNewFile *.part set filetype=html
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai

" disable showmatch when use > in php
au BufWinEnter *.php set mps-=<:>

" 保存python文件时删除多余空格
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" 定义函数AutoSetFileHead，自动插入文件头
autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1, "\#!/bin/bash")
    endif

    "如果文件类型为python
    if &filetype == 'python'
        " call setline(1, "\#!/usr/bin/env python")
        " call append(1, "\# encoding: utf-8")
        call setline(1, "\# -*- coding: utf-8 -*-")
    endif

    normal G
    normal o
    normal o
endfunc

" 设置可以高亮的关键字
  " Highlight TODO, FIXME, NOTE, etc.
autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|DONE\|XXX\|BUG\|HACK\)')
autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)')

"==========================================
" others 其它设置
"==========================================
" 离开插入模式后自动关闭预览窗口
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" 回车即选中当前项
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"

" In the quickfix window, <CR> is used to jump to the error under the
" cursor, so undefine the mapping there.
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
" quickfix window  s/v to open in split window,  ,gd/,jd => quickfix window => open it
autocmd BufReadPost quickfix nnoremap <buffer> v <C-w><Enter><C-w>L
autocmd BufReadPost quickfix nnoremap <buffer> s <C-w><Enter><C-w>K

" command-line window
autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>

" 上下左右键的行为 会显示其他信息
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

" 打开自动定位到最后编辑的位置, 需要确认 .viminfo 当前用户可写
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" 根据后缀名指定文件类型
au BufRead,BufNewFile *.i        set ft=c
au BufRead,BufNewFile *.phpt     set ft=php
au BufRead,BufNewFile *.sql      set ft=mysql
au BufRead,BufNewFile *.txt      set ft=txt
au BufRead,BufNewFile hosts      set ft=conf
au BufRead,BufNewFile *.conf     set ft=dosini
au BufRead,BufNewFile http*.conf set ft=apache
au BufRead,BufNewFile *.ini      set ft=dosini

au BufRead,BufNewFile */nginx/*.conf        set ft=nginx
au BufRead,BufNewFile */nginx/**/*.conf     set ft=nginx
au BufRead,BufNewFile */openresty/*.conf    set ft=nginx
au BufRead,BufNewFile */openresty/**/*.conf set ft=nginx

au BufRead,BufNewFile CMakeLists.txt set ft=cmake
"==========================================
" Initial Plugin 加载插件
"==========================================

" install bundles
exec 'so ' . fnameescape(g:VIMHome) . '/vimrc.bundles'

" ensure ftdetect et al work by including this after the bundle stuff
filetype plugin indent on

"==========================================
" Theme Settings  主题设置
"==========================================
" 设置着色模式和字体
if g:isWIN
    set guifont=等距更纱黑体\ T\ SC:h12
    set guifontwide=等距更纱黑体\ T\ SC:h12
elseif g:isMAC
    set guifont=Monaco:h14
else
    set guifont=等距更纱黑体\ T\ SC\ 12
endif

" 使用 GUI 界面时的设置
if g:isGUI
    " 启动时自动最大化窗口
    if g:isWIN
        au GUIEnter * simalt ~x
    endif
    set guioptions+=c          " 使用字符提示框
    set guioptions-=m          " 隐藏菜单栏
    set guioptions-=T          " 隐藏工具栏
    set guioptions-=L          " 隐藏左侧滚动条
    set guioptions-=r          " 隐藏右侧滚动条
    set guioptions-=b          " 隐藏底部滚动条
    set showtabline=0          " 隐藏Tab栏
    set cursorline             " 高亮突出当前行
    set cursorcolumn         " 高亮突出当前列
    set linespace=2
    set noimd
endif

set background=dark
colorscheme molokai
set t_Co=256

" 设置标记一列的背景颜色和数字一行颜色一致
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

" for error highlight，防止错误整行标红导致看不清
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

