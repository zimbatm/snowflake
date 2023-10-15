{pkgs, ...}:
{
    imports = [
    ../server/tailscale.nix
    ];
    networking.firewall = {
      enable = true;
    };
    systemd.services.tailscaled.requires = ["tailscaled-ondemand-dispatch.target"];
    systemd.targets.tailscaled-ondemand-dispatch = {
        description = "Ensure's tailscale runs only when it needs to.";
        before = ["tailscaled.service"];
        after = ["network-pre.target" "NetworkManager.service" "systemd-resolved.service"];
        wants = ["network-pre.target"];
    };
    networking.networkmanager = {
        enable = true;
        dispatcherScripts = [
          {
            source = pkgs.writeText "hook" ''
            #!/bin/sh
            interface=$1 status=$2
            case $status in
              up)
                echo -n "allow dhcp to settle"
                sleep 15
                if [[ "$IP4_DOMAINS" == *"rabbito.tech"* ]]; then
                  echo -n " IP4_DOMAINS ( $IP4_DOMAINS ) has rabbito.tech stopping tailscale"
                  systemctl stop tailscaled-ondemand-dispatch.target
                else
                  echo -n "IP4_DOMAINS ( $IP4_DOMAINS ) not rabbito.tech starting tailscale"
                  systemctl start tailscaled-ondemand-dispatch.target
                fi
                ;;
              down)
                  echo -n "connection down doing nothing"
                ;;
            esac
            '';
            type = "basic";
          }
        ];
    };

}
