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
	};
}

