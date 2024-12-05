" ============================================================================
" File:        vim-lastplace.vim
" Description: Reopen files where you left off. Configurable.
" Author:      Gregory L. Dietsche <greg@gregd.org>
" Licence:     MIT
" Website:     https://www.gregd.org/
" Version:     4.6.0
" ============================================================================

if exists("b:loaded_lastplace_plugin") || &cp
    finish
endif
let b:loaded_lastplace_plugin = 1

scriptencoding utf-8

if !exists('g:lastplace_ignore')
    let g:lastplace_ignore = "gitcommit,gitrebase,hgcommit,svn,xxd"
endif

if !exists('g:lastplace_ignore_buftype')
    let g:lastplace_ignore_buftype = "help,nofile,quickfix"
endif

if !exists('g:lastplace_force_schemes')
    let g:lastplace_force_schemes = "suda://"
endif

if !exists('g:lastplace_open_folds')
    let g:lastplace_open_folds = 1
endif

fu! s:lastplace_can_run()
    if index(split(g:lastplace_ignore_buftype, ","), &buftype) != -1
        return 0
    endif

    if index(split(g:lastplace_ignore, ","), &filetype) != -1
        return 0
    endif

    try
        "check for schemes to force allow, since checking existence is hard
        for s in split(g:lastplace_force_schemes, ',')
            if stridx(@%, s) == 0
                return 1
            endif
        endfor

        "if the file does not exist on disk, then do nothing
        "this could be a new, unsaved file, or a non-filesystem path
        if empty(glob(@%))
            return 0
        endif
    catch
        return 0
    endtry

    return 1
endf

fu! s:lastplace_jump()"{{{
    if !s:lastplace_can_run()
        return
    endif

    if line("'\"") > 0 && line("'\"") <= line("$")
        "if the last edit position is set and is less than the number of lines in this buffer.

        if line("w$") == line("$")
            "if the last line in the current buffer is also the last line visible in this window
            execute "normal! g`\""

        elseif line("$") - line("'\"") > ((line("w$") - line("w0")) / 2) - 1
            "if we're not at the bottom of the file, center the cursor on the screen after we make the jump
            execute "normal! g`\"zz"

        else
            "otherwise, show as much context as we can by jumping to the end of the file and then to the mark.
            "if we pressed zz here, there would be blank lines at the bottom of the screen.
            "we intentionally leave the last line blank by pressing <c-e> so the user can see that they are near the end of the file.
            execute "keepjumps normal! \G`\"\<c-e>"
        endif
    endif
endf"}}}

fu! s:lastplace_open_folds()
    if !s:lastplace_can_run()
        return
    endif

    if foldclosed(".") != -1 && g:lastplace_open_folds
        "if we're in a fold, make the current line visible and recenter screen
        execute "normal! zvzz"
    endif
endf

augroup lastplace_plugin
    autocmd!
    autocmd BufRead     * call s:lastplace_jump()
    autocmd BufWinEnter * call s:lastplace_open_folds()
augroup END
