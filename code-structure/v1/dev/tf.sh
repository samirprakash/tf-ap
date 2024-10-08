#!/bin/bash

apply_tf() {
    cd vpc
    echo "Applying Terraform for VPC"
    terraform init
    terraform apply -auto-approve
    cd ../subnet
    echo "Applying Terraform for Subnet"
    terraform init
    terraform apply -auto-approve
}

destroy_tf() {
    cd subnet
    echo "Destroying Terraform for Subnet"
    terraform destroy -auto-approve
    cd ../vpc
    echo "Destroying Terraform for VPC"
    terraform destroy -auto-approve
}

case $1 in
    apply)
        apply_tf
        ;;
    destroy)
        destroy_tf
        ;;
    *)
        echo "Invalid Option"
        ;;
esac