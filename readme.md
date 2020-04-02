# terraform-aws-apigateway-authorizer-cache

A repo to show an example of terraform not creating an api authorizer correctly when the `authorizer_result_ttl_in_seconds` is set to `0`.  More at terraform-providers/terraform-provider-aws#12633.

## Repro steps

The first run of `terraform plan` gives this:

```
# aws_api_gateway_authorizer.api_authorizer will be created
  + resource "aws_api_gateway_authorizer" "api_authorizer" {
      + authorizer_credentials           = (known after apply)
      + authorizer_result_ttl_in_seconds = 0
      + authorizer_uri                   = (known after apply)
      + id                               = (known after apply)
      + identity_source                  = "method.request.header.Authorization"
      + name                             = "authorizer"
      + rest_api_id                      = (known after apply)
      + type                             = "REQUEST"
    }
```

Now run `terraform apply`.

Running `terraform plan` for a second time gives this:

```
  # aws_api_gateway_authorizer.api_authorizer will be updated in-place
  ~ resource "aws_api_gateway_authorizer" "api_authorizer" {
        authorizer_credentials           = "arn:aws:iam::************:role/api-authorizer"
      ~ authorizer_result_ttl_in_seconds = 300 -> 0
        authorizer_uri                   = "arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-2:************::function:authorizer/invocations"
        id                               = "7q1ebw"
        identity_source                  = "method.request.header.Authorization"
        name                             = "authorizer"
        provider_arns                    = []
        rest_api_id                      = "gdrd3ai27a"
        type                             = "REQUEST"
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

I have verified the aws console and cli that the initial value of `0` is not set.
