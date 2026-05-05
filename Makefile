.PHONY: personal work work-remote link unlink

personal:
	DOTFILES_PROFILE=personal bash install.sh

work:
	DOTFILES_PROFILE=work bash install.sh

work-remote:
	DOTFILES_PROFILE=work DOTFILES_REMOTE=1 bash install.sh

link:
	bash install.sh --link-only

unlink:
	@echo "Removing symlinks..."
	@rm -f ~/.config/fish ~/.config/nvim ~/.config/ghostty ~/.config/starship.toml
	@rm -f ~/.tmux.conf ~/.gitconfig ~/.gitignore_global
	@echo "Done. Originals untouched."
