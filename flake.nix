{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs}: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
    };
    
  in {
    packages."x86_64-linux".default = pkgs.flutter.buildFlutterApplication {
      version = "0.0.1";
      name = "flutter_app";
      src = self;
      vendorHash = "sha256-JXLv+3+xega5umGoQs95+wnMrL69DdJPHnTjmjk7fz0=";
      autoDepsList = true;
    };
    devShells."x86_64-linux".default = pkgs.mkShell {
      buildInputs = [ pkgs.flutter ];
    };
  };
}
