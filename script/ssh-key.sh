#!/bin/bash

#Author: PersiLiao(xiangchu.liao@gmail.com)
#Description: SSH key generation script automatically
#Version: 1.0
#ssh-keygen -t rsa
#yum install -y openssh-server openssh-clients

cd ~
test -d .ssh || mkdir .ssh
chmod 0700 .ssh
cat > .ssh/authorized_keys <<EOF
YOUR RSA PUBLIC KEY
EOF

cat > .ssh/id_rsa << EOF
YOUR RSA PRIVATE KEY
EOF

cat > .ssh/id_rsa.pub <<EOF
YOUR RSA PUBLIC KEY
EOF

chmod 0600 .ssh/authorized_keys
chmod 0600 .ssh/id_rsa
chmod 0644 .ssh/id_rsa.pub



