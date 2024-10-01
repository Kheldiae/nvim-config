{
  description = "Dependency locks for my Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ ];
      };

      py3 = pkgs.python3.withPackages (ps: with ps;
        [ pynvim
          jupyter_client
        ]);
      luaEnv = pkgs.neovim-unwrapped.lua.withPackages (ps: with ps;
        [ magick
        ]);

      luaPath = pkgs.neovim-unwrapped.lua.pkgs.luaLib.genLuaPathAbsStr luaEnv;
      luaCPath = pkgs.neovim-unwrapped.lua.pkgs.luaLib.genLuaCPathAbsStr luaEnv;

      wrappedNeovim = pkgs.wrapNeovimUnstable
        pkgs.neovim-unwrapped
        { neovimRcContent = ''
            set runtimepath^=${./.}
            source ${pkgs.vimPlugins.vim-plug}/plug.vim
            let g:inMyFlake = 1
            runtime! init.vim
          '';
          packpathDirs.myNeovimPackages = { start = []; opt = []; };
          vimAlias = true;
          python3Env = py3;
          wrapperArgs = [
            "--prefix" "LUA_PATH" ";" luaPath
            "--prefix" "LUA_CPATH" ";" luaCPath
          ];
        };

      bootstrap = pkgs.callPackage ./bootstrap.nix {};
      wrappedNeovimOffline = wrappedNeovim.override (
        prev: {
          wrapperArgs = prev.wrapperArgs ++ [
            "--prefix" "PATH" ":" "${bootstrap.packages}/bin"
          ];
          neovimRcContent = ''
            source ${bootstrap}/bootstrap.vim
            ${prev.neovimRcContent}
          '';
        });

      addGoyo = neovim: pkgs.symlinkJoin {
        inherit (neovim) name meta;
        paths = [ neovim ];
        postBuild = ''
          sed 's/" "$@"/;vim.g.startGoyo=1" "$@"/' ${neovim}/bin/nvim > $out/bin//goyo
          chmod +x $out/bin/goyo
        '';
      };
    in {
      legacyPackages = pkgs;
      packages.default = self.packages.${system}.neovim;
      packages."neovim" = addGoyo wrappedNeovim;
      packages."neovim-offline" = addGoyo wrappedNeovimOffline;
      packages."neovim-full" = addGoyo (
        wrappedNeovim.override (
          prev: {
            wrapperArgs = prev.wrapperArgs ++ [
              "--suffix" "PATH" ":" "${bootstrap.lspPackages}/bin"
              "--suffix" "PATH" ":" "${bootstrap.packages}/bin"
            ];
          }));
      packages."neovim-full-offline" = addGoyo (
        wrappedNeovimOffline.override (
          prev: {
            wrapperArgs = prev.wrapperArgs ++ [
              "--suffix" "PATH" ":" "${bootstrap.lspPackages}/bin"
            ];
          }));

      apps.nvim = {
        type = "app";
        program = "${self.packages.${system}.neovim}/bin/nvim";
      };
      apps.goyo = {
        type = "app";
        program = "${self.packages.${system}.neovim}/bin/goyo";
      };
    });
}
