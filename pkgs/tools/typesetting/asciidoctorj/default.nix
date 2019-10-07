{ stdenv, fetchzip, jdk, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "asciidoctorj";
  version = "2.1.0";

  src = fetchzip {
    url = "http://dl.bintray.com/asciidoctor/maven/org/asciidoctor/${pname}/${version}/${pname}-${version}-bin.zip";
    sha256 = "19fl4y3xlkmmgf5vyyb3k9p6nyglck9l53r6x12zil01q49g0zba";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    rm bin/asciidoctorj.bat
    cp -r . $out
    wrapProgram $out/bin/asciidoctorj \
      --prefix JAVA_HOME : ${jdk}
  '';
} 
