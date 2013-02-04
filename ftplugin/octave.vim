" ftplugin for GNU Octave
"
" Author: Johannes Ranke <jranke@uni-bremen.de>
" Adapted from r.vim, originally authored by
" Iago Mosqueira <i.mosqueira@ic.ac.uk>
" Last Change: 2005 Aug 05
" SVN: $Id$
"
" Code written in vim is sent to Octave through a perl pipe
" [funnel.pl, by Larry Clapp <vim@theclapp.org>], as individual lines,
" blocks, or the whole file.
"
" Usage:
"
" Add to filetype.vim:
"   au BufNewFile,BufRead *.m     setf octave
"   au BufNewFile,BufRead *.m     set syntax=matlab
"
" Press <F2> to open a new xterm with a new octave interpreter listening
" to its standard input (you can type octave commands into the xterm)
" as well as to code pasted from within vim.
"
" After selecting a visual block, 'r' sends it to the octave interpreter
"
" In insert mode, <M-Enter> sends the active line to octave and moves to the next
" line (write and process mode).
"
" Maps:
"       <F2>		Start a listening octave interpreter in new xterm
"       <F5>        Run current file
"       <F9>        Run line under cursor or visual block
"       r	        Run visual block
"       <M-Enter>   Write and process
"		<M-q>		Send 'q' to quit long output
"		<M-f>		Send 'f' to move forward in long output
"		<M-b>		Send 'b' to move backward in long output

" Only do this when not yet done for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

"disable backup for .o-pipe
setl backupskip=.*pipe

"set octave-friendly tabbing
set expandtab
set tabstop=4
set shiftwidth=4

"Start a listening octave interpreter in new xterm
noremap <buffer> <F2> :!xterm -T 'Octave' -e perl ~/.vim/ftplugin/funnel.pl ~/.o-pipe octave&<CR><CR>

"send line under cursor to Octave
noremap <buffer> <F9> :execute line(".") 'w >> ~/.o-pipe'<CR>
inoremap <buffer> <F9> <Esc> :execute line(".") 'w >> ~/.o-pipe'<CR>

"send visual selected block to Octave
vnoremap <buffer> r :w >> ~/.o-pipe<CR>

"write and process mode (somehow mapping <C-Enter> does not work for me)
inoremap <M-Enter> <Esc>:execute line(".") 'w >> ~/.o-pipe'<CR>o

"send current file to Octave
noremap <buffer> <F5> :execute '1 ,' line("$") 'w >> ~/.o-pipe' <CR><CR>

"send the letters f,b,q to Octave to control long output
noremap <buffer> <M-f> :!echo "f" >> ~/.o-pipe<CR><CR>
noremap <buffer> <M-b> :!echo "b" >> ~/.o-pipe<CR><CR>
noremap <buffer> <M-q> :!echo "q" >> ~/.o-pipe<CR><CR>
