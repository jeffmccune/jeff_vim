" Find the project directory for this file, may differ from the current
" working directory.
function! ProjectDirectory()
  let l:fullpath = expand("%:p")
  let l:filepath = expand("%:h")
  let l:fname = expand("%:t")
  let l:check = fnamemodify(expand(l:fullpath), ":h")
  let l:indicators = [ "spec/spec_helper.rb", ".git/HEAD", "Gemfile", ".bundle/config" ]
  while l:check != "/"
    for indicator in l:indicators
      if filereadable(l:check . "/" . indicator)
        return l:check
      end
    endfor
    let l:check = fnamemodify(expand(l:check), ":h")
  endwhile
  return l:filepath
endfunction

" Find the related spec for any file you open.
function! RelatedSpec()
  let l:fullpath = expand("%:p")
  let l:filepath = expand("%:h")
  let l:fname = expand("%:t")

  let l:project_dir = ProjectDirectory()

  " Trim these prefixes
  let l:fullpath_prefixes = [l:project_dir]
  let l:project_prefixes = ["lib", "app"]

  " Trim off common prefixes
  let l:filepath_trim = l:fullpath

  for fp_prefix in l:fullpath_prefixes
    for pr_prefix in l:project_prefixes
      let l:filepath_trim = substitute(l:filepath_trim, "^" . fp_prefix . "/" . pr_prefix . "$", "", "")
      let l:filepath_trim = substitute(l:filepath_trim, "^" . fp_prefix . "/" . pr_prefix . "/", "", "")
    endfor
  endfor

  " Get the dirname of the trimmed file path
  let l:filepath_trim = fnamemodify(expand(l:filepath_trim), ":h")

  " Possible names for the spec/test for the file we're looking at
  let l:test_names = [substitute(l:fname, ".rb$", "_spec.rb", ""), substitute(l:fname, ".rb$", "_test.rb", "")]

  " Possible paths
  let l:test_paths = ["spec/unit", "spec", "fast_spec", "test"]

  for test_name in l:test_names
    for path in l:test_paths
      let l:spec_path = l:project_dir . "/" . path . "/" . l:filepath_trim . "/" . test_name
      if filereadable(l:spec_path)
        return l:spec_path
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
