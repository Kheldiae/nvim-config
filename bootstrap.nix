{ pkgs, lib, stdenv, fetchgit, emptyDirectory, buildEnv, ... }:
let
  locks = builtins.fromJSON (builtins.readFile ./bootstrap.lock);
  repos = builtins.mapAttrs
    (k: v: fetchgit { inherit (v) url rev sha256 fetchSubmodules; })
    locks.repos;

  strToPackage = name:
    builtins.foldl' (l: r: l.${r}) pkgs (lib.splitString "." name);
  packages = builtins.map strToPackage locks.packages;
  lspPackages = builtins.map strToPackage locks.lsp-packages;

  reponame = l: builtins.head (builtins.tail (lib.splitString "/" l));

  mergedPackages = buildEnv {
    name = "merged-packages";
    paths = packages;
  };
  mergedLspPackages = buildEnv {
    name = "merged-lsp-packages";
    paths = lspPackages;
  };

  repopaths = o:
    builtins.map (r: "${o}/bundle/${reponame r}") (builtins.attrNames repos);

  runtime = o: lib.concatStringsSep "," (repopaths o);
in stdenv.mkDerivation {
  name = "vim-plug-bootstrap";
  src = emptyDirectory;
  installPhase = builtins.foldl' (l: r: ''
    ${l}
                cp -r ${repos.${r}} $out/bundle/${reponame r}
  '') ''
    mkdir -p $out/bundle
    echo "set packpath^=$out" >> $out/bootstrap.vim
    echo "set runtimepath^=${runtime (placeholder "out")}" >> $out/bootstrap.vim
  '' (builtins.attrNames repos);

  passthru = {
    packages = mergedPackages;
    lspPackages = mergedLspPackages;
  };
}
