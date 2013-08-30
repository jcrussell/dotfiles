if exists('g:loaded_tab_wrapper') || &cp
  finish
endif
let g:loaded_tab_wrapper = 1

inoremap <tab> <c-r>=InsertTabWrapper(1)<cr>
inoremap <S-tab> <c-r>=InsertTabWrapper(0)<cr>

" InsertTabWrapper() {{{
" Tab completion of tags/keywords if not at the beginning of the line.
function! InsertTabWrapper(forward)
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  elseif a:forward
    return "\<c-p>"
  else
    return "\<c-n>"
  endif
endfunction
" InsertTabWrapper() }}}
