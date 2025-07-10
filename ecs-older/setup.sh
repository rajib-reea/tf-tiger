#!/bin/bash

# 1. Apply bootstrap
cd bootstrap
terraform init
terraform apply -auto-approve
kms_key_id=$(terraform output -raw kms_key_id)

# 2. Generate backend config
cd ../main
cat > backend.auto.tfbackend <<EOF
bucket = "infra-tfstate"
key    = "infra-tfstate/terraform.tfstate"
region = "ap-northeast-1"
profile = "infra-profile"
encrypt = true
kms_key_id = "$kms_key_id"
EOF

# 3. Init with backend config
terraform init -backend-config=backend.auto.tfbackend
