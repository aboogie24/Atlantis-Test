
resource "aws_iam_openid_connect_provider" "default" {
  url = "https://token.actions.githubusercontent.com"

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  client_id_list = ["sts.amazonaws.com"]
}





data "aws_iam_openid_connect_provider" "example" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "default" {
  name = "test_oidc_role"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

resource "aws_iam_role_policy" "default" {
  name = "test_oidc_role_policy"
  role = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "assume-role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"
      identifiers = ["${data.aws_iam_openid_connect_provider.example.arn}"]
    }

    condition {
      test = "StringEquals"
      values = [
        "repo:aboogie24/Atlantis:pull_request",
        "repo:aboogie24/Atlantis:ref:refs/head/main"
      ]
      variable = "token.actions.githubusercontent.com:sub"
    }
  }
}

data "aws_iam_policy_document" "default" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:PutImage",
      "ecr:DescribeImageTags",
      "ecr:DescribeRegistries",
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }
}

