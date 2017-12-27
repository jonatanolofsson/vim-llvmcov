" ============================================================================
" File:        llvmcov.vim
" Description: Show coverage
" Original Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" Version:     0.1.0
" ============================================================================

command! -complete=shellcmd -nargs=0 Coverage call g:llvmcov#CoverageCurrentFile()
command! -complete=shellcmd -nargs=0 CoverageReportCurrentFile call g:llvmcov#CoverageReportCurrentFile()
command! -complete=shellcmd -nargs=0 CoverageReport call g:llvmcov#CoverageReport()
