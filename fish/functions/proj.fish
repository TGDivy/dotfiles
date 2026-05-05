function proj -d "cd to project dir and attach/new tmux session"
    set -l dir $argv[1]
    if not test -d $dir
        echo "Not a directory: $dir"
        return 1
    end
    set -l name (basename $dir)
    cd $dir
    if command -q tmux
        if tmux has-session -t $name 2>/dev/null
            tmux attach -t $name
        else
            tmux new-session -s $name -c $dir
        end
    end
end
