# OIDC config
# kanidm group create grafana_superadmins
# kanidm group create grafana_admins
# kanidm group create grafana_editors
# kanidm group create grafana_users
# kanidm group add-members grafana_users grafana_superadmins grafana_admins grafana_editors

# kanidm system oauth2 create grafana Grafana https://graf.amiez.xyz
# kanidm system oauth2 add-redirect-url grafana https://graf.amiez.xyz/login/generic_oauth
# kanidm system oauth2 prefer-short-username grafana
# kanidm system oauth2 set-image grafana grafana-logo.svg

# kanidm system oauth2 update-scope-map grafana grafana_users email openid profile
# kanidm system oauth2 update-claim-map-join grafana grafana_role array
# kanidm system oauth2 update-claim-map grafana grafana_role grafana_superadmins GrafanaAdmin
# kanidm system oauth2 update-claim-map grafana grafana_role grafana_admins Admin
# kanidm system oauth2 update-claim-map grafana grafana_role grafana_editors Editor

{ self, config, pkgs, ... }: let
  publicHostname = "graf.amiez.xyz";
in {
  nxmods.impermanence.directories = [ "/var/lib/grafana" ];

  sops.secrets = let
    owner = "grafana";
    sopsFile = self.outPath + "/secrets/charm/grafana.yaml";
  in {
    "grafana/oauth2/api_url" = { inherit owner sopsFile; };
    "grafana/oauth2/auth_url" = { inherit owner sopsFile; };
    "grafana/oauth2/token_url" = { inherit owner sopsFile; };
    "grafana/oauth2/client_secret" = { inherit owner sopsFile; };
  };

  services.nginx.virtualHosts.${publicHostname} = {
    enableACME = true;
    acmeRoot = null;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = publicHostname;
        root_url = "https://" + publicHostname;
      };
      feature_toggles.externalServiceAccounts = true;
      "auth.generic_oauth" = with config.sops; {
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
    };
    declarativePlugins = [ pkgs.grafana-strava-datasource ];
  };
}
