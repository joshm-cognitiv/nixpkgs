{ cargo, fetchFromGitHub, makeWrapper, pkgconfig, rustPlatform, stdenv, gcc, Security, cmake }:

rustPlatform.buildRustPackage rec {
  pname = "evcxr";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "582ce09f216d4812f7d152f6eedf0b034fc4dbbd";
    sha256 = "12hlqgh74z8vmd7fkxh4vk3dqp8hlhzkxnbyywk6nphi562n6w5w";
  };

  cargoSha256 = "0xd8slrd19sy6z17x4x7mxqiwgyg89p7xnknp08bxkm8qxdn3c33";

  nativeBuildInputs = [ pkgconfig makeWrapper cmake ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;
  postInstall = ''
    wrapProgram $out/bin/evcxr --prefix PATH : ${stdenv.lib.makeBinPath [ cargo gcc ]}
    rm $out/bin/testing_runtime
  '';

  meta = with stdenv.lib; {
    description = "An evaluation context for Rust";
    homepage = "https://github.com/google/evcxr";
    license = licenses.asl20;
    maintainers = with maintainers; [ protoben ma27 ];
    platforms = platforms.all;
  };
}
