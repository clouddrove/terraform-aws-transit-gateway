<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform AWS Transit Gateway
</h1>

<p align="center" style="font-size: 1.2rem;"> 
    Terraform module which creates Transit Gateway, Resource Association, Principal Association, Resource Share, Transit Gateway VPC Attachment on AWS.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v1.1.7-green" alt="Terraform">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-APACHE-blue.svg" alt="Licence">
</a>
<a href="https://github.com/clouddrove/terraform-aws-transit-gateway/actions/workflows/terraform.yml">
  <img src="https://github.com/clouddrove/terraform-aws-transit-gateway/actions/workflows/terraform.yml/badge.svg" alt="static-checks">
</a>


</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-aws-transit-gateway'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+Transit+Gateway&url=https://github.com/clouddrove/terraform-aws-transit-gateway'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AWS+Transit+Gateway&url=https://github.com/clouddrove/terraform-aws-transit-gateway'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards strategies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure. 

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies: 

- [Terraform 1.x.x](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-aws-transit-gateway/releases).


Here are some examples of how you can use this module in your inventory structure:

### Transit Gateway For Single Account
```hcl
  module "transit-gateway" {

     source        = "clouddrove/transit-gateway/aws"
     name        = "transit-gateway"
     environment = "test"
     label_order = ["environment", "name"]
     enable      = true
     tgw_create  = true

     amazon_side_asn                 = 64512
     auto_accept_shared_attachments  = "enable"
     default_route_table_propagation = "enable"
     description                     = "This transit Gateway create for testung purpose"

     #TGW Share
     resource_share_enable                    = false
     resource_share_allow_external_principals = true
     resource_share_account_ids               = ["XXXXXXXXXXXXX"]

     # VPC Attachements
     vpc_attachement_create = false # Enable After once create the subnets
     vpc_id                 = module.vpc.vpc_id
     destination_cidr_block = [ "10.0.0.0/8", "172.16.0.0/12"]
   }
```
### Transit Gateway Diffrent AWS Account
```hcl
    module "transit-gateway" {

      source        = "clouddrove/transit-gateway/aws"
      name        = "transit-gateway"
      environment = "test"
      label_order = ["environment", "name"]

      #Transit gateway invitation accepter
      aws_ram_resource_share_accepter = true
      resource_share_arn              = "arn:aws:ram:eu-west-1:XXXXXXXXXXX:resource-share/XXXXXXXXXXXXXXXXXXXXXXXXXX"

      # VPC Attachements
      vpc_attachement_create          = false # Enable After once create the subnets
      vpc_id                          = module.vpc.vpc_id
      use_existing_transit_gateway_id = true
      transit_gateway_id              = "tgw-XXXXXXXXXXX"
      destination_cidr_block          = ["10.0.0.0/8", "172.16.0.0/12"]
    }
```






## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| amazon\_side\_asn | Private Autonomous System Number (ASN) for the Amazon side of a BGP session. The range is 64512 to 65534 for 16-bit ASNs and 4200000000 to 4294967294 for 32-bit ASNs. Default value: 64512. | `number` | `64512` | no |
| attributes | Additional attributes (e.g. `1`). | `list(any)` | `[]` | no |
| auto\_accept\_shared\_attachments | Whether resource attachment requests are automatically accepted. Valid values: disable, enable. Default value: disable. | `string` | `"disable"` | no |
| aws\_ram\_resource\_share\_accepter | Accepter the RAM. | `bool` | `false` | no |
| default\_route\_table\_association | Whether resource attachments are automatically associated with the default association route table. Valid values: disable, enable. Default value: enable. | `string` | `"enable"` | no |
| default\_route\_table\_propagation | Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: disable, enable. Default value: enable. | `string` | `"enable"` | no |
| description | Description of the EC2 Transit Gateway | `string` | `""` | no |
| destination\_cidr\_block | The destination CIDR block. | `list(any)` | `[]` | no |
| enable | Whether or not to enable the entire module or not. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| label\_order | Label order, e.g. `name`. | `list(any)` | `[]` | no |
| managedby | ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'. | `string` | `"anmol@clouddrove.com"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-transit-gateway"` | no |
| resource\_share\_account\_ids | Ids of the account where the Transit Gateway should be shared. | `list(any)` | `[]` | no |
| resource\_share\_allow\_external\_principals | Whether or not to allow external principals for the Resource Share for the Transit Gateway. | `bool` | `true` | no |
| resource\_share\_arn | ARN of RAM. | `string` | `""` | no |
| resource\_share\_enable | Whether or not to create a Resource Share for the Transit Gateway. | `bool` | `false` | no |
| subnet\_ids | Subnets to attached to the Transit Gateway. These subnets will be used internally by AWS to install the Transit Gateway. | `list(any)` | `[]` | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(any)` | `{}` | no |
| tgw\_create | Whether or not to create a Transit Gateway. | `bool` | `false` | no |
| transit\_gateway\_default\_route\_table\_association | Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways. Default value: true. | `bool` | `true` | no |
| transit\_gateway\_default\_route\_table\_propagation | Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways. Default value: true. | `bool` | `true` | no |
| transit\_gateway\_id | The ID of gateway id. | `string` | `""` | no |
| use\_existing\_transit\_gateway\_id | if use existing gateway id. | `bool` | `false` | no |
| vpc\_attachement\_create | Whether or not to create the Transit Gateway VPC attachment. | `bool` | `false` | no |
| vpc\_id | Identifier of EC2 VPC. | `string` | `""` | no |
| vpn\_ecmp\_support | Whether VPN Equal Cost Multipath Protocol support is enabled. Valid values: disable, enable. Default value: enable. | `string` | `"enable"` | no |

## Outputs

| Name | Description |
|------|-------------|
| resource\_share\_arn | The ARN  of the RAM. |
| tags | A mapping of tags to assign to the resource. |
| transit\_gateway\_id | The ID of the Transit Gateway. |




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system. 

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback 
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-aws-transit-gateway/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-aws-transit-gateway)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=
