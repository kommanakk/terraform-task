2. The EC2 instance running Nginx went down over the weekend and we had an outage, it's been decided that we need a solution
that is more resilient than just a single instance. Please implement a solution that you'd be confident would continue
to run in the event one instance goes down.


Created a vpc with an instance nginx installed.

autoscaling group is serving as resilient and fault tolerance concept.

If nginx of this instnace goes down at any point of time then cloudwatch alarm triggers and another instance will be launch with autoscaling group to serve this application requests more effectively.   
