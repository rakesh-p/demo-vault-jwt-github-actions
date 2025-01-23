# demo-vault-jwt-github-actions

## Intro

The repo assumes access to a running hashicorp vault instance with sufficient privileges to enable JWT auth method and to add policy.
Also familiarity with [Opentofu](https://opentofu.org/) is assumed. 

The repo contains resources to 
 - mount kv2 secret engine in hashicorp vault at the path engines/demo
 - write key-value pairs as secrets in the above mounted path
 - enable JWT auth method in vault at the user defined path e.g. jwt_demo
 - set variables in this github repo for the github actions workflow to use
 - read secrets from vault (written above) using github actions workflow

The github actions workflow will run on self hosted runner which is a RHEL VM. 
The runner VM can reach the vault instance as they are in the same internal network. 
The vault instance is setup using the opensource version.
A github personal access token is created with the scopes : repo, admin:repo_hook, workflow. This token is then used to set the variables in the github repo for the actions.

Thanks to my colleagues as this repo was inspired by their work. 

## Usage

Update the TFVARS file [values.tfvars_example](./opentofu/values.tfvars_example) as appropriate. Change the extension to .tfvars

```
cd opentofu/
tofu init
tofu plan -var-file="example_values.tfvars" 
tofu apply -var-file="example_values.tfvars" 
```
The above commands would have:
 - written secrets in vault
 - enabled JWT auth
 - set variables in github actions (under https://github.com/rakesh-p/demo-vault-jwt-github-actions/settings/secrets/actions)

### Self hosted runner: systemctl service
If the self-hosted runner is RHEL based, SELinux may be blocking the communication (protection) to the runner and runner service may fail to start. 
This can be resolved by running the following set of commands on the runner VM.

```
cd actions-runner/
sudo ./svc.sh install

sudo chcon system_u:object_r:usr_t:s0 ./svc.sh
sudo chcon system_u:object_r:usr_t:s0 ./runsvc.sh 

sudo ./svc.sh start
sudo ./svc.sh status
```

## References

- https://github.com/ned1313/vault-oidc-github-actions/tree/main 
- https://www.youtube.com/watch?v=lsWOx9bzAwY 
- https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners
- 