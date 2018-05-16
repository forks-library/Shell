#!/bin/bash

#Author: PersiLiao
#Description: SSH key generation script automatically
#Version: 1.0
#ssh-keygen -t rsa
#ssh-copy-id -i ~/.ssh/id_rsa.pub PersiLiao@sixsir.com
#yum install -y openssh-server openssh-clients

cd ~
test -d .ssh || mkdir .ssh
chmod 0700 .ssh
cat > .ssh/authorized_keys <<EOF
RSA PUBLIC KEY
EOF

cat > .ssh/id_rsa << EOF
RSA PRIVATE KEY
EOF

cat > .ssh/id_rsa.pub <<EOF
RSA PUBLIC KEY
EOF

chmod 0600 .ssh/authorized_keys
chmod 0600 .ssh/id_rsa
chmod 0644 .ssh/id_rsa.pub



