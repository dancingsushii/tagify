{config, pkgs, lib, fetchFromGithub, ...}:

with lib;

let
  callPackage = pkgs.lib.callPackageWith (pkgs);
  tagify-backend = callPackage ./tagify-backend.nix {};
  cfg = config.services.tagify;
  home_path = "/var/tagify";
  mh-run = pkgs.writeScriptBin "mh-run" ''
    #!/bin/sh
    export DIST="${callPackage ./tagify-frontend}/dist"
    ${tagify-backend}/bin/backend "$@"
  '';
in
{
  options = {
    services.tagify = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Wether to enable tagify";
      };

      asNormalUser = mkOption {
        type = types.bool;
        default = false;
        description = "The user for the service is a normal one";
      };

      https = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Wether to enable https for the website";
        };
        email = mkOption {
          type = types.str;
          description = "Email for Let's Encrypt";
        };
      };

      base_uri = mkOption {
        type = types.str;
        description = "Base uri of your application";
      };

      config_file = mkOption {
        type = types.path;
        description = "Path of config file";
      };
    };
  };

  config = mkIf cfg.enable {

    users.extraUsers."tagify" = {
      home = home_path;
      createHome = true;
      isNormalUser = cfg.asNormalUser;
    };

    networking.firewall.allowedTCPPorts = [ 80 ] ++ lib.optional cfg.https.enable 443;

    environment.systemPackages = [ mh-run ];

    security.acme.acceptTerms = cfg.https.enable;
    security.acme.email = cfg.https.email;

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts.${cfg.base_uri} = {
        forceSSL = cfg.https.enable;
        enableACME = cfg.https.enable;
        locations."/" = {
          proxyPass = "http://127.0.0.1:5000";
          proxyWebsockets = true;
        };
    };
  };

  systemd.services.tagify = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target"  ];

      serviceConfig = {
        WorkingDirectory = "${home_path}";
        ExecStart = "${mh-run}/bin/mh-run";
        User = "tagify";
      };
  };
  };
}
