" ============================================================================
" Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" ============================================================================

if !exists('g:llvmcov#bin')
  let g:llvmcov#bin = "build/test/lib/unit_tests"
endif

if !exists('g:llvmcov#pwd')
  let g:llvmcov#pwd = "."
endif

fu! s:GetProfDataPath(pwd)
  return a:pwd . "/default.profdata"
endf

fu! s:GetProfRawPath(pwd)
  return a:pwd . "/default.profraw"
endf

fu! s:RunShellCommand(cmdline)
  botright vnew
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  execute 'silent read !'. a:cmdline
  setlocal nomodifiable
endf

fu! s:GetLlvmCovCommand(profile, bin, source)
  return "llvm-cov show " . " -instr-profile=" . a:profile . " " . a:bin . " " . a:source " --use-color=0"
endf

fu! s:GetRefreshDataCommand(pwd, bin)
	let l:profraw = s:GetProfRawPath(g:llvmcov#pwd)
  return "! mkdir -p " . a:pwd . " && cd " . a:pwd . " && LLVM_PROFILE_FILE=default.profraw " . a:bin . " && llvm-profdata merge -o default.profdata default.profraw"
endf

fu! g:llvmcov#RefreshData()
	let l:bin = fnamemodify(g:llvmcov#bin, ':p')
	let l:cmd = s:GetRefreshDataCommand(g:llvmcov#pwd, l:bin)
  execute l:cmd
endf

fu! g:llvmcov#CoverageCurrentFile()
	let l:profdata = s:GetProfDataPath(g:llvmcov#pwd)
  let l:cmd = s:GetLlvmCovCommand(l:profdata, g:llvmcov#bin, @%)
  call s:RunShellCommand(l:cmd)
endf
