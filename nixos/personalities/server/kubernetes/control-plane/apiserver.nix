{ config }:
let
  #TODO: Make this more modular for more clusters
  controlPlaneEndpoint = "https://cluster-0.scr1.rabbito.tech:6443";
in
{

  sops.secrets = {
    etcd-client-ca = {
      sopsFile = ../secrets.sops.yaml;
    };
    etcd-client-cert = {
      sopsFile = ../secrets.sops.yaml;
    };
    etcd-cert-key = {
      sopsFile = ../secrets.sops.yaml;
    };
    kubelet-client-cert = {
      sopsFile = ../secrets.sops.yaml;
    };
    kubelet-client-key = {
      sopsFile = ../secrets.sops.yaml;
    };
    proxy-client-cert = {
      sopsFile = ../secrets.sops.yaml;
    };
    proxy-client-key = {
      sopsFile = ../secrets.sops.yaml;
    };
    service-account-key = {
      sopsFile = ../secrets.sops.yaml;
    };
    service-account-signing-key = {
      sopsFile = ../secrets.sops.yaml;
    };
    apiserver-tls-cert = {
      sopsFile = ../secrets.sops.yaml;
    };
    apiserver-tls-key = {
      sopsFile = ../secrets.sops.yaml;
    };
    oidc-client-id = {
      sopsFile = ../secrets.sops.yaml;
    };
    kube-apiserver-environment = {
      sopsFile = ../secrets.sops.yaml;
    };
  };
  systemd.services.kube-apiserver.serviceConfig.EnvironmentFile =
    config.sops.secrets.kube-apiserver-environment.path;
  services.kubernetes.apiserver = {
    allowPrivileged = true;
    apiAudiences = controlPlaneEndpoint;
    etcd = {
      caFile = config.sops.secrets.etcd-client-ca.path;
      certFile = config.sops.secrets.etcd-cert.path;
      keyFile = config.sops.secrets.etcd-cert-key.path;
    };
    kubeletClientCertFile = config.sops.secrets.kubelet-client-cert.path;
    kubeletClientKeyFile = config.sops.secrets.kubelet-client-key.path;
    preferredAddressTypes = "InternalIP,ExternalIP,Hostname";
    proxyClientCertFile = config.sops.secrets.proxy-client-cert.path;
    proxyClientKeyFile = config.sops.secrets.proxy-client-key.path;
    serviceAccountIssuer = controlPlaneEndpoint;
    serviceAccountKeyFile = config.sops.secrets.service-account-key.path;
    serviceAccountSigningKeyFile = config.sops.secrets.service-account-signing-key.path;
    serviceClusterIpRange = "10.96.0.0/12,2001:559:1104:fdb::/112";
    tlsCertFile = config.sops.secrets.apiserver-tls-cert.path;
    tls-private-key-file = config.sops.secrets.apiserver-tls-key.path;
    extraOpts = ''
      --enable-bootstrap-token-auth=true
      --oidc-username-claim=email
      --oidc-username-prefix=oidc:
      --oidc-groups-prefix=oidc:
      --oidc-issuer-url=https://kutara-dev.us.auth0.com/
      --oidc-groups-claim=https://kutara/groups
      --oidc-client-id=''${KUTARA_OIDC_CLIENT_ID}
      '';
  };
}