{ pkgs, ... }:
let
  dotfiles-source = pkgs.fetchFromGitHub {
    owner = "i3ima";
    repo = "dotfiles";
    rev = "77a8c0b1104f6fb17d92d25b8e0b91650ca3cb1e";
    hash = "sha256-6NCJ0XxuFpwQPs9+LGX7Y6XXBENns02n45e26pWmFFw=";
    fetchSubmodules = true;
  };
in {
  home.username = "i3ima";
  home.homeDirectory = "/home/i3ima";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    cmake
    glibc
    glibcLocales
    gnumake
    less
    man-pages
    mtr
    neovim
    ninja
    nodejs_22
    nssTools
    python312
    python312Packages.pip
    texinfo
    tmux
    tree-sitter
    vim
    zsh
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "${pkgs.zsh}/bin/zsh";
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    ERL_AFLAGS = "-kernel shell_history enabled";
  };

  home.sessionPath = [
    "$HOME/go/bin"
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
    };
    shellAliases = {
      grep = "grep --color=auto";
      ll = "ls -l";
      ls = "ls -p --color=auto";
      ip = "ip -color=auto";
      vim = "nvim";
    };
    initContent = ''
      eval "$(dircolors -b)"
      short_pwd() {
        local p="''${PWD/#$HOME/~}"
        if [[ "$p" == "/" || "$p" == "~" ]]; then
          print -r -- "$p"
        else
          print -r -- "/.../''${PWD:t}"
        fi
      }

      build_prompt() {
        if [[ -n "$IN_NIX_SHELL" ]]; then
          PROMPT='%F{blue}user@host%f: %2~ [nix] $ '
        else
          PROMPT='%F{magenta}user@host%f: %2~ $ '
        fi
      }

      precmd_functions+=(build_prompt)
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "i3ima";
      user.email = "3b6e08@proton.me";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };
  };

  xdg.configFile = {
    "nvim".source = "${dotfiles-source}/.config/nvim";
    "tmux".source = "${dotfiles-source}/.config/tmux";
  };
}
