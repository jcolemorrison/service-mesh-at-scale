#!/bin/bash -e

apt-get update -y
apt-get upgrade -y
apt-get install -y unzip jq

# Install Consul 
cd /tmp
wget https://releases.hashicorp.com/consul/1.15.3/consul_1.15.3_linux_amd64.zip -O consul.zip
unzip ./consul.zip
mv ./consul /usr/bin/consul

mkdir -p /etc/consul/config
mkdir -p /etc/consul/data

echo ${consul_ca} | base64 -d > /etc/consul/ca.pem

cat <<EOF > /etc/consul/config/${service}.hcl
service {
  name = "${service}"
  id = "${service}-1"
  port = 9090

  connect { 
    sidecar_service {
      proxy {
      }
    }
  }
}
EOF

cat <<EOF > /etc/consul/consul_start.sh
#!/bin/bash -e

# Get JWT token from the metadata service and write it to a file
curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F' -H Metadata:true -s | jq -r .access_token > ./meta.token

# Use the token to log into the Consul server, we need a valid ACL token to join the cluster and setup autoencrypt
CONSUL_HTTP_ADDR=https://${consul_server_private_addr} consul login -method azure-jwt -bearer-token-file ./meta.token -token-sink-file /etc/consul/consul.token

# Generate the Consul Config which includes the token so Consul can join the cluster
cat <<EOC > /etc/consul/config/consul.json
{
  "acl":{
    "enabled":true,
    "down_policy":"async-cache",
    "default_policy":"deny",
    "tokens": {
      "default":"\$(cat /etc/consul/consul.token)"
    }
  },
  "ca_file":"/etc/consul/ca.pem",
  "verify_outgoing":true,
  "datacenter":"${datacenter}",
  "server":false,
  "log_level": "INFO",
  "encrypt": "${gossip_encryption_key}",
  "encrypt_verify_incoming": true,
  "encrypt_verify_outgoing": true,
  "retry_join":[
    "${consul_server_private_addr}"
  ],
  "ports": {
    "grpc": 8502
  },
  "auto_encrypt":{
    "tls":true
  }
}
EOC

# Run Consul
/usr/bin/consul agent -node=${service} -config-dir=/etc/consul/config/ -data-dir=/etc/consul/data
EOF

chmod +x /etc/consul/consul_start.sh

# Setup Consul agent in SystemD
cat <<EOF > /etc/systemd/system/consul.service
[Unit]
Description=Consul Agent
After=network-online.target

[Service]
WorkingDirectory=/etc/consul
ExecStart=/etc/consul/consul_start.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Install Envoy
wget https://github.com/nicholasjackson/envoy-binaries/releases/download/v1.25.5/envoy_1.25.5_linux_amd64.zip -O envoy.zip
unzip envoy.zip
mv ./envoy /usr/bin/envoy
chmod +x /usr/bin/envoy

# Setup Envoy Service in SystemD
cat <<EOF > /etc/systemd/system/envoy.service
[Unit]
Description=Envoy
After=network-online.target
Wants=consul.service

[Service]
ExecStart=/usr/bin/consul connect envoy -sidecar-for ${service}-1 -envoy-binary /usr/bin/envoy -- -l debug
Environment="CONSUL_HTTP_TOKEN_FILE=/etc/consul/consul.token"
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Install Fake Service
wget https://github.com/nicholasjackson/fake-service/releases/download/v0.25.1/fake_service_linux_amd64.zip -O fake-service.zip
unzip fake-service.zip
mv ./fake-service /usr/bin/fake-service
chmod +x /usr/bin/fake-service

# Setup Fake Service in SystemD
cat <<EOF > /etc/systemd/system/fake-service.service
[Unit]
Description=${service} Service
After=network-online.target

[Service]
ExecStart=/usr/bin/fake-service
Environment="LISTEN_ADDR=127.0.0.1:9090"
Environment="NAME=${service}-Azure"
Environment="MESSAGE=Hello from API"
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Restart SystemD
systemctl daemon-reload

systemctl enable consul
systemctl enable envoy
systemctl enable fake-service

systemctl restart consul
systemctl restart envoy
systemctl restart fake-service