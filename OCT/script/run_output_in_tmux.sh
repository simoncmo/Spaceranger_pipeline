############################################################
# Run Spaceranger scripts
# This script read the out/spaceranger_scripts_oct.txt file 
# And create tmux session with n_line panes and start the run in parallel
# Simon - 2022Sep17
############################################################
# ### Create n pane in window 0 based on output Spaceranger output script file
SESSIONNAME="spaceranger"
tmux new-session -s $SESSIONNAME -d # create and detach
# Send command spacernager
input=out/spaceranger_scripts_oct.txt
IDX=0
while IFS= read -r line
do
  echo "$IDX"
  if(( $IDX>0 ))
  then
    tmux split-window -t $SESSIONNAME:0
  fi
  tmux send-keys -t $SESSIONNAME:0.$IDX "echo pane: $IDX" C-m
  tmux send-keys -t $SESSIONNAME:0.$IDX "$line" C-m
  let IDX=IDX+1
done < "$input"

# Change layout
tmux select-layout -t $SESSIONNAME:0 tiled

# Attach to see
tmux select-window -t $SESSIONNAME:0
tmux attach -t $SESSIONNAME

############################################################
# Tmux ref
# https://thoughtbot.com/blog/a-tmux-crash-course
# Send keys : https://unix.stackexchange.com/questions/17116/prevent-pane-window-from-closing-when-command-completes-tmux
# Other exapmle : https://superuser.com/questions/492266/run-or-send-a-command-to-a-tmux-pane-in-a-running-tmux-session#:~:text=Also%2C%20tmux%20makes%20it%20easy,period%2C%20like%20%2Dt%200.
# sample https://gist.github.com/niderhoff/871d953bcf14ab6814255a1ab4b6ab34
# Change layout: https://superuser.com/questions/493048/how-to-convert-2-horizontal-panes-to-vertical-panes-in-tmux
# layout: https://jdhao.github.io/2021/01/25/tmux_cheatsheet/#:~:text=To%20change%20the%20layout%20of,%2C%20main%2Dvertical%20%2C%20tiled%20.
############################################################
