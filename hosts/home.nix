{ config, builtins, lib, pkgs, user, inputs, ... }:
{
  home = {
    username = "${user}";
    packages = with pkgs; [
      alacritty 
      firefox
      google-chrome
      tmux
      nodejs
      neovim
      gcc
      tree-sitter
      (python39.withPackages (pp: with pp; [
        pynvim
      ]))
      fzf
      ripgrep
      jdk17
      jetbrains.idea-community
      dbeaver
      neofetch
      feh # wallpaper
      lsd # beautiful directory listing
      picom # manage window transparency
      ranger # terminal file browser
      fd # faster file search
      # faster grep options
      ripgrep
      fzf
      silver-searcher
      bat # better cat
      diff-so-fancy # good looking diffs filter for git
      tldr # simplified man pages
      tree
      broot
      jq # JSON processor
      curl
      httpie # better curl
      docker
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
      shellAliases = {
        ls = "lsd -l";
      };
      initExtra = ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        neofetch
        '';
    };
    alacritty = {
      enable = true;
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
        set -g @jump-key ';'
        '';
      plugins = with pkgs; [
        tmuxPlugins.yank
        tmuxPlugins.dracula
        tmuxPlugins.jump
      ];
    };
  };

  xdg.configFile = {
    "waybar" = {
      source = ./dotfiles/waybar;
      target = "waybar";
      recursive = true;
    };
    "hyprland" = {
      source = ./dotfiles/hypr;
      target = "hypr";
      recursive = true;
    };
    "wpaperd" = {
      source = ./dotfiles/wpaperd;
      target = "wpaperd";
      recursive = true;
    };
    "wofi" = {
      source = ./dotfiles/wofi;
      target = "wofi";
      recursive = true;
    };
    "doom" = {
      source = ./dotfiles/doom;
      target = "doom";
      recursive = true;
      onChange = "$HOME/.config/emacs/bin/doom sync";
    };
    "i3" = {
      source = ./dotfiles/i3;
      target = "i3";
      recursive = true;
    };
    "alacritty" = {
      source = ./dotfiles/alacritty;
      target = "alacritty";
      recursive = true;
    };
    "rofi" = {
      source = ./dotfiles/rofi;
      target = "rofi";
      recursive = true;
    };
    "polybar" = {
      source = ./dotfiles/polybar;
      target = "polybar";
      recursive = true;
    };
    "picom" = {
      source = ./dotfiles/picom;
      target = "picom";
      recursive = true;
    };
    "ranger" = {
      source = ./dotfiles/ranger;
      target = "ranger";
      recursive = true;
    };
    "ranger_devicons" = {
      source = inputs.ranger_devicons;
      target = "ranger/plugins/ranger_devicons";
    };
  };

  home.file = {
    "Xresources" = {
      source = ./dotfiles/Xresources.txt;
      target = ".Xresources";
    };
  };
}
