{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, gettext
, pkg-config
, wrapGAppsHook
, sqlite
, libpinyin
, db
, ibus
, glib
, gtk3
, python3
, lua
, opencc
, libsoup
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "ibus-libpinyin";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "ibus-libpinyin";
    rev = version;
    sha256 = "sha256-/l+0CfesJp2ITd2EL1Bbz+XGNmw9sDd3A+v57kDBvO8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkg-config
    wrapGAppsHook
  ];

  configureFlags = [
    "--enable-cloud-input-mode"
    "--enable-opencc"
  ];

  buildInputs = [
    ibus
    glib
    sqlite
    libpinyin
    (python3.withPackages (pypkgs: with pypkgs; [
      pygobject3
      (toPythonModule ibus)
    ]))
    gtk3
    db
    lua
    opencc
    libsoup
    json-glib
  ];

  meta = with lib; {
    isIbusEngine = true;
    description = "IBus interface to the libpinyin input method";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.linux;
  };
}
