{ stdenv, fetchgit, git, which, gnome3, pkgconfig, pulseaudio, libtool, libwnck3, glib, vala, gobjectIntrospection, upower, gsettings_desktop_schemas, clutter, makeWrapper, librsvg }:

stdenv.mkDerivation rec {
  name = "budgie-desktop";
  src = fetchgit {
    url = git://github.com/ollieh/budgie-desktop.git;
    rev = "57ad6d5ca1fdff7b5cfbac4177d644a9f3464b32";
    sha256 = "9a1ed38664faa3af2adc53db3210808d7c4963d12bce7c2236aaa1a890e25160";
    fetchSubmodules = true;
  };
  preConfigure = ''
    bash autogen.sh --prefix=$out
  '';
  preFixup = ''
    for f in $out/bin/*; do
      wrapProgram $f \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
    done
  '';
  patches = [ ./pedantic.patch ];
  buildInputs = [git which gnome3.gnome_common pkgconfig gnome3.gtk3 gnome3.libgee gnome3.libpeas pulseaudio gnome3.gnome-menus gnome3.mutter libtool libwnck3 upower glib vala gobjectIntrospection gsettings_desktop_schemas clutter gnome3.vino makeWrapper];
  meta = {
    description = "The Budgie desktop environment";
    homepage = https://evolve-os.com/budgie;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.vozz ];
  };
}
