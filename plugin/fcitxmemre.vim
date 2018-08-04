scriptencoding utf-8

if exists('g:loaded_fcitxmemre')
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

if has("unix")
    augroup FcitxMemRe
        autocmd!
        autocmd BufWinEnter * let b:input_toggle = 0
        autocmd InsertEnter * call InsEnter()
    augroup END

    if has("gui_running")
        inoremap <expr> <ESC> InsLeave()
    else
        augroup FcitxMemRe
          autocmd InsertLeave * call InsLeave()
        augroup END
    endif

    function! InsLeave()
        if !exists('b:input_toggle')
            return "\<ESC>"
        endif

        let s:input_status = system("fcitx-remote")
        if s:input_status == 2
            let l:a = system("fcitx-remote -c")
            let b:input_toggle = 1
        endif
        return "\<ESC>"
    endfunction

    function! InsEnter()
        if !exists('b:input_toggle')
            return
        endif

        let s:input_status = system("fcitx-remote")
        if s:input_status != 2 && b:input_toggle == 1
            let l:a = system("fcitx-remote -o")
            let b:input_toggle = 0
        endif
    endfunction
endif

let &cpo = s:save_cpo
unlet s:save_cpo

let g:leaded_fcitxmemre = 1
