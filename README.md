
## Assumptions
This project use a SSL Certificate for a given domain in ACM (Amazon Certificate Manager) and existing Route53 hosted zone. SSL Certificate need to be in the same region used to deploy web server.

## Description
Repository to deploy an HTTPS Web Server using ECS Fargate Cluster in VPC Private Subnets. A Load Balancer will be created on Public Subnets with an SSL certificate to route traffic to Fargate, and the appropriate DNS records will be created in an existing Route53 Hosted Zone to validate the SSL certificate and route traffic from the domain to the load balancer. A NAT Gateway will be created on Public Subnet to allow ECS access to Public DockerHub repository and deploy nginx Container Image.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.55.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Resources

| Name | Type |
|------|------|
| [template_file.ecs_task_definition_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [aws_route53_zone.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_acm_certificate.ecs_domain_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_route53_record.ecs_lb_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_route_table.pub_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.priv_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_subnet.pub_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_route_table_association.pub_rt_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_eip.eip_ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_route.pub_igw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_alb.ecs_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_alb_listener.ecs_alb_http_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener.ecs_alb_https_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.ecs_alb_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_cloudwatch_log_group.Myapp_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_subnet.priv_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_route_table_association.priv_rt_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route.priv_ngw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_ecs_cluster.ecs_fargate_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.nginx-task-definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.fargate_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.fargate_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_security_group.ecs_alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.app_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region in which AWS Resources to be created | `string` | `"us-east-1"` | no |
| <a name="input_desired_task_number"></a> [desired\_task\_number](#input\_desired\_task\_number) | Number of tasks | `number` | `2` | no |
| <a name="input_docker_container_port"></a> [docker\_container\_port](#input\_docker\_container\_port) | Application container exposed port | `number` | `80` | no |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | Docker Image URL | `string` | `"nginx:latest"` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | Cluster Name | `string` | `"MyCluster"` | no |
| <a name="input_ecs_domain_name"></a> [ecs\_domain\_name](#input\_ecs\_domain\_name) | Cluster Domain Name | `string` | `"rbgdevdom.es"` | no |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | Application service name | `string` | `"fargate-nginx"` | no |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | ECS task cpu | `string` | `"256"` | no |
| <a name="input_ecs_task_memory"></a> [ecs\_task\_memory](#input\_ecs\_task\_memory) | ECS task memory | `string` | `"512"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment Variable | `string` | `"mysandbox"` | no |
| <a name="input_inet_cidr_block"></a> [inet\_cidr\_block](#input\_inet\_cidr\_block) | Internet CIDR Block | `string` | `"0.0.0.0/0"` | no |
| <a name="input_min_avz"></a> [min\_avz](#input\_min\_avz) | Minimun number of availability zones | `number` | `2` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Infrastructure Owner | `string` | `"rbg"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR Block | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_domain_name"></a> [ecs\_domain\_name](#output\_ecs\_domain\_name) | Used Domain Name |
| <a name="output_ecs_endpoint"></a> [ecs\_endpoint](#output\_ecs\_endpoint) | HTTPS Web Server EndPoint |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | n/a |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | n/a |
| <a name="output_ecs_alb_listener_arn"></a> [ecs\_alb\_listener\_arn](#output\_ecs\_alb\_listener\_arn) | n/a |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | n/a |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | n/a |

