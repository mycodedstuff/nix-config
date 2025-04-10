{ ... }: {
  programs = {
    # on macOS, you probably don't need this
    bash = {
      enable = true;
      initExtra = ''
        # Custom bash profile goes here
      '';
    };

    # For macOS's default shell.
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
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
        # Custom ~/.zshenv goes here
        LANG=en_GB.UTF-8
        NVM_DIR="$HOME/.nvm"
      '';
      profileExtra = ''
        # Custom ~/.zprofile goes here
        [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
        [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

        export PATH="/Users/aman.singh/.scripts:/Users/aman.singh/Library/Python/3.8/bin:/usr/local/opt/postgresql@13/bin:/usr/local/opt/openjdk@8/bin:/usr/local/sbin:/usr/local/bin:$PATH"
        export PATH="/Users/aman.singh/.pyenv/versions/2.7.18/bin:/Users/aman.singh/.local/bin:$PATH"

        # Make Nix and home-manager installed things available in PATH.
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
        export PATH="/usr/local/opt/llvm@12/bin:$PATH"
        [ -f "/Users/aman.singh/.ghcup/env" ] && source "/Users/aman.singh/.ghcup/env" # ghcup-env
      '';
      loginExtra = ''
        # Custom ~/.zlogin goes here
      '';
      logoutExtra = ''
        # Custom ~/.zlogout goes here
      '';
    };

    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;

    # Better shell prmot!
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = true;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = true;
        };
        gcloud.disabled = true;
      };
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
