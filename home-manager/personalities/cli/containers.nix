{
  xdg.configFile = {
    registries = {
      target = "containers/registries.conf.d/001-home-manager.conf";
      text = ''
        # Managed with Home Manager
        unqualified-search-registries = ["docker.io"]
      '';
    };
  };
}