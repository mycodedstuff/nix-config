{ flake, pkgs, ... }:
let
  #TODO: split extraPlugins
  guihua = pkgs.stdenv.mkDerivation {
    name = "test";
    buildInputs = with pkgs; [ gnumake ];
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "guihua.lua";
      rev = "9fb6795474918b492d9ab01b1ebaf85e8bf6fe0b";
      sha256 = "sha256-0fpcYEdWfpy8MatH8cjalGOQ7/tau6ciiuSV1t09BlY=";
    };
    dontInstall = true;
    buildCommand = ''
      mkdir -p $out 
      cp -r $src/* .
      chmod -R +w . 
      make -C lua/fzy
      cp -r . $out;
    '';
  };
  sad-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "sad";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "sad.nvim";
      rev = "869c7f3ca3dcd28fd78023db6a7e1bf8af0f4714";
      sha256 = "sha256-uwXldYA7JdZHqoB4qfCnZcQW9YBjlRWmiz8mKb9jHuI=";
    };
  };
  vim-visual-multi = pkgs.vimUtils.buildVimPlugin {
    name = "vim-visual-multi";
    src = pkgs.fetchFromGitHub {
      owner = "mg979";
      repo = "vim-visual-multi";
      rev = "fe1ec7e430013b83c8c2dee85ae496251b71e253";
      sha256 = "sha256-lN492j4LgBbqNUMLOqkU2aRG2JhOpLrAEeLWFzDOcVc=";
    };
  };
  vim-resize-mode = pkgs.vimUtils.buildVimPlugin {
    name = "vim-resize-mode";
    src = pkgs.fetchFromGitHub {
      owner = "sedm0784";
      repo = "vim-resize-mode";
      rev = "0f3997d1a57c43113979df1f5fda1925f55a219b";
      sha256 = "sha256-l3g4pRsNTeVX/X26we2+yhSi4sUNUBy8PrdG/GE20UA=";
    };
  };
  zen-mode = pkgs.vimUtils.buildVimPlugin {
    name = "zen-mode-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "zen-mode.nvim";
      rev = "78557d972b4bfbb7488e17b5703d25164ae64e6a";
      sha256 = "sha256-G5/AskXEA0vl9GGUR8NG8PmL/HFcItZJWB+LyKd3R2k=";
    };
  };
in {
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

    luaLoader.enable = true;

    autoCmd = [{
      event = [ "TermOpen" ];
      pattern = [ "*" ];
      command = "startinsert";
      desc = "Enable insert mode to interact with opened terminal window";
    }];

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
      {
        key = "<leader>gg";
        action = "<cmd>terminal lazygit<cr>";
        options = {
          desc = "lazygit";
          silent = true;
          remap = false;
        };
      }
      {
        key = "<Esc>";
        mode = "t";
        action = "<C-\\><C-n><cr>";
        options = {
          desc = "switch to normal mode";
          noremap = true;
        };
      }
      {
        key = "<leader>x";
        action = "<cmd>bd!<cr>";
        options = {
          desc = "close current buffer";
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader><C-r>";
        action = "<cmd>Telescope projects<cr>";
        options = {
          desc = "open projects";
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader><Tab>";
        action = "<cmd>bn<cr>";
        options = {
          desc = "next buffer tab";
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader><S-Tab>";
        action = "<cmd>bp<cr>";
        options = {
          desc = "next buffer tab";
          silent = true;
          remap = false;
        };
      }
    ];
    plugins = {

      # UI
      lualine.enable = true;
      bufferline.enable = true;
      treesitter = {
        enable = true;
        nixGrammars = true;
      };
      treesitter-context.enable = true;
      ts-context-commentstring.enable = true;
      hmts.enable = true;
      which-key.enable = true;
      gitblame.enable = true;
      diffview.enable = true;
      notify.enable = true;
      trouble.enable = true;
      lsp-format.enable = true;
      inc-rename.enable = true;
      fidget.enable = true;
      lspkind.enable = true;
      comment-nvim.enable = true;
      wilder = { 
        enable = true;
        modes = ["/"];
      };
      vim-matchup.enable = true;
      haskell-scope-highlighting.enable = true;
      markdown-preview.enable = true;
      nix.enable = true;
      nvim-autopairs = {
        enable = true;
        mapCH = true;
      };
      todo-comments = {
        enable = true;
        highlight = { commentsOnly = true; };
      };
      project-nvim = {
        enable = true;
        enableTelescope = true;
      };

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
          "<leader><space>" = {
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
          undo.enable = true;
          file_browser.enable = true;
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

      mini = {
        enable = true;
        modules = {
          indentscope = { };
          surround = { };
          starter = {
            items = [
              { __raw = "require('mini.starter').sections.builtin_actions()"; }
              {
                name = "Projects";
                action = "Telescope projects";
                section = "Telescope";
              }
              {
                name = "Files";
                action = "Telescope find_files";
                section = "Telescope";
              }
              {
                name = "Browser";
                action = "Telescope file_browser";
                section = "Telescope";
              }
              {
                name = "Live Grep";
                action = "Telescope live_grep";
                section = "Telescope";
              }
              {
                __raw =
                  "require('mini.starter').sections.recent_files(10, false, false)";
              }
            ];
          };
          move = { };
        };
      };

    };
    extraConfigLua =
      #lua
      ''
        require("sad").setup()
        wilder.set_option('renderer', wilder.popupmenu_renderer(
          wilder.popupmenu_border_theme({
            highlights = {
              border = 'Normal',
            },
            border = 'rounded',
            pumblend = 20,
          })
        ))
        require("zen-mode").setup({
          window = {
            width = .85
          },
          plugins = {
            tmux = { enabled = true },
          },
        })
      '';

    extraPlugins = [
      vim-visual-multi
      guihua
      sad-nvim
      vim-resize-mode
      zen-mode
      # (pkgs.vimUtils.buildVimPlugin {
      #   name = "tmuxjump";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "shivamashtikar";
      #     repo = "tmuxjump.vim";
      #     rev = "17a0bda4264c9a69810193e0625e06180dba9339";
      #     sha256 = "sha256-tMwB/U74aawoXaev/ySQXtNWSi28JWxV80hoHyO8KXk=";
      #   };
      # })
    ];
  };
}
