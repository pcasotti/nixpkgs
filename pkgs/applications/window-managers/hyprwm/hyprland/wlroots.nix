{ fetchFromGitLab
, hyprland
, wlroots
, lib
, libdisplay-info
, libliftoff
, hwdata
, enableNvidiaPatches ? false
}:
let
  libdisplay-info-new = libdisplay-info.overrideAttrs (old: {
    version = "0.1.1+date=2023-03-02";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "emersion";
      repo = old.pname;
      rev = "147d6611a64a6ab04611b923e30efacaca6fc678";
      sha256 = "sha256-/q79o13Zvu7x02SBGu0W5yQznQ+p7ltZ9L6cMW5t/o4=";
    };
  });

  libliftoff-new = libliftoff.overrideAttrs (old: {
    version = "0.5.0-dev";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "emersion";
      repo = old.pname;
      rev = "d98ae243280074b0ba44bff92215ae8d785658c0";
      sha256 = "sha256-DjwlS8rXE7srs7A8+tHqXyUsFGtucYSeq6X0T/pVOc8=";
    };

    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=sign-conversion"
    ];
  });
in
wlroots.overrideAttrs
  (old: {
    version = "0.17.0-dev";

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "e8d545a9770a2473db32e0a0bfa757b05d2af4f3";
      hash = "sha256-gv5kjss6REeQG0BmvK2gTx7jHLRdCnP25po6It6I6N8=";
    };

    pname =
      old.pname
      + "-hyprland"
      + lib.optionalString enableNvidiaPatches "-nvidia";

    patches =
      (old.patches or [ ])
      ++ (lib.optionals enableNvidiaPatches [
        "${hyprland.src}/nix/patches/wlroots-nvidia.patch"
      ]);

    postPatch =
      (old.postPatch or "")
      + (
        lib.optionalString enableNvidiaPatches
          ''substituteInPlace render/gles2/renderer.c --replace "glFlush();" "glFinish();"''
      );

    buildInputs = old.buildInputs ++ [
      hwdata
      libdisplay-info-new
      libliftoff-new
    ];
  })
