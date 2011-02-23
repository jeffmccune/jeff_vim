" With a visual block selected, align =>'s
vmap . :Align =><CR>

function! AlignFats()
  let save_cursor = getpos(".")
  call SelectIndent()
  exe "norm ."
  call setpos('.', save_cursor)
endfun

noremap , :call AlignFats()<CR>
