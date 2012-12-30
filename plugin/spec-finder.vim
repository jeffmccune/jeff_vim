" Find the related spec for any file you open.
function! RelatedSpec()
  let l:fullpath = expand("%:p")
  let l:filepath = expand("%:h")
  let l:fname = expand("%:t")

  " Trim off common prefixes
  let l:filepath_trim = l:filepath
  let l:filepath_trim = substitute(l:filepath_trim, "^lib$", "", "")
  let l:filepath_trim = substitute(l:filepath_trim, "^lib/", "", "")
  let l:filepath_trim = substitute(l:filepath_trim, "^app$", "", "")
  let l:filepath_trim = substitute(l:filepath_trim, "^app/", "", "")

  " Possible names for the spec/test for the file we're looking at
  let l:test_names = [substitute(l:fname, ".rb$", "_spec.rb", ""), substitute(l:fname, ".rb$", "_test.rb", "")]

  " Possible paths
  let l:test_paths = ["spec/unit", "spec", "fast_spec", "test"]

  for test_name in l:test_names
    for path in l:test_paths
      let l:spec_path = path . "/" . l:filepath_trim . "/" . test_name
      let l:full_spec_path = substitute(l:fullpath, l:filepath . "/" . l:fname, l:spec_path, "")
      if filereadable(l:spec_path)
        return l:full_spec_path
      end
    endfor
  endfor
endfunction

function! RelatedSpecOpen()
  let l:spec_path = RelatedSpec()
  if filereadable(l:spec_path)
    execute ":e " . l:spec_path
  endif
endfunction

function! RelatedSpecVOpen()
  let l:spec_path = RelatedSpec()
  if filereadable(l:spec_path)
    execute ":botright vsp " . l:spec_path
  endif
endfunction

" RelatedSpecMake is useful if the compiler in Vim can parse the output of
" rspec into the quickfix list.
function! RelatedSpecMake()
  let l:spec_path = RelatedSpec()
  if filereadable(l:spec_path)
    execute ":make " . l:spec_path
  endif
endfunction

command! RelatedSpecMake call RelatedSpecMake()
command! RelatedSpecVOpen call RelatedSpecVOpen()
command! RelatedSpecOpen call RelatedSpecOpen()

nnoremap <silent> <C-s> :RelatedSpecVOpen<CR>
nnoremap <silent> ,<C-s> :RelatedSpecOpen<CR>
