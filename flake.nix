{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, android-nixpkgs}: let
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
      android-sdk = android-nixpkgs.sdk.x86_64-linux (sdkPkgs: with sdkPkgs; [
        build-tools-30-0-3
        build-tools-33-0-0
        platform-tools
        platforms-android-33
        emulator
        patcher-v4
        cmdline-tools-latest
      ]);
      in pkgs.mkShell {
      buildInputs = [
        pkgs.flutter

        # For android
        pkgs.jdk17
        android-sdk
        pkgs.gradle
      ];

      ANDROID_HOME = "${android-sdk}/share/android-sdk";
      ANDROID_SDK_ROOT = "${android-sdk}/share/android-sdk";
      JAVA_HOME = pkgs.jdk17.home;
      ANDROID_AVD_HOME = (toString ./.) + "/.android/avd";
      GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android-sdk}/share/android-sdk/build-tools/33.0.0/aapt2";
    };
  };
}
