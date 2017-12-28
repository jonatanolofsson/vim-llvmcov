" ============================================================================
" Original Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" ============================================================================

if !exists('g:llvmcov#projdir')
  if exists('g:TOP')
    let g:llvmcov#projdir = g:TOP
  endif
  let g:llvmcov#projdir = fnamemodify("..", ":p")
endif

if !exists('g:llvmcov#profdata')
  let g:llvmcov#profdata = "tests/default.profdata"
endif

fu! s:GetBins()
  if exists('g:llvmcov#bin')
      return g:llvmcov#bin
  endif
  return systemlist('find ' . g:llvmcov#projdir . '/tests -executable -type f | xargs')[0]
endf

fu! s:GetProfDataPath()
  return g:llvmcov#projdir . "/" . g:llvmcov#profdata
endf

fu! s:RunShellCommand(cmdline)
  botright vnew
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  execute 'silent .!'. a:cmdline
  setlocal nomodifiable
endf

fu! s:GetReportCommand(profile, bin, source)
  return "llvm-cov report " . " -instr-profile=" . a:profile . " " . a:bin . " " . a:source " --use-color=0"
endf

fu! s:GetLlvmCovCommand(profile, bin, source)
  return "llvm-cov show " . " -instr-profile=" . a:profile . " -object " . a:bin . " " . a:source " --use-color=0 -show-instantiations=0 -Xdemangler c++filt -Xdemangler -n -line-coverage-lt=1"
endf

fu! s:HighlightNoCoverage()
  highlight CoverageNone term=reverse ctermbg=52 gui=undercurl guisp=#FF0000
  match CoverageNone /\ \+0|.*/
endf

fu! g:llvmcov#CoverageCurrentFile()
  let l:profdata = s:GetProfDataPath()
  let l:bins = s:GetBins()
  let l:file = expand('%:p')
  let l:cmd = s:GetLlvmCovCommand(l:profdata, l:bins, l:file)
  let l:current_line = line('.') + 2 " FIXME +2 is a fix for bad llvm-cov output
  "windo set scrollbind
  call s:RunShellCommand(l:cmd)
  execute ':0' . l:current_line
  call s:HighlightNoCoverage()
endf

fu! g:llvmcov#CoverageReport()
  let l:profdata = s:GetProfDataPath()
  let l:bins = s:GetBins()
  let l:cmd = s:GetReportCommand(l:profdata, l:bins, '')
  call s:RunShellCommand(l:cmd)
endf

fu! g:llvmcov#CoverageReportCurrentFile()
  let l:profdata = s:GetProfDataPath()
  let l:bins = s:GetBins()
  let l:file = expand('%:p')
  let l:cmd = s:GetReportCommand(l:profdata, l:bins, l:file)
  call s:RunShellCommand(l:cmd)
endf
