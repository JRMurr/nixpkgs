{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "v${version}";
    hash = "sha256-hB5mmAi2cnT0Rpfq9ljKPIUmhc5jUKGkFnMJLvOa8/4=";
  };

  cargoHash = "sha256-27n9Hazuv4EVupKQ61QizJcQSydDjfTRgpdp1Yx5rh8=";

  meta = with lib; {
    description = "Terminal-based REST client ";
    homepage = "https://github.com/LucasPickering/slumber";
    license = licenses.mit;
    maintainers = with maintainers; [ JRMurr ];
  };
}
