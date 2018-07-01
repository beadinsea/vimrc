"==========================================
" Author:  clark
" Version: 0.1
" Email: beadinsea@163.com
" ReadMe: README.md
" Last_modify: 2018-06-13
" Sections:
"       -> Set Enviromental Variables 设置环境变量
"       -> General Settings 基础设置
"       -> FileEncode Settings 文件编码设置
"       -> Import Some Functions
"       -> HotKey Settings  自定义快捷键
"       -> FileType Settings  针对文件类型的设置
"       -> Terminal Setting 终端配置
"       -> Others 其它配置
"       -> Initial Plugin 加载插件
"       -> Style Settings  主题设置
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
    let g:LLVM = 'D:/LLVM'
    let g:ctags = 'D:/ctags/ctags.exe'
else
    let g:VIMHome =  '~/.vim'
    let g:LLVM = '/somewhere'
    let g:ctags = '/somewhere'
endif
let g:VIMHome = substitute(g:VIMHome, '\\', '/', 'g')
let g:LLVM = substitute(g:LLVM, '\\', '/', 'g')
let g:ctags = substitute(g:ctags, '\\', '/', 'g')

"==========================================
" General Settings 基础设置
"==========================================
set nocompatible

set history=2000                    " history存储容量

" 修改leader键
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

syntax on                           " 开启语法高亮
filetype on                         " 检测文件类型
filetype indent on                  " 针对不同的文件类型采用不同的缩进格式
filetype plugin on                  " 允许插件
filetype plugin indent on           " 启动自动补全

set autoread                        " 文件修改之后自动载入
set nobackup                        " 取消备份。 视情况自己改
set noswapfile                      " 关闭交换文件

set winaltkeys=no                   " Windows 禁用 ALT 操作菜单（使得 ALT 可以用到 Vim里）
set lazyredraw                      " 延迟绘制（提升性能）

set smartindent                     " Smart indent
set autoindent                      " 打开自动缩进

" 自动补全配置
" 让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt=longest,menu
set wildmenu                        " 增强模式中的命令行自动完成操作

" 设置 退出vim后，内容显示在终端屏幕, 可以用于查看和复制, 不需要可以去掉
" 好处：误删什么的，如果以前屏幕打开，可以找回
set t_ti= t_te=

" 去掉输入错误的提示声音
set novisualbell
set noerrorbells
set t_vb=

set splitright
set splitbelow

set tm=500
set title                           " change the terminal's title
set magic                           " For regular expressions turn magic on
set viminfo^=%                      " Remember info about open buffers on close
let &viminfofile=g:VIMHome . '/viminfo'
set ssop-=options                   " do not store global and local values in a session

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set nowrap                          " 关闭自动换行

" 设置搜索
set gdefault                        " 默认替换行内所有匹配
set hlsearch                        " 高亮search命中的文本
set incsearch                       " 打开增量搜索模式,随着键入即时搜索
set ignorecase                      " 搜索时忽略大小写
set smartcase                       " 有一个或以上大写字母时仍大小写敏感
set nowrapscan                      " 搜索到文件两端时不重新搜索

set errorformat+=[%f:%l]\ ->\ %m,[%f:%l]:%m             " 错误格式
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<     " 设置分隔符可视

" 设置 tags：当前文件所在目录往上向根目录搜索直到碰到 .tags 文件
" 或者 Vim 当前目录包含 .tags 文件
set tags=./.tags;,.tags

set foldenable                      " 代码折叠
set foldmethod=indent               " 折叠方法
set foldlevel=99

" tab相关变更
set tabstop=4                       " 设置Tab键的宽度        [等同的空格个数]
set shiftwidth=4                    " 每一次缩进对应的空格数
set softtabstop=4                   " 按退格键时可以一次删掉 4 个空格
set smarttab                        " insert tabs on the start of a line according to shiftwidth, not tabstop
set expandtab                       " 将Tab自动转化成空格[需要输入真正的Tab键时，使用 Ctrl+V + Tab]
set shiftround                      " 缩进时，取整 use multiple of shiftwidth when indenting with '<' and '>'

set hidden                          " A buffer becomes hidden when it is abandoned
set ttyfast
set nrformats=                      " 00x增减数字时使用十进制

"==========================================
" FileEncode Settings 文件编码,格式
"==========================================
set fileencoding=utf-8              " 文件默认编码
set encoding=utf-8                  " 设置新文件的编码为 UTF-8
set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1  " 打开文件时自动尝试下面顺序的编码
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
" Import Some Functions
"==========================================
exec 'so ' . fnameescape(g:VIMHome) . '/tools.vim'

