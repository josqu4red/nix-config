_: let
  core_shortcut = name: title: icon: {
    inherit name;
    sidebar_title = title;
    sidebar_icon = icon;
    js_url = "/api/hassio/app/entrypoint.js";
    url_path = "config/" + name + "/dashboard";
    embed_iframe = true;
    require_admin = true;
    config = { ingress = "core_configurator"; };
  };
in [
  (core_shortcut "automation" "Automations" "mdi:arrow-decision")
  (core_shortcut "integrations" "Integrations" "mdi:cog-outline")
]
