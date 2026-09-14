{ config, pkgs, inputs, ... }:

let
    mcsrPkgs = inputs.mcsr-nixos.packages.x86_64-linux;
in 
    {
    #### Waywall
    imports = [ inputs.mcsr-nixos.nixosModules.waywall ];
    programs.waywall = {
        enable = true;
        config.source = /home/saanvi/.config/waywall/init.lua;
    };

    #### System Packages
    environment.systemPackages = [
        (pkgs.prismlauncher.override {
            jdks = [ mcsrPkgs.graalvm-21 ];
            additionalLibs = [ 
                pkgs.libXtst
                pkgs.libXext
                pkgs.libX11
                pkgs.libxkbcommon
                pkgs.libxcb
                pkgs.libxt
                pkgs.libxinerama
                pkgs.jemalloc
            ];
        })
        pkgs.openjdk21
        mcsrPkgs.ninjabrain-bot
    ];

    #### TMPFS
    systemd.services.mc-tmpfs-setup = {
        description = "Set up MCSR tmpfs world folders";
        after = [ "local-fs.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.bash ];
        serviceConfig = {
            Type = "oneshot";
            ExecStart = "/usr/bin/env bash ${../scripts/mcsr-tmpfs.sh}";
            RemainAfterExit = true;
        };
    };

    boot.tmp.useTmpfs = true;
    boot.tmp.tmpfsSize = "4G";

    systemd.tmpfiles.rules = [
        "d /tmp/mc 0755 saanvi users -"
        "d /tmp/mc/SeedQueue 0755 saanvi users -"
    ];


    #### Debounce Override
    environment.etc."libinput/local-overrides.quirks".text = ''
    [Never Debounce]
    MatchUdevType=mouse
    ModelBouncingKeys=1
    '';

}