"==========================================
" HotKey Settings  自定义快捷键设置
"==========================================

" F1 废弃这个键,防止调出系统帮助
noremap <F1> <ESC>"
" F2 行号开关，用于鼠标复制代码用
nnoremap <F2> :call HideNumber()<CR>
" F3 显示可打印字符开关
nnoremap <F3> :set list! list?<CR>
" F4 换行开关
nnoremap <F4> :set wrap! wrap?<CR>
" F5 打印当前VIM设定的map
nnoremap <F5> :call PrintMap()<CR>
" F6 语法开关，关闭语法可以加快大文件的展示
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>
" Full Fucking Window ^M ending line file!
nnoremap <F10> :%s////g<CR>

"----------------------------------------------------------------------
" window control
"----------------------------------------------------------------------
noremap <silent><Space>= :resize +3<CR>
noremap <silent><Space>- :resize -3<CR>
noremap <silent><Space>, :vertical resize -3<CR>
noremap <silent><Space>. :vertical resize +3<CR>

" window management
noremap <Tab>h <C-w>h
noremap <Tab>j <C-w>j
noremap <Tab>k <C-w>k
noremap <Tab>l <C-w>l
noremap <Tab>w <C-w>w
noremap <Tab>i <C-w>T
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k

" 窗口切换：ALT+SHIFT+hjkl
"----------------------------------------------------------------------
noremap <M-H> <C-w>H
noremap <M-L> <C-w>L
noremap <M-J> <C-w>J
noremap <M-K> <C-w>K
inoremap <M-H> <ESC><C-w>H
inoremap <M-L> <ESC><C-w>L
inoremap <M-J> <ESC><C-w>J
inoremap <M-K> <ESC><C-w>K

"----------------------------------------------------------------------
" Movement Enhancement
"----------------------------------------------------------------------
"Treat long lines as break lines (useful when moving around in them)
"se swap之后，同物理行上线直接跳
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

" insert mode
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <del>
inoremap <C-_> <C-k>

" ALT系列Movement
"----------------------------------------------------------------------
noremap <M-h> b
noremap <M-l> w
noremap <M-j> gj
noremap <M-k> gk
noremap <M-y> d$
inoremap <M-h> <C-Left>
inoremap <M-l> <C-Right>
inoremap <M-j> <C-\><C-o>gj
inoremap <M-k> <C-\><C-o>gk
inoremap <M-y> <C-\><C-o>d$
cnoremap <M-h> <C-Left>
cnoremap <M-l> <C-Right>
cnoremap <M-b> <C-Left>
cnoremap <M-f> <C-Right>

" Go to home and end using capitalized directions
nnoremap <expr>H col('.') == 1 ? '^': '0'
nnoremap L $
" Normal Key Map
nnoremap U :redo<CR>
nnoremap Q :q!<CR>

" faster command mode
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <C-d>
cnoremap <C-b> <Left>
cnoremap <C-d> <del>
cnoremap <C-_> <C-k>
cnoremap <M-h> <C-Left>
cnoremap <M-l> <C-Right>

" Keep search pattern at the center of the screen.
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

"----------------------------------------------------------------------
" Tab
"----------------------------------------------------------------------
" use hotkey to operate tab
noremap <silent><Tab>t, :call Tab_MoveLeft()<CR>
noremap <silent><Tab>t. :call Tab_MoveRight()<CR>

noremap <silent><Tab>n :tabnew<CR>
noremap <silent><Tab>u :tabclose<CR>
noremap <silent><Tab>. :tabn<CR>
noremap <silent><Tab>, :tabp<CR>
noremap <silent><Tab>f <C-i>
noremap <silent><Tab>b <C-o>

noremap <silent>\1 :tabn 1<CR>
noremap <silent>\2 :tabn 2<CR>
noremap <silent>\3 :tabn 3<CR>
noremap <silent>\4 :tabn 4<CR>
noremap <silent>\5 :tabn 5<CR>
noremap <silent>\6 :tabn 6<CR>
noremap <silent>\7 :tabn 7<CR>
noremap <silent>\8 :tabn 8<CR>
noremap <silent>\9 :tabn 9<CR>
noremap <silent>\0 :tabn 10<CR>
noremap <silent><S-tab> :tabnext<CR>
inoremap <silent><S-tab> <ESC>:tabnext<CR>
noremap <silent><C-tab> :tabprev<CR>
inoremap <silent><C-tab> <ESC>:tabprev<CR>

