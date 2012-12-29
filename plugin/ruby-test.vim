" rspec-vimbundle.vim: Runs rspec, presents results in quickfix window.
" Requires Vim to be compiled with Ruby extensions, and for the RSpec
" formatters to be in this plugin's root directory.

let s:home = expand("<sfile>:p:h:h")



function! RunSpec(command)
  if a:command == ''
    let dir = 'spec'
  else
    let dir = a:command
  endif
  cexpr system("spec -r " . s:home . "/spec_formatter.rb -f Spec::Runner::Formatter::VimSpecFormatter " . dir)
  cwindow
endfunction

" have :Spec run rspecs (args with pathname completion, :Spec spec/views)
command! -nargs=? -complete=file Spec call RunSpec(<q-args>)


function! RunRSpec(command)
  if a:command == ''
    let dir = 'spec'
  else
    let dir = a:command
  endif
  cexpr system("rspec -r " . s:home . "/rspec_formatter.rb -f RSpec::Core::Formatters::VimFormatter " . dir)
  cwindow
endfunction

" have :Spec run rspecs (args with pathname completion, :Spec spec/views)
command! -nargs=? -complete=file RSpec call RunRSpec(<q-args>)


function! RunMiniTest(command)
  if a:command == ''
    let files = substitute(glob("test/**/test_*.rb"), "\n", " ", "g")
  else
    let files = a:command
  endif
  cexpr system("ruby -Ilib:bin:test:. -rubygems -rminitest/autorun -e 'ARGV.each { \|a\| require \"./\"+a }' " . files)
  cwindow
endfunction

command! -nargs=? -complete=file MiniTest call RunMiniTest(<q-args>)


function! RunTestUnit(command)
  if a:command == ''
    let files = substitute(glob("test/**/test_*.rb"), "\n", " ", "g")
  else
    let files = a:command
  endif
  cexpr system("ruby -Ilib:bin:test:. -rtest/unit -e 'ARGV.each { \|a\| require \"./\"+a }' " . files)
  cwindow
endfunction

command! -nargs=? -complete=file TestUnit call RunTestUnit(<q-args>)

