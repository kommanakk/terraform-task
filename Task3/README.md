3. We are looking to improve the security of our network and have decided we need a bastion server to avoid logging on
directly to our servers. Add a bastion server, the bastion should be the only route to SSH onto any server in the
entire VPC.


To implement this requirement, I created VPC with public and private subnets to serve this requirement.

Requests are come to NAT instance with public subnet and internet gateway with security group rules

there is one more instance with public subnet as we can assume as webserver.

One instance which is configured with private subnet and it wont reach out to public.

To reach this instance you have only one way, which is ssh from instances within vpc through private ip.
