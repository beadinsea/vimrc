"======================================================================
"
" tools.vim - tool functions
"
" Created by skywind on 2018/02/10
" Last Modified: 2018/02/10 02:34:43
"
"======================================================================
" global settings
let g:status_var = ""
set wcm=<C-Z>

function! FormatFile()
  let l:lines="all"
  exec ':py3file ' . g:LLVM . '/share/clang/clang-format.py<CR>'
endfunction

function! Buf_total_num()
    return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

function! File_size(f)
    let l:size = getfsize(expand(a:f))
    if l:size == 0 || l:size == -1 || l:size == -2
        return ''
    endif
    if l:size < 1024
        return l:size.' bytes'
    elseif l:size < 1024*1024
        return printf('%.1f', l:size/1024.0).'k'
    elseif l:size < 1024*1024*1024
        return printf('%.1f', l:size/1024.0/1024.0) . 'm'
    else
        return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'g'
    endif
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  tabnew
  silent put=message
  set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

function! PrintMap()
    if g:isWIN
        redir! > H:/temp/map.txt
    else
        redir! > ~/vim_map.txt
    endif
    map
    redir END
endfunc

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

" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction

" Space2Tab
" Tab2Space
" RetabIndent
command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)

function! Tab_MoveLeft()
    let l:tabnr = tabpagenr() - 2
    if l:tabnr >= 0
        exec 'tabmove '.l:tabnr
    endif
endfunc

function! Tab_MoveRight()
    let l:tabnr = tabpagenr() + 1
    if l:tabnr <= tabpagenr('$')
        exec 'tabmove '.l:tabnr
    endif
endfunc

" open quickfix
function! Toggle_QuickFix(size)
    function! s:WindowCheck(mode)
        if getbufvar('%', '&buftype') == 'quickfix'
            let s:quickfix_open = 1
            return
        endif
        if a:mode == 0
            let w:quickfix_save = winsaveview()
        else
            call winrestview(w:quickfix_save)
        endif
    endfunc
    let s:quickfix_open = 0
    let l:winnr = winnr()           
    windo call s:WindowCheck(0)
    if s:quickfix_open == 0
        exec 'botright copen '.a:size
        wincmd k
    else
        cclose
    endif
    windo call s:WindowCheck(1)
    silent exec ''.l:winnr.'wincmd w'
endfunc


" show content in a new vertical split window
function! s:Show_Content(title, width, content)
    let l:width = a:width
    if l:width == 0
        let l:width = winwidth(0) / 2
        if l:width < 25 | let l:width = 25 | endif
    endif
    exec '' . l:width . 'vnew '. fnameescape(a:title)
    setlocal buftype=nofile bufhidden=delete noswapfile winfixwidth
    setlocal noshowcmd nobuflisted wrap nonumber
    if has('syntax')
        sy clear
        sy match ShowCmd /<press q to close>/
        hi clear ShowCmd
        hi def ShowCmd ctermfg=green
    endif
    1s/^/\=a:content/g
    call append(line('.') - 1, '')
    call append(line('.') - 1, '<press q to close>')
    "call append(0, '<press q to close>')
    setlocal nomodifiable
    noremap <silent><buffer> <space> :close!<cr>
    noremap <silent><buffer> <cr> :close!<cr>
    noremap <silent><buffer> <tab> :close!<cr>
    noremap <silent><buffer> q :close!<cr>
    noremap <silent><buffer> c :close!<cr>
endfunc

" switch header
function! Open_HeaderFile(where)
    let l:main = expand('%:p:r')
    let l:fext = expand('%:e')
    if index(['c', 'cpp', 'm', 'mm', 'cc'], l:fext) >= 0
        let l:altnames = ['h', 'hpp', 'hh']
    elseif index(['h', 'hh', 'hpp'], l:fext) >= 0
        let l:altnames = ['c', 'cpp', 'cc', 'm', 'mm']
    else
        echo 'switch failed, not a c/c++ source'
        return
    endif
    for l:next in l:altnames
        let l:newname = l:main . '.' . l:next
        if filereadable(l:newname)
            if a:where == 0
                call Tools_FileSwitch('e', l:newname)
            elseif a:where == 1
                call Tools_FileSwitch('vs', l:newname)
            else
                call Tools_FileSwitch('tabnew', l:newname)
            endif
            return
        endif
    endfor
    echo 'switch failed, can not find another part of c/c++ source'
