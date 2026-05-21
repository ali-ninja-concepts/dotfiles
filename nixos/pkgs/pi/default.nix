{ lib, buildNpmPackage, fetchurl, nodejs_22 }:

# Pi: a minimal terminal coding harness (https://pi.dev).
#
# Distributed only as the npm package @earendil-works/pi-coding-agent, so it is
# packaged with buildNpmPackage from the published tarball. The tarball already
# ships a built dist/ and an npm-shrinkwrap.json, but upstream's shrinkwrap omits
# the integrity hashes for its three @earendil-works/* sibling packages. The
# vendored npm-shrinkwrap.json here is that lockfile with those three integrity
# fields filled in from the registry; it is copied over the source copy in
# postPatch so both fetchNpmDeps and `npm ci` accept it.
#
# Requires Node >= 22.19.0, hence nodejs_22 rather than the system default.

buildNpmPackage rec {
  pname = "pi-coding-agent";
  version = "0.75.4";

  src = fetchurl {
    url = "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-${version}.tgz";
    hash = "sha512-Fb+FRo08b5H9pYKbQJ708/5OKL0+K/yclhfCMEhrBzSPTZZ4c85nY1YsBo4qwL20ohBMlBezHMRuHzcJ1ylEoQ==";
  };

  # npm tarballs unpack to package/
  sourceRoot = "package";

  # The default fetchNpmDeps inherits this postPatch, so the fixed lockfile is
  # used both when prefetching deps and during `npm ci`.
  #
  # Upstream's shrinkwrap is production-only, but package.json still declares
  # devDependencies. `npm ci` would then try to fetch those (offline -> failure),
  # so strip them; the prebuilt dist/ means we never need them anyway. This does
  # not affect npmDepsHash, which is derived purely from the lockfile.
  postPatch = ''
    cp ${./npm-shrinkwrap.json} npm-shrinkwrap.json
    ${nodejs_22}/bin/node -e 'const fs=require("fs");const p=JSON.parse(fs.readFileSync("package.json","utf8"));delete p.devDependencies;fs.writeFileSync("package.json",JSON.stringify(p,null,2))'
  '';

  nodejs = nodejs_22;

  npmDepsHash = "sha256-mwHYCt5MkSQVVH3e10vdveUK77/DsYg/jkQpvyJ096E=";

  # The published tarball already contains the compiled dist/.
  dontNpmBuild = true;

  meta = with lib; {
    description = "Minimal terminal coding harness";
    homepage = "https://pi.dev";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "pi";
  };
}