" <leader>+数字键 切换tab
"----------------------------------------------------------------------
noremap <silent><leader>1 1gt<CR>
noremap <silent><leader>2 2gt<CR>
noremap <silent><leader>3 3gt<CR>
noremap <silent><leader>4 4gt<CR>
noremap <silent><leader>5 5gt<CR>
noremap <silent><leader>6 6gt<CR>
noremap <silent><leader>7 7gt<CR>
noremap <silent><leader>8 8gt<CR>
noremap <silent><leader>9 9gt<CR>
noremap <silent><leader>0 10gt<CR>

" ALT+N 切换 tab
"----------------------------------------------------------------------
noremap <silent><M-1> :tabn 1<CR>
noremap <silent><M-2> :tabn 2<CR>
noremap <silent><M-3> :tabn 3<CR>
noremap <silent><M-4> :tabn 4<CR>
noremap <silent><M-5> :tabn 5<CR>
noremap <silent><M-6> :tabn 6<CR>
noremap <silent><M-7> :tabn 7<CR>
noremap <silent><M-8> :tabn 8<CR>
noremap <silent><M-9> :tabn 9<CR>
noremap <silent><M-0> :tabn 10<CR>
inoremap <silent><M-1> <ESC>:tabn 1<CR>
inoremap <silent><M-2> <ESC>:tabn 2<CR>
inoremap <silent><M-3> <ESC>:tabn 3<CR>
inoremap <silent><M-4> <ESC>:tabn 4<CR>
inoremap <silent><M-5> <ESC>:tabn 5<CR>
inoremap <silent><M-6> <ESC>:tabn 6<CR>
inoremap <silent><M-7> <ESC>:tabn 7<CR>
inoremap <silent><M-8> <ESC>:tabn 8<CR>
inoremap <silent><M-9> <ESC>:tabn 9<CR>
inoremap <silent><M-0> <ESC>:tabn 10<CR>

" fast file/tab actions in gui
if has('gui_running')
    noremap <silent><M-t> :tabnew<CR>
    inoremap <silent><M-t> <ESC>:tabnew<CR>
    noremap <silent><M-w> :tabclose<CR>
    inoremap <silent><M-w> <ESC>:tabclose<CR>
    noremap <M-s> :w<CR>
    inoremap <M-s> <ESC>:w<CR>
    noremap <M-Left> :call Tab_MoveLeft()<CR>
    noremap <M-Right> :call Tab_MoveRight()<CR>
    inoremap <M-Left> <ESC>:call Tab_MoveLeft()<CR>
    inoremap <M-Right> <ESC>:call Tab_MoveRight()<CR>
endif


" cmd+N to switch tab quickly in macvim
if has("gui_macvim")
    set macmeta
    noremap <silent><C-tab> :tabprev<CR>
    inoremap <silent><C-tab> <ESC>:tabprev<CR>
    noremap <silent><d-1> :tabn 1<CR>
    noremap <silent><d-2> :tabn 2<CR>
    noremap <silent><d-3> :tabn 3<CR>
    noremap <silent><d-4> :tabn 4<CR>
    noremap <silent><d-5> :tabn 5<CR>
    noremap <silent><d-6> :tabn 6<CR>
    noremap <silent><d-7> :tabn 7<CR>
    noremap <silent><d-8> :tabn 8<CR>
    noremap <silent><d-9> :tabn 9<CR>
    noremap <silent><d-0> :tabn 10<CR>
    inoremap <silent><d-1> <ESC>:tabn 1<CR>
    inoremap <silent><d-2> <ESC>:tabn 2<CR>
    inoremap <silent><d-3> <ESC>:tabn 3<CR>
    inoremap <silent><d-4> <ESC>:tabn 4<CR>
    inoremap <silent><d-5> <ESC>:tabn 5<CR>
    inoremap <silent><d-6> <ESC>:tabn 6<CR>
    inoremap <silent><d-7> <ESC>:tabn 7<CR>
    inoremap <silent><d-8> <ESC>:tabn 8<CR>
    inoremap <silent><d-9> <ESC>:tabn 9<CR>
    inoremap <silent><d-0> <ESC>:tabn 10<CR>
    noremap <silent><d-o> :browse tabnew<CR>
    inoremap <silent><d-o> <ESC>:browse tabnew<CR>
