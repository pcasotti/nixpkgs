{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, python3
, which
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "erg";
  version = "0.6.19";

  src = fetchFromGitHub {
    owner = "erg-lang";
    repo = "erg";
    rev = "v${version}";
    hash = "sha256-oA0AXTMEdfItvIZi1ITQ3ZR6JPSg9/1V6oeK2wcRERw=";
  };

  cargoHash = "sha256-dLMU48/umKHPV6iahazxOYA/eDvFWhzV9xveT2xQ+EE=";

  nativeBuildInputs = [
    makeWrapper
    python3
    which
  ];

  buildFeatures = [ "full" ];

  env = {
    BUILD_DATE = "1970/01/01 00:00:00";
    CASE_SENSITIVE = lib.boolToString (!stdenv.isDarwin);
    GIT_HASH_SHORT = src.rev;
  };

  # TODO(figsoda): fix tests
  doCheck = false;

  # the build script is impure and also assumes we are in a git repository
  postPatch = ''
    rm crates/erg_common/build.rs
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
    export CARGO_ERG_PATH=$HOME/.erg
  '';

  postInstall = ''
    mkdir -p $out/share
    mv "$CARGO_ERG_PATH" $out/share/erg

    wrapProgram $out/bin/erg \
      --set-default ERG_PATH $out/share/erg
  '';

  meta = with lib; {
    description = "A statically typed language that can deeply improve the Python ecosystem";
    homepage = "https://github.com/erg-lang/erg";
    changelog = "https://github.com/erg-lang/erg/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
