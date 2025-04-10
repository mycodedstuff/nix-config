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
  # tmux-ressurect = pkgs.tmuxPlugins.mkTmuxPlugin {
  #   pluginName = "tmux-ressurect";
  #   version = "master";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "mycodedstuff";
  #     repo = "tmux-resurrect";
  #     rev = "c967c03155532c8c36f7c2e9d75bea742628fba8";
  #     sha256 = "sha256-colMKncYZj/3Oe5soawIDNPAz53o3USVzuhQimVqLXA=";
  #   };
  #   rtpFilePath = "resurrect.tmux";
  # };
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
in
{
  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  # https://nixos.asia/en/git
  programs = {
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
          extraConfig =
            let
              script = pkgs.writeShellScript "status-right-decor" ''
                tmux set-option -gq status-right "#[bg=#15161e] #{network_bandwidth} $(tmux show-option -gqv status-right)"
              '';
            in
            ''
              set-option -g status-interval 2
              run-shell ${script}
            '';
        }
        # {
        #   plugin = tmux-ressurect;
        #   extraConfig = ''
        #     set -g @resurrect-strategy-nvim 'session'
        #     set -g @resurrect-save-command-strategy 'psutil'
        #     set -g @resurrect-processes '~nvim' #set this to :all: to allow all processes
        #   '';
        # }
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
  };
}
