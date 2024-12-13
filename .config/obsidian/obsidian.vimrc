" Make <space> available as a leader key
unmap <Space>

"^$ The symbol is too hard to press
map gh ^
map gl $


" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk


" Quickly remove search highlights
nmap <F9> :nohl<CR>


" Yank to system clipboard
set clipboard=unnamed


" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>


" Tab management
exmap tabnext obcommand workspace:next-tab
nmap <Space>tl :tabnext<CR>
exmap tabprev obcommand workspace:previous-tab
nmap <Space>th :tabprev<CR>


" Move between panes
exmap focus_top obcommand editor:focus-top
exmap focus_bottom obcommand editor:focus-bottom
exmap focus_left obcommand editor:focus-left
exmap focus_right obcommand editor:focus-right
map <C-k> :focus_top<CR>
map <C-j> :focus_bottom<CR>
map <C-h> :focus_left<CR>
map <C-l> :focus_right<CR>


" split panes
exmap split_vertical obcommand workspace:split-vertical
exmap split_horizonal obcommand workspace:split-horizontal
exmap close obcommand workspace:close


map <Space>_ :split_vertical<CR>
map <Space>- :split_horizonal<CR>
map <Space>x :close<CR>


" searching
exmap g_search obcommand global-search:open
map <Space>sf :g_search<CR>