endfunc

" Open Explore in new tab with current directory
function! Open_Explore(where)
    let l:path = expand("%:p:h")
    if l:path == ''
        let l:path = getcwd()
    endif
    if a:where < 0
        exec 'Rexplore'
    elseif a:where == 0
        exec 'Explore '
    elseif a:where == 1
        exec 'Vexplore! '
    elseif a:where == 2
        exec 'Texplore'
    endif
endfunc

function! Open_Browse(where)
    let l:path = expand("%:p:h")
    if l:path == '' | let l:path = getcwd() | endif
    if exists('g:browsefilter') && exists('b:browsefilter')
        if g:browsefilter != ''
            let b:browsefilter = g:browsefilter
        endif
    endif
    if a:where == 0
        exec 'browse e '.fnameescape(l:path)
    elseif a:where == 1
        exec 'browse vnew '.fnameescape(l:path)
    else
        exec 'browse tabnew '.fnameescape(l:path)
    endif
endfunc


function! Transparency_Set(value)
    if (has('win32') || has('win64'))
        let l:alpha = (100 - a:value) * 255 / 100
        if l:alpha >= 255 
            let l:alpha = 255 
        endif
        if l:alpha < 0 
            let l:alpha = 0 
        endif
        call auxlib#tweak_set_alpha(l:alpha)
    elseif has('gui_macvim')
        if a:value >= 100
            set transparency = 100
        elseif a:value >= 0
            let &transparency = a:value
        else
            set transparency = 0
        endif
    endif
endfunc

function! Transparency_Get()
    if (has('win32') || has('win64')) 
        if exists('g:auxlib_tweak_alpha')
            return (255 - g:auxlib_tweak_alpha) * 100 / 255
        else
            return 0
        endif
    elseif has('gui_macvim')
        return &transparency
    endif
    return 0
endfunc

function! Change_Transparency(increase)
    let l:current = Transparency_Get()
    if a:increase < 0
        let l:inc = -a:increase
        if l:inc > l:current
            silent call Transparency_Set(0)
        else
            silent call Transparency_Set(l:current - l:inc)
        endif
    elseif a:increase > 0
        let l:inc = a:increase
        if l:inc + l:current > 100
            silent call Transparency_Set(100)
        else
            silent call Transparency_Set(l:current + l:inc)
        endif
    endif
    echo 'transparency: '.l:current
endfunc

function! Toggle_Transparency(value)
    let l:current = Transparency_Get()
    if Transparency_Get() > 0
        call Transparency_Set(0)
    else
        call Transparency_Set(a:value)
    endif
endfunc

