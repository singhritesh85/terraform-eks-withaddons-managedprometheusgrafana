Using this terraform script it is possible to create the EKS Cluster with Amazon Managed Prometheus, Amazon Managed Grafana and Add ons namely VPC-CNI, EBS-CSI driver, coredns, kube-proxy, Gurad-Duty for Dev, Stage and Prod Environment


# Install kubectl 
```
curl -LO https://dl.k8s.io/release/v1.23.2/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin
```

# To generate the .kube/config file run the below command
```
aws eks update-kubeconfig --name eks-demo-cluster-dev --region us-east-2    
```

# create a file mederma.yaml with below content
```
serviceAccounts:
    server:
        name: "prometheus"           ### Provide the service account name as prometheus here in all the three environments.
        annotations:
            eks.amazonaws.com/role-arn: "arn:aws:iam::02733XXXXXXXX:role/eks-amp-serviceaccount-role-dev"   ###  provide the ARN of the IAM Role for different environments.
server:
    remoteWrite:
        - url: https://aps-workspaces.us-east-2.amazonaws.com/workspaces/ws-1bXX77XX-acb2-XXXX-8XX8-XXXXd6ecXXXX/api/v1/remote_write
          sigv4:
            region: us-east-2
          queue_config:
            max_samples_per_send: 1000
            max_shards: 200
            capacity: 2500
```


# Install prometheus to collect and send that to managed prometheus
```
kubectl create namespace prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus -f mederma.yaml -n prometheus
kubectl get pods -n prometheus --watch
```


# Install and configure EKS Container Insight 
```
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluentd-quickstart.yaml | sed "s/{{cluster_name}}/cluster-name/;s/{{region_name}}/cluster-region/" | kubectl apply -f -
```

In this command, cluster-name is the name of your Amazon EKS or Kubernetes cluster, and cluster-region is the name of the Region where the logs are published. We recommend that you use the same Region where your cluster is deployed to reduce the AWS outbound data transfer costs.

```
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluentd-quickstart.yaml | sed "s/{{cluster_name}}/eks-demo-cluster-dev/;s/{{region_name}}/us-east-2/" | kubectl apply -f -
```

Then go to EC2 Instance create as a part of NodeGroup of this EKS Cluster and open its IAM Role and attach the policy CloudWatchLogsFullAccess . Finally go to Cloudwatch Console, Open Insights > Container Insights. 



Reference:- https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-EKS-quickstart.html


# Managing kubeconfig file
```
For best practice you can keep the kubeconfig file at separate paths and create directories as mentioned below:-

 mkdir dev
 mkdir stage
 mkdir prod

Move kubeconfig file to different directories which was created earlier:-

After creation of kubernetes cluster in dev enviroment move kubeconfig file into the newly created path
mv ~/.kube dev/


After creation of kubernetes cluster in stage enviroment move kubeconfig file into the newly created path
mv ~/.kube stage/


After creation of kubernetes cluster in prod enviroment move kubeconfig file into the newly created path
mv ~/.kube prod/

Now you can access the kubernetes cluster using the kubeconfig file as mentioned below:-

kubectl get nodes --kubeconfig=dev/.kube/config

kubectl get nodes --kubeconfig=stage/.kube/config

kubectl get nodes --kubeconfig=prod/.kube/config
```

If you are managing the same kubeconfig file for all the the three environments which is dev, stage and prod then use context and follow the below steps:-

# To list the context and switch context
```
kubectl config get-contexts
kubectl config use-context <CONTEXT_NAME>
```

