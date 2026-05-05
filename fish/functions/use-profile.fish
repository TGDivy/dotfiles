function use-profile --description "Switch dotfiles profile (personal|work) without reinstalling"
    set -l valid_profiles personal work
    set -l profile $argv[1]

    if test -z "$profile"
        echo "Usage: use-profile <profile>"
        echo "Available: $valid_profiles"
        return 1
    end

    if not contains -- $profile $valid_profiles
        echo "Unknown profile: $profile"
        echo "Available: $valid_profiles"
        return 1
    end

    # Write profile marker (read by fish + nvim on next start)
    echo "export DOTFILES_PROFILE=$profile" > ~/.dotfiles_profile

    # Set in current session immediately
    set -gx DOTFILES_PROFILE $profile

    # Re-source profile-specific fish config
    set -l profile_file ~/.dotfiles/fish/profiles/$profile.fish
    if test -f $profile_file
        source $profile_file
        echo "[dotfiles] Fish profile loaded: $profile"
    end

    # Re-symlink ~/.clang-format to the profile's style
    set -l clang_src ~/.dotfiles/tools/clang-format.$profile
    if test -f $clang_src
        ln -sfn $clang_src ~/.clang-format
        echo "[dotfiles] clang-format → $clang_src"
    end

    # Re-symlink git active profile
    set -l git_src ~/.dotfiles/git/profiles/$profile.gitconfig
    set -l git_dst ~/.dotfiles/git/profiles/active.gitconfig
    if test -f $git_src
        ln -sfn $git_src $git_dst
        echo "[dotfiles] git profile → $profile"
    end

    echo "[dotfiles] Profile switched to: $profile (restart nvim to apply editor overrides)"
end
