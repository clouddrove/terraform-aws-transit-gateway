## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| amazon\_side\_asn | Private Autonomous System Number (ASN) for the Amazon side of a BGP session. The range is 64512 to 65534 for 16-bit ASNs and 4200000000 to 4294967294 for 32-bit ASNs. Default value: 64512. | `number` | `64512` | no |
| auto\_accept\_shared\_attachments | Whether resource attachment requests are automatically accepted. Valid values: disable, enable. Default value: disable. | `string` | `"disable"` | no |
| aws\_ram\_resource\_share\_accepter | Accepter the RAM. | `bool` | `false` | no |
| default\_route\_table\_association | Whether resource attachments are automatically associated with the default association route table. Valid values: disable, enable. Default value: enable. | `string` | `"enable"` | no |
| default\_route\_table\_propagation | Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: disable, enable. Default value: enable. | `string` | `"enable"` | no |
| description | Description of the EC2 Transit Gateway | `string` | `""` | no |
| dns\_support | Should be true to enable DNS support in the TGW | `string` | `"enable"` | no |
| enable | Whether or not to enable the entire module or not. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| hub\_static\_route | This variable use in create a transit gateway static route | `bool` | `false` | no |
| label\_order | Label order, e.g. `name`. | `list(any)` | <pre>[<br>  "environment",<br>  "name"<br>]</pre> | no |
| managedby | ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'. | `string` | `"anmol@clouddrove.com"` | no |
| multicast\_support | Whether multicast support is enabled | `string` | `"enable"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-transit-gateway"` | no |
| resource\_share\_account\_ids | Ids of the account where the Transit Gateway should be shared. | `list(string)` | `[]` | no |
| resource\_share\_allow\_external\_principals | Whether or not to allow external principals for the Resource Share for the Transit Gateway. | `bool` | `false` | no |
| resource\_share\_arn | ARN of RAM. | `string` | `""` | no |
| resource\_share\_enable | Whether or not to create a Resource Share for the Transit Gateway. | `bool` | `false` | no |
| tgw\_create | Whether or not to create a Transit Gateway. | `bool` | `false` | no |
| transit\_gateway\_cidr\_blocks | One or more IPv4 or IPv6 CIDR blocks for the transit gateway. Must be a size /24 CIDR block or larger for IPv4, or a size /64 CIDR block or larger for IPv6 | `list(string)` | `[]` | no |
| transit\_gateway\_id | The ID of gateway id. | `string` | `null` | no |
| vpc\_attachments | Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform. | `any` | `{}` | no |
| vpn\_ecmp\_support | Whether VPN Equal Cost Multipath Protocol support is enabled. Valid values: disable, enable. Default value: enable. | `string` | `"enable"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ec2\_transit\_gateway\_arn | EC2 Transit Gateway Amazon Resource Name (ARN) |
| ec2\_transit\_gateway\_association\_default\_route\_table\_id | Identifier of the default association route table |
| ec2\_transit\_gateway\_owner\_id | Identifier of the AWS account that owns the EC2 Transit Gateway |
| ec2\_transit\_gateway\_propagation\_default\_route\_table\_id | Identifier of the default propagation route table |
| ec2\_transit\_gateway\_route\_table\_id | EC2 Transit Gateway Route Table identifier |
| ec2\_transit\_gateway\_vpc\_attachment | Map of EC2 Transit Gateway VPC Attachment attributes |
| ec2\_transit\_gateway\_vpc\_attachment\_ids | List of EC2 Transit Gateway VPC Attachment identifiers |
| ram\_principal\_association\_id | The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma |
| ram\_resource\_share\_id | The Amazon Resource Name (ARN) of the resource share |
| resource\_share\_arn | The ARN  of the RAM. |
| tags | A mapping of tags to assign to the resource. |
| transit\_gateway\_id | The ID of the Transit Gateway. |

