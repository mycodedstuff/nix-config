{ pkgs, ... }:
let
  tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tokyo-night-tmux";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "janoamaral";
      repo = "tokyo-night-tmux";
      rev = "c2f6fa9884b923a351b9ca7216aefdf0f581b08c";
      sha256 = "sha256-TlM68JajlSBOf/Xg8kxmP1ExwWquDQXeg5utPoigavo=";
    };
    rtpFilePath = "tokyo-night.tmux";
  };
  delta-themes = builtins.fetchurl {
    url =
      "https://raw.githubusercontent.com/dandavison/delta/master/themes.gitconfig";
    sha256 = "sha256:09kfrlmrnj5h3vs8cwfs66yhz2zpgk0qnmajvsr57wsxzgda3mh6";
  };
  bat-cappuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "b19bea35a85a32294ac4732cad5b0dc6495bed32";
    sha256 = "sha256-POoW2sEM6jiymbb+W/9DKIjDM1Buu1HAmrNP0yC2JPg=";
  };
  tmux-ressurect = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-ressurect";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "mycodedstuff";
      repo = "tmux-resurrect";
      rev = "c967c03155532c8c36f7c2e9d75bea742628fba8";
      sha256 = "sha256-colMKncYZj/3Oe5soawIDNPAz53o3USVzuhQimVqLXA=";
    };
    rtpFilePath = "resurrect.tmux";
  };
  tmux-network-bandwidth = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-network-bandwidth";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "xamut";
      repo = "tmux-network-bandwidth";
      rev = "63c6b3283d537d9b86489c13b99ba0c65e0edac8";
      sha256 = "sha256-8FP7xdeRe90+ksQJO0sQ35OdH1BxVY7PkB8ZXruvSXM=";
    };
    rtpFilePath = "tmux-network-bandwidth.tmux";
  };
  # Platform-independent terminal setup
in {
  xdg.configFile = {
    "direnv/direnv.toml".text = ''
      [global]
      hide_env_diff = true
    '';
  };
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    # Unix tools
    ripgrep # Better `grep`
    fd
    sd
    tree
    fzf
    sad
    bottom
    coreutils
    ghostscript
    just
    tmate
    go
    process-compose
    rustup
    yazi

    # Nix dev
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt
    nixci
    nix-health

    #Formatters
    jq
    nixfmt
    haskellPackages.hindent
    haskellPackages.cabal-fmt
    prettierd
    stylua
    black
    codespell
    cmake-format
  ];

  home.shellAliases = {
    g = "git";
    lg = "lazygit";
    v = "nvim";
    t = "tmux";
  };

  # Programs natively supported by home-manager.
  programs = {
    bat = {
      enable = true;
      themes = {
        catppuccin-mocha = {
          src = bat-cappuccin;
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
      config = { theme = "catppuccin-mocha"; };
    };
    zoxide.enable = true;
    fzf.enable = true;
    jq.enable = true;
    htop.enable = true;

    # command-not-found handler to suggest nix way of installing stuff.
    # FIXME: This ought to show new nix cli commands though:
    # https://github.com/nix-community/nix-index/issues/191
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    # on macOS, you probably don't need this
    bash = {
      enable = true;
      initExtra = ''
        # Make Nix and home-manager installed things available in PATH.
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      '';
    };

    # For macOS's default shell.
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      autocd = true;
      history = {
        size = 100000000;
        expireDuplicatesFirst = true;
        save = 100000000;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker" "direnv" "fzf" ];
      };
      envExtra = ''
        export NVM_DIR="$HOME/.nvm"
        function nvm() {
          [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
            nvm "$@"
        }
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        export PATH="/Users/amansingh/.scripts:/Users/amansingh/Library/Python/3.8/bin:/usr/local/opt/postgresql@13/bin:/usr/local/opt/openjdk@8/bin:/usr/local/sbin:$PATH"
        export PATH="/Users/amansingh/.pyenv/versions/2.7.18/bin:/Users/amansingh/.local/bin:$PATH"
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH

        # Make Nix and home-manager installed things available in PATH.
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
        [ -f "/Users/amansingh/.ghcup/env" ] && source "/Users/amansingh/.ghcup/env" # ghcup-env
      '';
    };

    # https://zero-to-flakes.com/direnv
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # https://nixos.asia/en/git
    git = {
      enable = true;
      includes = [{ path = delta-themes; }];
      extraConfig = {
        init.defaultBranch = "master";
        core = { fsmonitor = true; };
        push.autoSetupRemote = true;
        diff.algorithm = "histogram";
        merge.conflictstyle = "zdiff3";
      };
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          side-by-side = false;
          features = "mellow-barbet";
        };
      };
    };
    tmux = {
      enable = true;
      mouse = true;
      baseIndex = 1;
      historyLimit = 200000;
      escapeTime = 5;
      terminal = "screen-256color";
      keyMode = "vi";
      shortcut = "x";
      plugins = with pkgs.tmuxPlugins; [
        logging
        {
          plugin = tokyo-night;
          extraConfig = ''
            set -g @tokyo-night-tmux_window_id_style fsquare
            set -g @tokyo-night-tmux_pane_id_style hsquare
          '';
        }
        {
          plugin = tmux-network-bandwidth;
          extraConfig = let
            script = pkgs.writeShellScript "status-right-decor" ''
              tmux set-option -gq status-right "#[bg=#15161e] #{network_bandwidth} $(tmux show-option -gqv status-right)"
            '';
          in ''
          set-option -g status-interval 2
          run-shell ${script}
          '';
        }
        {
          plugin = tmux-ressurect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-save-command-strategy 'psutil'
            set -g @resurrect-processes '~nvim' #set this to :all: to allow all processes
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-save-interval '5' # minutes
          '';
        }
        vim-tmux-navigator
      ];
      extraConfig = ''
        bind v copy-mode
        bind -n C-b send-keys -R ^M \; clear-history
        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -c "#{pane_current_path}"
        bind "'" split-window -h -c "#{pane_current_path}"
        bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe pbcopy
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel pbcopy
        bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel pbcopy
        set-option -g renumber-windows on
        set-option -g repeat-time 300
      '';
    };

    lazygit = {
      enable = true;
      settings = {
        gui = {
          activeBorderColor = [ "#f9e2af" "bold" ];
          inactiveBorderColor = "#a6adc8";
          optionsTextColor = "#89b4fa";
          selectedLineBgColor = "#313244";
          cherryPickedCommitBgColor = "#45475a";
          cherryPickedCommitFgColor = "#f9e2af";
          unstagedChangesColor = "#f38ba8";
          defaultFgColor = "#cdd6f4";
          searchingActiveBorderColor = "#f9e2af";
        };
        os = { editPreset = "nvim"; };
      };
    };
  };
}