endif

"----------------------------------------------------------------------
" gui hotkeys - alt + ?
"----------------------------------------------------------------------
if g:isGUI || g:isWIN
    noremap <silent><A-o> :call Open_Browse(2)<CR>
    inoremap <silent><A-o> <ESC>:call Open_Browse(2)<CR>
    noremap <S-CR> o<ESC>
    noremap <C-CR> O<ESC>
    inoremap <S-CR> <C-o>o
    noremap <C-CR> <C-o>O
    noremap <C-S> :w<CR>
    inoremap <C-S> <ESC>:w<CR>
    noremap <M-a> ggVG
    inoremap <M-a> <ESC>ggVG
    noremap <M-_> :call Change_Transparency(-2)<CR>
    noremap <M-+> :call Change_Transparency(+2)<CR>
    if has('gui_macvim')
        noremap <M-\|> :call Toggle_Transparency(9)<CR>
    else
        noremap <M-\|> :call Toggle_Transparency(15)<CR>
    endif
endif

" Quickly edit/reload the vimrc file
nnoremap <leader>hv :vsp $MYVIMRC<CR>
nnoremap <leader>he :e $MYVIMRC<CR>
exec 'nnoremap <leader>hd :cd ' . fnameescape(g:VIMHome) . '<CR>'

" ctrl-enter to insert a empty line below, shift-enter to insert above
noremap <Tab>o o<ESC>
noremap <Tab>O O<ESC>

noremap <Tab>i :Ex<CR>

nnoremap <M-z> za
nnoremap <M-Z> zA

" ALT+y 删除到行末
inoremap <M-y> <C-\><C-o>d$

noremap <silent><Space>hh <C-^>
" 去掉搜索高亮
noremap <silent><BS> :nohl<CR>

" Use left arrow key scroll the window pages forwards and right backwards
noremap <S-Down> <PageDown>
noremap <S-Up> <Pageup>
noremap <M-Space> <PageDown>
noremap <S-Space> <Pageup>

" use hotkey to change buffer
nnoremap <silent><leader>bn :bn<CR>
nnoremap <silent><leader>bp :bp<CR>
nnoremap <silent><leader>bm :bm<CR>
nnoremap <silent><leader>bd :bdelete<CR>
nnoremap <silent><leader>bl :ls<CR>
nnoremap <silent><leader>e :e#<CR>
" 使用方向键切换buffer
noremap <S-Left> :bp<CR>
noremap <S-Right> :bn<CR>

" => 选中及操作改键

" 调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv

" replace
noremap <Space>p viw"0p
noremap <Space>y yiw

" \a                  复制所有至公共剪贴板
nnoremap <leader>a <ESC>ggVG"+y<ESC>

" \v                  从公共剪贴板粘贴
"imap <leader>v <ESC>"+p
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
noremap <leader>cd :cd %:p:h<CR>:pwd<CR>

"==========================================
" FileType Settings  文件类型设置
"==========================================
" 根据后缀名指定文件类型
autocmd BufRead,BufNewFile *.i        set ft=c
autocmd BufRead,BufNewFile *.txt      set ft=txt
autocmd BufRead,BufNewFile *.sql      set ft=mysql
autocmd BufRead,BufNewFile hosts      set ft=conf
autocmd BufRead,BufNewFile *.conf     set ft=dosini
autocmd BufRead,BufNewFile http*.conf set ft=apache
autocmd BufRead,BufNewFile *.ini      set ft=dosini
autocmd BufRead,BufNewFile CMakeLists.txt set ft=cmake
autocmd BufRead,BufNewFile *.part set filetype=html

autocmd BufRead,BufNewFile */nginx/*.conf        set ft=nginx
autocmd BufRead,BufNewFile */nginx/**/*.conf     set ft=nginx
autocmd BufRead,BufNewFile */openresty/*.conf    set ft=nginx
autocmd BufRead,BufNewFile */openresty/**/*.conf set ft=nginx

autocmd FileType python set tabstop=4 shiftwidth=4 expandtab ai
autocmd FileType javascript,html,css,xml set tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai

" C/C++ 文件使用 // 作为注释
autocmd FileType c,cpp setlocal commentstring=//\ %s     

" markdown 允许自动换行
autocmd FileType markdown,txt setlocal wrap          

" quickfix 隐藏行号
autocmd FileType qf setlocal nonumber

