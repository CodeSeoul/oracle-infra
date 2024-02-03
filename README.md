# oracle-infra
Repository for tracking our Oracle Cloud infrastructure resources as code

Do note that we only use infrastructure available in [Oracle's Always Free Resources](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm) until we have sufficient funding.

Many thanks to [Robin Lieb's repository](https://github.com/robinlieb/terraform-oci-free-tier-kubernetes) and the [Oracle A1 example repository](https://github.com/badr42/oke_A1/tree/main) for helping make things faster and easier.

Note that the Chuncheon region currently lacks compute capacity. We can use the following command to check capacity, assuming `oci` and `jq` are installed.

```shell
oci compute compute-capacity-report create --compartment-id ocid1.compartment.oc1..aaaaaaaad3euiylbm5te2snpodedi32xcljemiwsdu5roteybon4ec4rksxq --availability-domain QNmd:AP-CHUNCHEON-1-AD-1 --shape-availabilities file://./shape-availabilities.json | jq '.data."shape-availabilities"[0]."availability-status"'
```

If the output is `OUT_OF_HOST_CAPACITY`, there is no physical compute capacity yet. Try another time.

## Setup
Note that you must set up a Customer Secret Key in Oracle Cloud before Terraform requests will work. We use an S3-compatible backend to store the Terraform state, and it requires you to set the secret key. You can find [instructions on how to configure your key in Oracle's documentation](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformUsingObjectStore.htm#s3). We assume that you configure a profile named `oracle-default` in your local credentials.

You will also need to configure your OCI configurations, per [Oracle's API Key Authentication docs](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth).

```shell
terraform init
```