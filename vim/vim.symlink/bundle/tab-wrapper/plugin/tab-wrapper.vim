if exists('g:loaded_tab_wrapper') || &cp
  finish
endif
let g:loaded_tab_wrapper = 1

inoremap <tab> <c-r>=InsertTabWrapper()<cr>
" InsertTabWrapper() {{{
" Tab completion of tags/keywords if not at the beginning of the
" line.  Very slick.
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
" InsertTabWrapper() }}}
