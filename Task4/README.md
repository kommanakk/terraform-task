4. The team have decided to use the Java framework Spring Boot to build features for our website. Deploy the following sample
  application into the VPC, reconfigure Nginx as a reverse proxy to the Java app. Provide a modification to the Terraform
  output/curl command to get the hello world text that the application serves.

https://github.com/spring-projects/spring-boot/tree/master/spring-boot-samples/spring-boot-sample-tomcat

Work Notes  

Corresponding spring boot sample tomcat got few issues within hsbc proxy.

https://tomcat.apache.org/tomcat-9.0-doc/appdev/sample/

I took above sample java application to deploy it on to vpc.

Created subnet , internet gateway, security group, elb and Ec2 instance to support this functionality.

Used user_data to configure nginx, java and tomcat8

Nginx is used as reverse proxy to forward the request to application which java based war file resides in tomcat8 webapps directory.

Output: terraform apply will output the ELB dns name of instance.


Run this example using:

    terraform apply -var 'key_name=YOUR_KEY_NAME'

we have to few minutes to install and configure all above and then get a ELB DNS name as output.

curl <elb_dns_name>
