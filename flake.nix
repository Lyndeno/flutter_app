{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs}: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      config.android_sdk.accept_license = true;
    };
    
  in {
    packages."x86_64-linux".default = pkgs.flutter.buildFlutterApplication {
      version = "0.0.1";
      name = "flutter_app";
      src = self;
      vendorHash = "sha256-JXLv+3+xega5umGoQs95+wnMrL69DdJPHnTjmjk7fz0=";
      autoDepsList = true;
    };
    devShells."x86_64-linux".default = let
      android = pkgs.callPackage ./android.nix {};
      in pkgs.mkShell {
      buildInputs = [
        pkgs.flutter

        # For android
        pkgs.jdk17
        android.platform-tools
      ];

      ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
      JAVA_HOME = pkgs.jdk17;
      ANDROID_AVD_HOME = (toString ./.) + "/.android/avd";
    };
  };
}