" delete buffer keep window
function! s:BufferClose(bang, buffer)
    let l:bufcount = bufnr('$')
    let l:switch = 0    " window which contains target buffer will be switched
    if empty(a:buffer)
        let l:target = bufnr('%')
    elseif a:buffer =~ '^\d\+$'
        let l:target = bufnr(str2nr(a:buffer))
    else
        let l:target = bufnr(a:buffer)
    endif
    if l:target <= 0
        echohl ErrorMsg
        echomsg "cannot find buffer: '" . a:buffer . "'"
        echohl NONE
        return 0
    endif
    if !getbufvar(l:target, "&modifiable")
        echohl ErrorMsg
        echomsg "Cannot close a non-modifiable buffer"
        echohl NONE
        return 0
    endif
    if empty(a:bang) && getbufvar(l:target, '&modified')
        echohl ErrorMsg
        echomsg "No write since last change (use :BufferClose!)"
        echohl NONE
        return 0
    endif
    if bufnr('#') > 0   " check alternative buffer
        let l:aid = bufnr('#')
        if l:aid != l:target && buflisted(l:aid) && getbufvar(l:aid, "&modifiable")
            let l:switch = l:aid    " switch to alternative buffer
        endif
    endif
    if l:switch == 0    " check non-scratch buffers
        let l:index = l:bufcount
        while l:index >= 0
            if buflisted(l:index) && getbufvar(l:index, "&modifiable")
                if strlen(bufname(l:index)) > 0 && l:index != l:target
                    let l:switch = l:index  " switch to that buffer
                    break
                endif
            endif
            let l:index = l:index - 1   
        endwhile
    endif
    if l:switch == 0    " check scratch buffers
        let l:index = l:bufcount
        while l:index >= 0
            if buflisted(l:index) && getbufvar(l:index, "&modifiable")
                if l:index != l:target
                    let l:switch = l:index  " switch to a scratch
                    break
                endif
            endif
            let l:index = l:index - 1
        endwhile
    endif
    if l:switch  == 0   " check if only one scratch left
        if strlen(bufname(l:target)) == 0 && (!getbufvar(l:target, "&modified"))
            echo "This is the last scratch" 
            return 0
        endif
    endif
    let l:ntabs = tabpagenr('$')
    let l:tabcc = tabpagenr()
    let l:wincc = winnr()
    let l:index = 1
    while l:index <= l:ntabs
        exec 'tabn '.l:index
        while 1
            let l:wid = bufwinnr(l:target)
            if l:wid <= 0 | break | endif
            exec l:wid.'wincmd w'
            if l:switch == 0
                exec 'enew!'
                let l:switch = bufnr('%')
            else
                exec 'buffer '.l:switch
            endif
        endwhile
        let l:index += 1
    endwhile
    exec 'tabn ' . l:tabcc
    exec l:wincc . 'wincmd w'
    exec 'bdelete! '.l:target
    return 1
endfunction

command! -bang -nargs=? BufferClose call s:BufferClose('<bang>', '<args>')

function! Change_DirectoryToFile()
    let l:filename = expand("%:p")
    if l:filename == "" | return | endif
    silent exec 'cd '.expand("%:p:h")
    exec 'pwd'
endfunc

" log file
function! s:LogAppend(filename, text)
    let l:ts = strftime("[%Y-%m-%d %H:%M:%S] ")
    if 1
        call writefile([l:ts . a:text], a:filename, 'a')
    else
        exec "redir >> ".fnameescape(a:filename)
        silent echon l:ts.a:text."\n"
        silent exec "redir END"
    endif
endfunc

" write a log
function! LogWrite(text)
    if !exists('s:logname')
        let s:logname = expand("~/.vim/tmp/record.log")
        let l:path = expand("~/.vim/tmp")
        try
            silent call mkdir(l:path, "p", 0755)
        catch /^Vim\%((\a\+)\)\=:E/
        finally
        endtry
    endif
    try
        call s:LogAppend(s:logname, a:text)
    catch /^Vim\%((\a\+)\)\=:E/
    finally
    endtry
endfunc


" toggle taglist
function! Toggle_Taglist()
    call LogWrite('[taglist] '.expand("%:p"))
    silent exec 'TlistToggle'
endfunc

" toggle tagbar
function! Toggle_Tagbar()
    call LogWrite('[tagbar] '.expand("%:p"))
    silent exec 'TagbarToggle'
endfunc

" open explorer/finder
function! Show_Explore()
    let l:locate = expand("%:p:h")
    if g:isWIN
        exec "!start /b cmd.exe /C explorer.exe ".shellescape(l:locate)
    endif
endfunc

" Search pydoc
function! Tools_Pydoc(word, where)
    let l:text = system('python -m pydoc ' . shellescape(a:word))
    if a:where == '0' || a:where == 'quickfix'
        cexpr l:text
    else
        call s:Show_Content('PyDoc: '.a:word, 0, l:text)
    endif
