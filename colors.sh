# Prints out all the colors in the single byte space. 
# use this to set the colors in tmux
for i in {0..255} ; do
    printf "\x1b[38;5;${i}mcolour${i}\n"
done
