## TEST k8s Level2
    - I decided to build the  K8s cluster localy using Vagrant, as can't get an account with my CC on GCloud.

    - Dependencies:- Vagrant and Virtualbox.
        [Link to install Vagrant] : https://www.vagrantup.com/intro/getting-started/install.html
    
    ### How To
    - Clone the repos. 
    - cd into the Repos. 
    - vagrant up 
        This will spin all the virtual machines.

    - This will take aprox 40  to 50 Minutes to complete on my local, depends on Internet connections.


## After all servers are up and running.
    connect to the k8s-master with the following commands.
    in the current dir where the Vagrant file is.
    ```vagrant ssh k8s-master
    ```
    Once conectec run the follwoing command.
    ```
    kubectl get nods
    ```
    The output must be like below.
    ```
            NAME         STATUS     ROLES    AGE   VERSION
           k8s-master   Ready      master   36m   v1.15.1
            node-1       Ready      <none>   24m   v1.15.1
            node-2       NotReady   <none>   13s   v1.15.1
    ```

## Now on I have added all steps into the ansible playbook to get the config file and setup kubctl on the Jenkins server.

## I have created a basic test pipeline in jenkins to do ```kubectl get nodes```
    - OUTPUT BELOW: -

####  Notes due to lot's of mem and CPU I had to stop the two nodes for now.

     ```
Started by user admin
Running in Durability level: MAX_SURVIVABILITY
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/lib/jenkins/workspace/Accessing kubctl
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Build)
[Pipeline] sh
+ kubectl get nodes
NAME         STATUS   ROLES    AGE   VERSION
k8s-master   Ready    master   24m   v1.15.1
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Results)
[Pipeline] echo
done
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
     ```

-- Having Issue while running multiple vms, due to Memory limits on my laptop.
-- I had to unable the master to run pods.
-- Using this command below we can allow this.
-- Not to be done on production.
```
kubectl taint nodes --all node-role.kubernetes.io/master-
```

After running Vagrant up.

### When it's finishes you should have these txt files created like below.

- ├── dashboard_url.txt               # Contains the dashbord url  [ IP:PORT]
- ├── dash_secret_token.txt           # Contains  the token to login.
- ├── grafana_pass.txt                # Contains Grafana Password.
- ├── grafana_url.txt                 # Contains Grafana url [ IP:PORT ]
- ├── jenkins_pass.txt                # Contains Jenkins password.
- ├── jenkins_url.txt                 # Contains Jenkins url [ IP:PORT ]
- ├── kibana_url.txt                  # Contains Kibana url [ IP:PORT ]
- ├── prometheus_data_source.txt      # Contains data url [ IP:PORT ]
- ├── guestbook_url.txt               # Contains guestbook url [ IP:PORT ]

### Dependencies needed for jenkins Cloudbees build and publish plugin is needed.


Now you can create a jenkins pipeline point it to the git repos.

Git repos : https://github.com/peacengell/guestbook/

Change the Docker hub credentials.

Change the URL for the image in the  guestbook/all-in-one/guestbook-all-in-one.yaml

peacengell/guestbook:latest

Then commit and run the Jenkins Job, then get the url from  kubetest_Level2/guestbook_url.txt