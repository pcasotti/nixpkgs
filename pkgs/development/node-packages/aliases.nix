pkgs: lib: self: super:

### Deprecated aliases - for backward compatibility
###
### !!! NOTE !!!
### Use `./remove-attr.py [attrname]` in this directory to remove your alias
### from the `nodePackages` set without regenerating the entire file.

with self;

let
  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations = alias: with lib;
    if alias.recurseForDerivations or false
    then removeAttrs alias ["recurseForDerivations"]
    else alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias: with lib;
    if isDerivation alias then
      dontDistribute alias
    else alias;

  # Make sure that we are not shadowing something from node-packages.nix.
  checkInPkgs = n: alias:
    if builtins.hasAttr n super
    then throw "Alias ${n} is still in node-packages.nix"
    else alias;

  mapAliases = aliases:
    lib.mapAttrs (n: alias:
      removeDistribute
        (removeRecurseForDerivations
          (checkInPkgs n alias)))
      aliases;
in

mapAliases {
  "@antora/cli" = pkgs.antora; # Added 2023-05-06
  "@bitwarden/cli" = pkgs.bitwarden-cli; # added 2023-07-25
  "@emacs-eask/cli" = pkgs.eask; # added 2023-08-17
  "@githubnext/github-copilot-cli" = pkgs.github-copilot-cli; # Added 2023-05-02
  "@google/clasp" = pkgs.google-clasp; # Added 2023-05-07
  "@maizzle/cli" = pkgs.maizzle; # added 2023-08-17
  "@medable/mdctl-cli" = throw "@medable/mdctl-cli was removed because it was broken"; # added 2023-08-21
  "@nestjs/cli" = pkgs.nest-cli; # Added 2023-05-06
  antennas = pkgs.antennas; # added 2023-07-30
  balanceofsatoshis = pkgs.balanceofsatoshis; # added 2023-07-31
  bibtex-tidy = pkgs.bibtex-tidy; # added 2023-07-30
  bitwarden-cli = pkgs.bitwarden-cli; # added 2023-07-25
  inherit (pkgs) btc-rpc-explorer; # added 2023-08-17
  inherit (pkgs) carbon-now-cli; # added 2023-08-17
  inherit (pkgs) carto; # added 2023-08-17
  castnow = pkgs.castnow; # added 2023-07-30
  inherit (pkgs) clean-css-cli; # added 2023-08-18
  coc-imselect = throw "coc-imselect was removed because it was broken"; # added 2023-08-21
  inherit (pkgs) configurable-http-proxy; # added 2023-08-19
  inherit (pkgs) cordova; # added 2023-08-18
  dat = throw "dat was removed because it was broken"; # added 2023-08-21
  eask = pkgs.eask; # added 2023-08-17
  inherit (pkgs.elmPackages) elm-test;
  eslint_d = pkgs.eslint_d; # Added 2023-05-26
  inherit (pkgs) firebase-tools; # added 2023-08-18
  flood = pkgs.flood; # Added 2023-07-25
  git-ssb = throw "git-ssb was removed because it was broken"; # added 2023-08-21
  inherit (pkgs) graphqurl; # added 2023-08-19
  gtop = pkgs.gtop; # added 2023-07-31
  inherit (pkgs) htmlhint; # added 2023-08-19
  hueadm = pkgs.hueadm; # added 2023-07-31
  inherit (pkgs) hyperpotamus; # added 2023-08-19
  immich = pkgs.immich-cli; # added 2023-08-19
  indium = throw "indium was removed because it was broken"; # added 2023-08-19
  ionic = throw "ionic was replaced by @ionic/cli"; # added 2023-08-19
  inherit (pkgs) javascript-typescript-langserver; # added 2023-08-19
  karma = pkgs.karma-runner; # added 2023-07-29
  manta = pkgs.node-manta; # Added 2023-05-06
  markdownlint-cli = pkgs.markdownlint-cli; # added 2023-07-29
  inherit (pkgs) markdownlint-cli2; # added 2023-08-22
  mdctl-cli = self."@medable/mdctl-cli"; # added 2023-08-21
  node-inspector = throw "node-inspector was removed because it was broken"; # added 2023-08-21
  readability-cli = pkgs.readability-cli; # Added 2023-06-12
  reveal-md = pkgs.reveal-md; # added 2023-07-31
  s3http = throw "s3http was removed because it was abandoned upstream"; # added 2023-08-18
  ssb-server = throw "ssb-server was removed because it was broken"; # added 2023-08-21
  stf = throw "stf was removed because it was broken"; # added 2023-08-21
  thelounge = pkgs.thelounge; # Added 2023-05-22
  triton = pkgs.triton; # Added 2023-05-06
  typescript = pkgs.typescript; # Added 2023-06-21
  inherit (pkgs) ungit; # added 2023-08-20
  vscode-langservers-extracted = pkgs.vscode-langservers-extracted; # Added 2023-05-27
  vue-cli = self."@vue/cli"; # added 2023-08-18
  vue-language-server = self.vls; # added 2023-08-20
  inherit (pkgs) web-ext; # added 2023-08-20
  inherit (pkgs) write-good; # added 2023-08-20
  inherit (pkgs) yo; # added 2023-08-20
  zx = pkgs.zx; # added 2023-08-01
}
