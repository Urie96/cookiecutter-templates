{ pkgs, ... }:

{
  languages.kotlin.enable = true;

  android = {
    enable = true;

    # System images + emulator are heavy; turn on if you need on-device testing.
    emulator.enable = false;
    systemImages.enable = false;
    sources.enable = false;

    # ABIs to fetch system images for (only relevant when emulator is on).
    abis = [
      "arm64-v8a"
    ];

    # Some add-ons/extras are not available in the rolling nixpkgs snapshot;
    # disable the ones that error out. Re-enable if your build needs them.
    googleAPIs.enable = false;
    googleTVAddOns.enable = false;
    extras = [ ];
    extraLicenses = [ ];
  };
}
