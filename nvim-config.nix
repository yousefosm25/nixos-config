{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''

        let mapleader = "\<Space>"

        lua << EOF
          ${builtins.readFile /home/yousef/.config/nvim/init.lua}

          ${builtins.readFile /home/yousef/.config/nvim/lua/config/lazy.lua}

          ${builtins.readFile /home/yousef/.config/nvim/lua/config/keymaps.lua}

          ${builtins.readFile /home/yousef/.config/nvim/lua/config/autocmds.lua}


          ${builtins.readFile /home/yousef/.config/nvim/lua/config/options.lua}
        EOF

      '';
    };
  };
}
