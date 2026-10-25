{
  self,
  config,
  pkgs,
  ...
}:
let
  publicHostname = "graf.amiez.xyz";
in
{
  services.kanidm.provision = {
    groups = {
      grafana_superadmins.overwriteMembers = false;
      grafana_admins.overwriteMembers = false;
      grafana_editors.overwriteMembers = false;
      grafana_users.members = [
        "grafana_superadmins"
        "grafana_admins"
        "grafana_editors"
      ];
    };
    systems.oauth2.grafana = {
      displayName = "Grafana";
      imageFile = ./grafana-logo.svg;
      originLanding = "https://${publicHostname}";
      originUrl = "https://${publicHostname}/login/generic_oauth";
      preferShortUsername = true;
      scopeMaps.grafana_users = [
        "email"
        "openid"
        "profile"
      ];
      claimMaps.grafana_role = {
        joinType = "array";
        valuesByGroup = {
          grafana_superadmins = [ "GrafanaAdmin" ];
          grafana_admins = [ "Admin" ];
          grafana_editors = [ "Editor" ];
        };
      };
    };
  };

  nxmods.impermanence.directories = [ "/var/lib/grafana" ];

  sops.secrets =
    let
      owner = "grafana";
      sopsFile = self.outPath + "/secrets/gluon/grafana.yaml";
    in
    {
      "grafana/secret_key" = { inherit owner sopsFile; };
      "grafana/oauth2/api_url" = { inherit owner sopsFile; };
      "grafana/oauth2/auth_url" = { inherit owner sopsFile; };
      "grafana/oauth2/token_url" = { inherit owner sopsFile; };
      "grafana/oauth2/client_secret" = { inherit owner sopsFile; };
    };

  services.nginx.virtualHosts.${publicHostname} = self.lib.proxyVhost {
    upstream = "http://127.0.0.1:3000";
  };

  services.grafana = {
    enable = true;
    settings = with config.sops; {
      server = {
        domain = publicHostname;
        root_url = "https://" + publicHostname;
      };
      feature_toggles.externalServiceAccounts = true;
      "auth.generic_oauth" = {
        enabled = true;
        name = "id.amiez.xyz";
        client_id = "grafana";
        api_url = "$__file{${secrets."grafana/oauth2/api_url".path}}";
        auth_url = "$__file{${secrets."grafana/oauth2/auth_url".path}}";
        token_url = "$__file{${secrets."grafana/oauth2/token_url".path}}";
        client_secret = "$__file{${secrets."grafana/oauth2/client_secret".path}}";
        scopes = "openid,profile,email";
        use_pkce = true;
        use_refresh_token = true;
        allow_assign_grafana_admin = true;
        allow_sign_up = true;
        login_attribute_path = "preferred_username";
        role_attribute_path = "contains(grafana_role[*], 'GrafanaAdmin') && 'GrafanaAdmin' || contains(grafana_role[*], 'Admin') && 'Admin' || contains(grafana_role[*], 'Editor') && 'Editor' || 'Viewer'";
      };
      security.secret_key = "$__file{${secrets."grafana/secret_key".path}}";
    };
    declarativePlugins = [ pkgs.grafana-strava-datasource ];
  };
}