endfunc

command! -nargs=1 PyDoc call Tools_Pydoc("<args>", '1')

function! Tools_SwitchLayout() 
    set number
    set showtabline=2
    set laststatus=2
    if !has('gui_running')
        set t_Co=256
    endif
    if $SSH_CONNECTION != ''
        let g:vimmake_build_bell = 1
        let g:asyncrun_bell = 1
    endif
endfunc

" toggle number
function! Tools_SwitchNumber()
    if &number == 0
        set number
    else
        set nonumber
    endif
endfunc

" 0:up, 1:down, 2:pgup, 3:pgdown 4:top, 5:bottom, 
function! Tools_QuickfixCursor(mode)
    function! s:quickfix_cursor(mode)
        if &buftype == 'quickfix'
            if a:mode == 0
                exec "normal! \<c-y>"
            elseif a:mode == 1
                exec "normal! \<c-e>"
            elseif a:mode == 2
                exec "normal! ".winheight('.')."\<c-y>"
            elseif a:mode == 3
                exec "normal! ".winheight('.')."\<c-e>"
            elseif a:mode == 4
                normal! gg
            elseif a:mode == 5
                normal! G
            elseif a:mode == 6
                exec "normal! \<c-u>"
            elseif a:mode == 7
                exec "normal! \<c-d>"
            elseif a:mode == 8
                exec "normal! k"
            elseif a:mode == 9
                exec "normal! j"
            endif
        endif
    endfunc
    let l:winnr = winnr()           
    noautocmd silent! windo call s:quickfix_cursor(a:mode)
    noautocmd silent! exec ''.l:winnr.'wincmd w'
endfunc

" 0:up, 1:down, 2:pgup, 3:pgdown, 4:top, 5:bottom
function! Tools_PreviousCursor(mode)
    if winnr('$') <= 1
        return
    endif
    noautocmd silent! wincmd p
    if a:mode == 0
        exec "normal! \<c-y>"
    elseif a:mode == 1
        exec "normal! \<c-e>"
    elseif a:mode == 2
        exec "normal! ".winheight('.')."\<c-y>"
    elseif a:mode == 3
        exec "normal! ".winheight('.')."\<c-e>"
    elseif a:mode == 4
        normal! gg
    elseif a:mode == 5
        normal! G
    elseif a:mode == 6
        exec "normal! \<c-u>"
    elseif a:mode == 7
        exec "normal! \<c-d>"
    elseif a:mode == 8
        exec "normal! k"
    elseif a:mode == 9
        exec "normal! j"
    endif
    noautocmd silent! wincmd p
endfunc

function! s:run_python(redraw, script)
    let script = expand(a:script)
    " echo 'running:'. script
    py import vim
    " py execfile(vim.eval('script'), {'__builtins__':__builtins__}, {})
    py execfile(vim.eval('script'))
    if a:redraw
        call input("press enter to continue")
        redraw!
    endif
endfunc

command! -bang -nargs=1 PythonRun call s:run_python(<bang>0, <f-args>)

"----------------------------------------------------------------------
" https://github.com/lilydjwg/dotvim 
"----------------------------------------------------------------------
function! GetPatternAtCursor(pat)
    let col = col('.') - 1
    let line = getline('.')
    let ebeg = -1
    let cont = match(line, a:pat, 0)
    while (ebeg >= 0 || (0 <= cont) && (cont <= col))
        let contn = matchend(line, a:pat, cont)
        if (cont <= col) && (col < contn)
            let ebeg = match(line, a:pat, cont)
            let elen = contn - ebeg
            break
        else
            let cont = match(line, a:pat, contn)
        endif
    endwhile
    if ebeg >= 0
        return strpart(line, ebeg, elen)
    else
        return ""
    endif
endfunc


"----------------------------------------------------------------------
" https://github.com/Shougo/shougo-s-github 
"----------------------------------------------------------------------
function! ToggleOption(option_name)
    execute 'setlocal' a:option_name.'!'
    execute 'setlocal' a:option_name.'?'
