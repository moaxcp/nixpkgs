{
  enableXft ? true, libXft ? null, patches ? [], stdenv, lua, gettext, 
  pkgconfig, xlibsWrapper, libXinerama, libXrandr, libX11, libXext, libSM,
  xterm, xmessage, makeWrapper, fetchFromGitHub, mandoc, which
}:

assert enableXft -> libXft != null;

let
  pname = "notion";
  version = "3-2019050101";
  inherit patches;
in
stdenv.mkDerivation {
  name = "${pname}-${version}";
  meta = with stdenv.lib; {
    description = "Tiling tabbed window manager, follow-on to the ion window manager";
    homepage = http://notion.sourceforge.net;
    platforms = platforms.linux;
    license   = licenses.notion_lgpl;
    maintainers = with maintainers; [ jfb moaxcp ];
  };
  src = fetchFromGitHub {
    owner = "raboof";
    repo = pname;
    rev = version;
    sha256 = "09kvgqyw0gnj3jhz9gmwq81ak8qy32vyanx1hw79r6m181aysspz";
  };

  patches = patches;
  postPatch = ''
    substituteInPlace system-autodetect.mk --replace '#PRELOAD_MODULES=1' 'PRELOAD_MODULES=1'
    substituteInPlace man/Makefile --replace "nroff -man -Tlatin1" "${mandoc}/bin/mandoc -T man"
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [makeWrapper xlibsWrapper lua gettext mandoc which libXinerama 
  libXrandr libX11 libXext libSM] ++ stdenv.lib.optional enableXft libXft;

  buildFlags = "LUA_DIR=${lua} X11_PREFIX=/no-such-path PREFIX=\${out}";
  installFlags = "PREFIX=\${out}";

  postInstall = ''
    wrapProgram $out/bin/notion \
      --prefix PATH ":" "${xmessage}/bin:${xterm}/bin" \
  '';
}
