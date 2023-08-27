{ lib, buildGoModule, fetchFromGitHub, pkg-config, gtk3, xcur2png }:

buildGoModule rec {
  pname = "nwg-look";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wUI58qYkVYgES87HQ4octciDlOJ10oJldbUkFgxRUd4=";
  };

  vendorHash = "sha256-dev+TV6FITd29EfknwHDNI0gLao7gsC95Mg+3qQs93E=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 xcur2png ];

  preInstall = ''
    mkdir -p $out/share/nwg-look/langs
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    cp stuff/main.glade $out/share/nwg-look/
    cp langs/* $out/share/nwg-look/langs/
    cp stuff/nwg-look.desktop $out/share/applications/
    cp stuff/nwg-look.svg $out/share/pixmaps/
  '';

  prePatch = ''
    for file in main.go tools.go; do
      substituteInPlace $file --replace '/usr/share' $out/share
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
  '';

  meta = with lib; {
    description =
      "GTK3 settings editor adapted to work in the wlroots environment";
    homepage = "https://github.com/nwg-piotr/nwg-look";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pcasotti ];
  };
}
