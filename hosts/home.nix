{ config, builtins, lib, pkgs, user, ... }:
{

	home = {
		username = "${user}";
		packages = with pkgs; [
				alacritty 
				neovim 
				emacs 
				firefox
				google-chrome
				tmux
		];
		stateVersion = "22.11";
	};
	programs = {
		git = {
			enable = true;
			userEmail = "sahirzm@gmail.com";
			userName = "Sahir Maredia";
		};
		zsh = {
			enable = true;
			zplug = {
				enable = true;
				plugins = [
				{ name = "zsh-users/zsh-autosuggestions"; }
				{ name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
				{ name = "zsh-users/zsh-completions"; }
				{ name = "zsh-users/zsh-syntax-highlighting"; }
				];
			};
			initExtra = ''
				[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
			'';
		};
		alacritty = {
			enable = true;
			settings = builtins.fromJSON (builtins.readFile ./files/alacritty.json);
		};
		tmux = {
			enable = true;
			baseIndex = 1;
			clock24 = true;
			historyLimit = 100000;
			keyMode = "vi";
			newSession = true;
			resizeAmount = 20;
			customPaneNavigationAndResize = true;
			prefix = "C-a";
			shell = "\${pkgs.zsh}/bin/zsh";
			shortcut = "a";
			terminal = "screen-256color";
			extraConfig = 
			''
			#bind Ctrl-K to sync panes
			bind C-k set-window-option synchronize-panes
			# set numbering from 1 instead of 0 for panes
			setw -g pane-base-index 1
			# split windows
			bind | split-window -h
			bind - split-window -v
			# reload config file
			bind r source-file ~/.tmux.conf
			set -g set-clipboard on
			'';
			plugins = with pkgs; [
				tmuxPlugins.yank
				{
					plugin = tmuxPlugins.jump;
					extraConfig =
					''
					set -g @jump-key ';'
					'';
				}
			];
		};
	};
}