endfunc


"----------------------------------------------------------------------
" https://github.com/asins/vim 
"----------------------------------------------------------------------
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    exec '%s/\r$\|\s\+$//e'
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunc

"----------------------------------------------------------------------
" update last change time
"----------------------------------------------------------------------
function! UpdateLastModified()
    " preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")

    let n = min([10, line('$')]) " check head
    let timestamp = strftime('%Y/%m/%d %H:%M') " time format
    let timestamp = substitute(timestamp, '%', '\%', 'g')
    let pat = substitute('Last Modified:\s*\zs.*\ze', '%', '\%', 'g')
    keepjumps silent execute '1,'.n.'s%^.*'.pat.'.*$%'.timestamp.'%e'

    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunc

"----------------------------------------------------------------------
" Fzf
"----------------------------------------------------------------------
function! Tools_FileSearch(...)
    let path = vimmake#get_root('%')
    let mode = 0
    if path == ''
        return
    endif
    if executable('fzf') && exists(':FZF') == 2
        let mode = 0
    elseif exists(':LeaderfFile') == 2
        let mode = 1
    elseif exists(':CtrlP') == 2
        let mode = 2
    endif
    if a:0 >= 0 && a:1 >= 0
        let mode = a:1
    endif
    if a:0 >= 2 && a:2 != ''
        let path = a:2
    endif
    if mode == 0
        exec 'FZF '. fnameescape(path)
    elseif mode == 1
        exec 'LeaderfFile '. fnameescape(path)
    elseif mode == 2
        exec 'CtrlP '. fnameescape(path)
    endif
endfunc


command! -nargs=? FuzzyFileSearch call Tools_FileSearch(-1, <q-args>)

"----------------------------------------------------------------------
" Align cheatsheet
"----------------------------------------------------------------------
function! s:Tools_CheatSheetAlign(...)
    let size = get(g:, 'tools_align_width', 20)
    let size = (a:0 >= 1 && a:1 > 0)? a:1 : size
    let text = 's/^\(\S\+\%( \S\+\)*\)\s\s\+/\=printf("%-'
    let text.= size
    let text.= 'S",submatch(1))/'
    let text = 's/^\(.\{-}\) \{2,}/\=printf("%-'. size
    let text.= 'S", submatch(1))/'
    silent! keepjumps exec text
endfunc

command! -nargs=? -range MyCheatSheetAlign <line1>,<line2>call s:Tools_CheatSheetAlign(<q-args>)


"----------------------------------------------------------------------
" Load url
"----------------------------------------------------------------------
function! s:Tools_ReadUrl(url)
    if executable('curl')
        exec 'r !curl -sL '.shellescape(a:url)
    elseif executable('wget')
        exec 'r !wget --no-check-certificate -qO- '.shellescape(a:url)
    else
        echo "require wget or curl"
    endif
endfunc

command! -nargs=1 MyUrlRead call s:Tools_ReadUrl(<q-args>)

"----------------------------------------------------------------------
" Remove some path from $PATH
"----------------------------------------------------------------------
function! s:Tools_RemovePath(path) abort
    let windows = 0
    let path = a:path
    let sep = ':'
    let parts = []
    function! s:StringReplace(text, old, new)
        let l:data = split(a:text, a:old, 1)
        return join(l:data, a:new)
    endfunc
    if has('win32') || has('win64') || has('win32unix') || has('win95')
        let windows = 1
        let path = tolower(path)
        let path = s:StringReplace(path, '\', '/')
        let sep = ';'
    endif
    for n in split($PATH, sep)
        let key = n
        if windows != 0 
            let key = tolower(key)
            let key = s:StringReplace(key, '\', '/')
        endif
        if key != path 
            let parts += [n]
        endif
    endfor
    let text = join(parts, sep)
    let $PATH = text
endfunc

command! -nargs=1 EnvPathRemove call s:Tools_RemovePath(<q-args>)
