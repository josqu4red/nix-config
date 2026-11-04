{
  self,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.nxmods.msmtp;
in
{
  options.nxmods.msmtp = {
    enable = mkEnableOption "msmtp relaying through Infomaniak";
    users = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "Users allowed to read the msmtp config (and send mail)";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = lib.genAttrs [ "smtp/user" "smtp/password" ] (_: {
      sopsFile = self.outPath + "/secrets/shared/infomaniak-smtp.yaml";
    });

    sops.templates.msmtprc = {
      group = "msmtp";
      mode = "0440";
      content = ''
        defaults
        auth on
        tls on
        syslog LOG_MAIL

        account default
        host mail.infomaniak.com
        port 465
        tls_starttls off
        from noreply@amiez.xyz
        user ${config.sops.placeholder."smtp/user"}
        password ${config.sops.placeholder."smtp/password"}
      '';
    };

    users.groups.msmtp.members = cfg.users;

    programs.msmtp.enable = true;
    environment.etc.msmtprc.source = lib.mkForce config.sops.templates.msmtprc.path;
  };
}
