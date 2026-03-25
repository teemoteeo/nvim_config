" -------------------------------------
" GDB_INTEGRATION.VIM
" Run GDB in a terminal split
" -------------------------------------
command! -nargs=* GDB call s:open_gdb(<f-args>)

function! s:open_gdb(...)
    let l:args = a:000
    if len(l:args) == 0
        let l:prog = input('Program to debug: ')
    else
        let l:prog = l:args[0]
    endif
    belowright split
    resize 15
    terminal gdb l:prog
endfunction

