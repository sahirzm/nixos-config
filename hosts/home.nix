{ pkgs, user, inputs, ... }:
let
  polybar-themes = inputs.polybar-themes;
  polybar-themes-pkg = pkgs.stdenvNoCC.mkDerivation {
    pname = "polybar-themes";
    version = "1.0.0";
    src = inputs.polybar-themes;
    installPhase = ''
                 runHook preInstall
                 cp -r bitmap $out/
                 mkdir -p $out/share/fonts/truetype
                 cp -r fonts/* $out/share/fonts/truetype
                 runHook postInstall
    '';
  };
in
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
      nil # LSP for nix
      polybar-themes-pkg
    ];
    stateVersion = "22.11";
  };
  programs = {
    git = {
      enable = true;
      userEmail = "sahirzm@gmail.com";
      userName = "Sahir Maredia";
      aliases = {
        dag = "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(cyan)%aD%C(reset) %C(green)(%ar)%C(reset)%C(yellow)%d%C(reset)%n'' %C(white)%s%C(reset) %C(white)- %an%C(reset)' --all";
        graph = "log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset'";
      };
      diff-so-fancy.enable = true;
      extraConfig = {
        pull = {
          rebase = true;
        };
        core = {
          excludesFile = "$HOME/.config/git/exclude";
          fileMode = false;
        };
        color = {
          ui = "auto";
        };
        push = {
          default = "simple";
        };
        difftool = {
          prompt = true;
        };
        diff = {
          tool = "nvimdiff";
        };
        "difftool \"nvimdiff\"" = {
          cmd = "nvim -d \"\$LOCAL\" \"\$REMOTE\"";
        };
      };
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
        tmuxPlugins.jump
      ];
    };
    emacs = {
      enable = true;
      package = pkgs.emacs-unstable;
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
      enable = false;
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
    "gitexclude" = {
      text = ''
# projectile
.projectile
'';
      target = "git/exclude";
    };
  };

  home.file = {
    "Xresources" = {
      source = ./dotfiles/Xresources.txt;
      target = ".Xresources";
    };
    "polybar-theme" = {
      source = "${polybar-themes-pkg}";
      target = ".config/polybar";
      recursive = true;
      enable = true;
    };
  };

  services = {
    mpris-proxy.enable = true;
  };

  fonts.fontconfig = {
    enable = true;
  };
}
  
