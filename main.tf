# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "hello_lambda.py"
  output_path = "hello_lambda.zip"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = [
        "lambda.amazonaws.com",
      ]
      type = "Service"
    }
    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "hello_lambda"
  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "hello_lambda.lambda_handler"
  runtime          = "python3.6"
  environment {
    variables = {
      greeting = "Hello"
    }
  }
}

resource "aws_api_gateway_domain_name" "id-test-" {
  domain_name     = my-domain.test
  certificate_arn = a-cert-arn
  arn             = an-arn
}

module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "4.0.0"
  # The resource URL for the security policy to associate with the backend service
  security_policy = ""
  # Content of the SSL certificate. Required if `ssl` is `true` and `ssl_certificates` is empty.
  certificate = ""
  # The url_map resource to use. Default is to send all traffic to first backend.
  url_map = ""
  # Name for the forwarding rule and prefix for supporting resources
  name = ""
  # IP version for the Global address (IPv4 or v6) - Empty defaults to IPV4
  ip_version = ""
  # Content of the private SSL key. Required if `ssl` is `true` and `ssl_certificates` is empty.
  private_key = ""
  # Selfink to SSL Policy
  ssl_policy = ""
  # IP address self link
  address = ""
  # The project to deploy to, if not set the default provider project is used.
  project = ""
  # Map backend indices to list of backend maps.
  backends = {}
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"
  # Assign IPv6 address on redshift subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  redshift_subnet_assign_ipv6_address_on_creation = false
  # Assign IPv6 address on elasticache subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  elasticache_subnet_assign_ipv6_address_on_creation = false
  # Specifies the number of days you want to retain log events in the specified log group for VPC flow logs.
  flow_log_cloudwatch_log_group_retention_in_days = 1
  # Should be true to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic.
  enable_classiclink_dns_support = false
  # Assign IPv6 address on intra subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  intra_subnet_assign_ipv6_address_on_creation = false
  # The ARN of the KMS Key to use when encrypting log data for VPC flow logs.
  flow_log_cloudwatch_log_group_kms_key_id = ""
  # The fields to include in the flow log record, in the order in which they should appear.
  flow_log_log_format = ""
  # The Availability Zone for the VPN Gateway
  vpn_gateway_az = ""
  # Assign IPv6 address on private subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  private_subnet_assign_ipv6_address_on_creation = false
  # Assign IPv6 address on database subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  database_subnet_assign_ipv6_address_on_creation = false
  # Assign IPv6 address on public subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  public_subnet_assign_ipv6_address_on_creation = false
  # Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic.
  enable_classiclink = false
}
