.PHONY: personal-mac bloomberg-mac bloomberg-spaces link unlink

personal-mac:
	DOTFILES_PROFILE=personal-mac bash install.sh

bloomberg-mac:
	DOTFILES_PROFILE=bloomberg-mac bash install.sh

bloomberg-spaces:
	DOTFILES_PROFILE=bloomberg-spaces DOTFILES_REMOTE=1 bash install.sh

link:
	bash install.sh --link-only

unlink:
	@echo "Removing symlinks..."
	@rm -f ~/.config/fish ~/.config/nvim ~/.config/ghostty ~/.config/starship.toml
	@rm -f ~/.tmux.conf ~/.gitconfig ~/.gitignore_global
	@echo "Done. Originals untouched."
