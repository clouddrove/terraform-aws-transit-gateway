# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2023-09-25
### :sparkles: New Features
- [`0af31d4`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/0af31d45289d1c9e59903df44bceebd5523d5781) - added tfsec.yml file workflow with shared-workflows *(commit by [@vibhutigoyal](https://github.com/vibhutigoyal))*
- [`6e55385`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/6e553853d740e28962ec62e5896036fa707fe216) - added changelog.yml file use shared workflow *(commit by [@vibhutigoyal](https://github.com/vibhutigoyal))*
- [`2d501a9`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/2d501a970fe8fd5f830b1b647f8707087b7dabab) - added dependabot.yml *(commit by [@vibhutigoyal](https://github.com/vibhutigoyal))*
- [`d4949f3`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/d4949f33414beb3e5169c4b98c1f82153c6104d3) - auto changelog action added *(commit by [@vibhutigoyal](https://github.com/vibhutigoyal))*
- [`d39f5b3`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/d39f5b341b9615a5b82b77026dbb3ee0db3ad30b) - add terratest.yml in workflows *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`45ca02e`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/45ca02e878894c85e2489318bb0ab43be237407d) - added codeowners file *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`2f5d76a`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/2f5d76af09228f9210e5ba03714cf770eccde34b) - added new resources and updated code *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`4e25ce0`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/4e25ce0d06d21169e5d324d961dbfa87ceb8792d) - fix tflint *(commit by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`2c01c2e`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/2c01c2eb0aef7e8bcc03cdd9f50f72684188c9eb) - Updated module to be dynamic *(commit by [@13archit](https://github.com/13archit))*
- [`f27d63f`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/f27d63f606de2f505a7c23d924bf13c44926cba1) - Update examples as per latest code *(commit by [@13archit](https://github.com/13archit))*
- [`8191005`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/81910053af8813ef39545202ce9c59c52b25f94d) - Added seperate example for slave and master account *(commit by [@13archit](https://github.com/13archit))*

### :bug: Bug Fixes
- [`1927c42`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/1927c42e4a13e3d3a4206736ba501910295b6541) - updated vpc tag *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`a2c7528`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/a2c7528ce4099b54f132225ff11f3d80ab0c8489) - updated vpc tag *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`bcca86d`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/bcca86d789bbea8fc2154ba9ca044bd1a7ba571e) - updated vpc tag *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`f57d3d1`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/f57d3d1a3d3f12b902bf5093b1eb63db59b776e9) - updated main.tf *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`380c01d`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/380c01d1ec8bcef28f1b6ac71ecdf8c30f6c3978) - updated github action *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`0ffb99c`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/0ffb99c6e3aae97d5362dc2c1219ad624c34447b) - updated vpc tag and readme.yaml *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`c52e4a0`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/c52e4a090c36a60ea81baee1dad3774843e5bc8f) - Update routes resource for rvpc route table *(commit by [@13archit](https://github.com/13archit))*
- [`e976b7b`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/e976b7b83e4a7643abebc3e39849a7e49fa5bf9b) - Fixed tfcheks and defsec warnings *(commit by [@13archit](https://github.com/13archit))*
- [`8253f55`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/8253f553bd439e5c6635cbed25c488b92917fede) - Fixed ouputs.tf in examples *(commit by [@13archit](https://github.com/13archit))*
- [`5dd3771`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/5dd377170f72439f2daa4d1edc6daf7b8eafec6b) - tgw module multi run fixed *(commit by [@d4kverma](https://github.com/d4kverma))*


## [1.0.2] - 2022-07-27
### :bug: Bug Fixes
- [`24e592f`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/24e592f6db17f8319678bd8a2502e4bc571b2fa2)- subnet and route_table issue fixed

## [1.0.1] - 2022-05-31
### :bug: Bug Fixes
- [`354895b`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/354895bb12166aed1f909139ea7adb8cc0f48266)- subnet and route_table issue fixed 


## [0.12.1] - 2021-04-28
### :bug: Bug Fixes
- [`fa9aca3`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/fa9aca3f57510da16feab3c16f7c86d96d79a7c4)- upgrade module in 0.15 
- [`189bce1`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/189bce1a03c2c9725734e83ce7bdf2f62b5f9fc3) - remove application tag 
- [`354895b`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/354895bb12166aed1f909139ea7adb8cc0f48266) - subnet and route_table issue fixed 

## [0.12.0] - 2020-01-16
### :bug: Bug Fixes
- [`354895b`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/354895bb12166aed1f909139ea7adb8cc0f48266) - subnet and route_table issue fixed 
- [`fa9aca3`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/fa9aca3f57510da16feab3c16f7c86d96d79a7c4) - upgrade module in 0.15 
- [`2229a65`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/2229a65e990b7a39c0c3948a2908420c65ad1bf4) - Updated Files 
- [`107a473`](https://github.com/clouddrove/terraform-aws-transit-gateway/commit/107a473fb5bc4f723aa10c9c4a58e23e7fb348a9) - fix labels managedby variables 


[1.0.2]: https://github.com/clouddrove/terraform-aws-transit-gateway/releases/tag/1.0.2
[1.0.1]: https://github.com/clouddrove/terraform-aws-transit-gateway/compare/1.0.1...master
[0.12.1]: https://github.com/clouddrove/terraform-aws-transit-gateway/compare/0.12.1...master
[0.12.0]: https://github.com/clouddrove/terraform-aws-transit-gateway/compare/0.12.0...master
[2.0.0]: https://github.com/clouddrove/terraform-aws-transit-gateway/compare/1.0.2...2.0.0