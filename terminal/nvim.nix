{ lazyvim, pkgs, ... }:
{
  programs.lazyvim = {
    enable = true;

    extras = {
      util.dot.enable = true; # bash + hyprland.conf + waybar/kitty/rofi/mako filetypes
      lang.tailwind.enable = true;
      lang.typescript.vtsls.enable = true; # traditional/stable TS backend — LazyVim
      lang.nix.enable = true;
      lang.python = {
        enable = true;
        installDependencies = true; # Install ruff
        installRuntimeDependencies = true; # Install python3
      };
      lang.rust = {
        enable = true;
        installDependencies = true; # rust-analyzer, codelldb, bacon
        installRuntimeDependencies = true; # cargo, rustc
      };
      lang.clangd = {
        enable = true;
        installDependencies = true; # clangd, codelldb
      };
      lang.go = {
        enable = true;
        installDependencies = true; # Install gopls, gofumpt, etc.
        installRuntimeDependencies = true; # Install go compiler
      };
    };

    # Additional packages (optional)
    extraPackages = with pkgs; [
      nixd # Nix LSP
      alejandra # Nix formatter
      bash-language-server
    ];
    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      wgsl
      templ
      angular
      clojure
      cmake
      cpp
      css
      dockerfile
      gitattributes
      gitcommit
      git_config
      gitignore
      git_rebase
      go
      gomod
      gosum
      gowork
      ninja
      ron
      rst
      ruby
      rust
      scss
      sql
      typst
      vue
      hyprlang
    ];
    config.keymaps = ''
      -- t: toggle a terminal in a bottom split (normal mode)
      local term_buf

      local function toggle_terminal()
        -- visible in this tab? hide it (the shell keeps running in the background)
        local win = term_buf and vim.fn.bufwinid(term_buf) or -1
        if win ~= -1 then
          vim.api.nvim_win_hide(win)
          return
        end

        vim.cmd("botright 15split") -- bottom split, 15 lines tall

        if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
          vim.api.nvim_win_set_buf(0, term_buf) -- bring the same shell back
        else
          vim.cmd("terminal")
          term_buf = vim.api.nvim_get_current_buf()
          vim.bo[term_buf].buflisted = false -- keep it out of bufferline / buffer cycling

          -- Esc leaves terminal mode (this terminal only)
          vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = term_buf, nowait = true })

          -- shell exited: wipe the buffer so the next `t` starts a fresh one
          vim.api.nvim_create_autocmd("TermClose", {
            buffer = term_buf,
            callback = function(ev)
              vim.schedule(function()
                if vim.api.nvim_buf_is_valid(ev.buf) then
                  vim.api.nvim_buf_delete(ev.buf, { force = true })
                end
              end)
            end,
          })
        end

        vim.cmd("startinsert")
      end

      vim.keymap.set("n", "t", toggle_terminal, { desc = "Toggle bottom terminal" })
    '';
  };
}
