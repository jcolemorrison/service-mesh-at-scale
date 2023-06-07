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
/usr/bin/consul agent -node=gateway -config-dir=/etc/consul/config/ -data-dir=/etc/consul/data
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
cat <<EOF > /etc/systemd/system/gateway.service
[Unit]
Description=Mesh Gateway
After=network-online.target
Wants=consul.service

[Service]
ExecStart=/usr/bin/consul connect envoy -gateway mesh -wan-address=${vm_public_ip} -register -envoy-binary /usr/bin/envoy -- -l debug
Environment="CONSUL_HTTP_TOKEN_FILE=/etc/consul/consul.token"
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Restart SystemD
systemctl daemon-reload

systemctl enable consul
systemctl enable gateway

systemctl restart consul
systemctl restart gateway