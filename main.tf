provider "aws" {
	region  = "eu-west-2"
    version = "2.55.0"
}

resource "aws_api_gateway_rest_api" "api" {
  name = "api"
}

resource "aws_api_gateway_authorizer" "api_authorizer" {
  name                             = "authorizer"
  rest_api_id                      = aws_api_gateway_rest_api.api.id
  authorizer_uri                   = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials           = aws_iam_role.api_authorizer.arn
  type                             = "REQUEST"
  authorizer_result_ttl_in_seconds = 0
}

resource "aws_lambda_function" "authorizer" {
  filename      = "files/lambda.zip"
  function_name = "authorizer"
  role          = aws_iam_role.authorizer_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"
  source_code_hash = filebase64sha256("files/lambda.zip")
}

resource "aws_iam_role" "authorizer_lambda" {
  name = "authorizer-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role" "api_authorizer" {
  name = "api-authorizer"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}