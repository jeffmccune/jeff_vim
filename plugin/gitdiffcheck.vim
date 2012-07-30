function! GitDiffCheck(args)
  let cmd = "git diff --check " . a:args
  echo "running: " . cmd

  let efm_bak = &efm
  set efm=%-G\+%s,%-G\-%s,%f:%l:%m
  execute "cexpr system('" . cmd . "')"
  let &efm = efm_bak
  botright copen
endfunction

command! -nargs=* -complete=file GitDiffCheck call GitDiffCheck(<q-args>)
