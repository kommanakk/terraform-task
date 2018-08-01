1. We would like to be able to run the same stack closer to our customers in the US. Please build the same stack in
the us-east-1 (Virginia) region. Note that Virginia has a different number of availability zones which we would like
to take advantage of. As for a CIDR block for the VPC use whatever you feel like, providing it's compliant with RFC-1918 and does not overlap with the dublin network.


I have created separate tfvars to build the same stack in regions. Structure is common for both regions dublib and virginia.


To run this code

terraform apply -var-file <region.tfvars>
