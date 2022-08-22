
resource "aws_iam_openid_connect_provider" "default" {
  url = "https://token.actions.githubusercontent.com"

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  client_id_list = ["sts.amazonaws.com"]


}





data "aws_iam_openid_connect_provider" "example" {
  url = "https://token.actions.githubusercontent.com"
  depends_on = [
    aws_iam_openid_connect_provider.default
  ]
}

resource "aws_iam_role" "default" {
  name = "test_oidc_role"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json

  depends_on = [
    aws_iam_openid_connect_provider.default
  ]
}

resource "aws_iam_role_policy" "default" {
  name = "test_oidc_role_policy"
  role = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.default.json

  depends_on = [
    aws_iam_openid_connect_provider.default
  ]
}

data "aws_iam_policy_document" "assume-role" {

  depends_on = [
    aws_iam_openid_connect_provider.default
  ]
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
      variable = "token.actions.githubusercontent.com:aud"
      values = ["sts.amazonaws.com"]
    }

    condition {
      test = "StringLike"
      values = [
        "repo:aboogie24/*"
      ]
      variable = "token.actions.githubusercontent.com:sub"
    }
  }
}

data "aws_iam_policy_document" "default" {

  depends_on = [
    aws_iam_openid_connect_provider.default
  ]
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