" disable showmatch when use > in php
autocmd BufWinEnter *.php set mps-=<:>

" 保存python文件时删除多余空格
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl 
    \ autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" 设置可以高亮的关键字
  " Highlight TODO, FIXME, NOTE, etc.
autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|DONE\|XXX\|BUG\|HACK\)')
autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)')


let g:clang_format_path = g:LLVM . '/bin/clang-format.exe'
exec 'noremap <M-k> :py3file ' . g:LLVM . '/share/clang/clang-format.py<CR>'
exec 'inoremap <M-k> <C-o>:py3file ' . g:LLVM . '/share/clang/clang-format.py<CR>'
noremap <M-K> :call FormatFile()<CR>
inoremap <M-K> <C-o>:call FormatFile()<CR>

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

"==========================================
" Initial Plugin 加载插件
"==========================================
" install bundles
exec 'so ' . fnameescape(g:VIMHome) . '/vimrc.bundles'

"==========================================
" Style Settings  主题设置
"==========================================
set ruler                           " 显示当前的行号列号
set showcmd                         " 在状态栏显示正在输入的命令
set cmdheight=2                     " 命令行的高度，默认为1，这里设为2
set showmode                        " 左下角显示当前vim模式
set scrolloff=2                     " 在上下移动光标时，光标的上方或下方至少会保留显示的行数
set display=lastline                " 显示最后一行
set laststatus=2                    " Always show the status line
set number                          " 显示行号
set relativenumber                  " 开启相对行号
set showmatch                       " 括号配对情况, 跳转并高亮一下匹配的括号
set matchtime=2                     " How many tenths of a second to blink when matching brackets
set list                            " 设置显示制表符等隐藏字符
set splitright                      " 水平切割窗口时，默认在右边显示新窗口

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
    set showtabline=2          " 隐藏Tab栏
    set guitablabel=%t
    set cursorline             " 高亮突出当前行
    set cursorcolumn           " 高亮突出当前列
    set linespace=2
    set noimd
    set mouse=a
endif

set background=dark
set t_Co=256
if g:isGUI
    colorscheme solarized
else
    colorscheme molokai
endif

" 设置标记一列的背景颜色和数字一行颜色一致
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

" 更改样式
"----------------------------------------------------------------------
" 更清晰的错误标注：默认一片红色背景，语法高亮都被搞没了
" 只显示红色或者蓝色下划线或者波浪线
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! clear SpellLocal
if has('gui_running')
    hi! SpellBad gui=undercurl guisp=red
    hi! SpellCap gui=undercurl guisp=blue
    hi! SpellRare gui=undercurl guisp=magenta
    hi! SpellRare gui=undercurl guisp=cyan
else
    hi! SpellBad term=standout ctermfg=1 term=underline cterm=underline
    hi! SpellCap term=underline cterm=underline
    hi! SpellRare term=underline cterm=underline
    hi! SpellLocal term=underline cterm=underline
endif

" Status Line
"----------------------------------------------------------------------
set statusline=%<%1*[▶%n:%{Buf_total_num()}]%*
set statusline+=%2*\ %{File_size(@%)}\ %*
set statusline+=%3*\ %F\ %*
set statusline+=%4*『\ %{exists('g:loaded_ale')?LinterStatus():''}』%{exists('g:loaded_fugitive')?fugitive#statusline():''}%*
set statusline+=%5*\ %m%r%y\ %*
set statusline+=%=%6*\ %{&ff}\ \|\ %{\"\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"\ \|\"}\ %-14.(%l:%c%V%)%*
set statusline+=%7*\ %P\ %*
" default bg for statusline is 236 in space-vim-dark
hi User1 cterm=bold ctermfg=232 ctermbg=179
hi User2 cterm=None ctermfg=251 ctermbg=240
hi User3 cterm=bold ctermfg=169 ctermbg=239
hi User4 cterm=None ctermfg=208 ctermbg=238
hi User5 cterm=None ctermfg=246 ctermbg=237
hi User6 cterm=None ctermfg=250 ctermbg=238
hi User7 cterm=None ctermfg=249 ctermbg=240
"----------------------------------------------------------------------
" 文件搜索和补全时忽略下面扩展名
"----------------------------------------------------------------------
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class

set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib "stuff to ignore when tab completing
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz    " MacOSX/Linux
set wildignore+=*DS_Store*,*.ipch
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**
set wildignore+=*/.nx/**,*.app,*.git,.git
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android
