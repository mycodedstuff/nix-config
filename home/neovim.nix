{ flake, ... }: {
  imports = [ flake.inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;

    # theme
    colorschemes.tokyonight.enable = true;

    # settings
    options = {
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      number = true;
    };

    # keymaps
    globals = { mapleader = " "; };

    keymaps = [
      {
        key = "<leader>ft";
        action = "<cmd>Telescope buffers<cr>";
        options = {
          desc = "nvim tabs";
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader>tt";
        action = "<cmd>Neotree toggle<cr>";
        options = {
          desc = "toggle neotree";
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader>tf";
        action = "<cmd>Neotree focus<cr>";
        options = {
          desc = "focus neotree";
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader>ff";
        action = "<cmd>Telescope live_grep<cr>";
        options = {
          desc = "file live grep";
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader>gd";
        action = "<cmd>lua require('telescope.builtin').git_status()<cr>";
        options = {
          desc = "file live grep";
          silent = true;
          remap = false;
        };
      }
    ];
    plugins = {

      # UI
      lualine.enable = true;
      bufferline.enable = true;
      treesitter.enable = true;
      which-key.enable = true;
      gitblame.enable = true;
      diffview.enable = true;
      notify.enable = true;
      trouble.enable = true;
      cmp = {
        enable = true;
        settings = {
          sources = [
            {
              name = "nvim_lsp";
              group_index = 1;
            }
            {
              name = "buffer";
              group_index = 2;
            }
          ];
          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" =
              "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
        };
      };
      noice = {
        # WARNING: This is considered experimental feature, but provides nice UX
        enable = true;
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
        };
      };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>fb" = {
            desc = "file finder";
            action = "find_files";
          };
        };
        extensions = {
          fzf-native = {
            enable = true;
            caseMode = "ignore_case";
          };
          ui-select.enable = true;
          frecency.enable = true;
          undo = {
            enable = true;
          };
        };
      };

      # Dev
      lsp = {
        enable = true;
        servers = {
          hls.enable = true;
          marksman.enable = true;
          nil_ls.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };

      neo-tree = {
        enable = true;
        autoCleanAfterSessionRestore = true;
        closeIfLastWindow = true;
      };
    };
  };
}
