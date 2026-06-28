resource "aws_iam_role_policy" "ec2_s3_access" {
  count = length(var.ec2_projects_s3_bucket_names) > 0 ? 1 : 0

  name = "ec2-s3-access"
  role = aws_iam_role.ec2_projects.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          for bucket_name in var.ec2_projects_s3_bucket_names :
          "arn:aws:s3:::${bucket_name}"
        ]
      },
      {
        Sid    = "S3ObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          for bucket_name in var.ec2_projects_s3_bucket_names :
          "arn:aws:s3:::${bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_ssm_parameter_access" {
  count = length(var.ec2_projects_ssm_parameter_paths) > 0 ? 1 : 0

  name = "ec2-ssm-parameter-access"
  role = aws_iam_role.ec2_projects.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadProjectParameters"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = [
          for path_prefix in var.ec2_projects_ssm_parameter_paths :
          "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${trimsuffix(path_prefix, "/")}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_dynamodb_access" {
  name = "ec2-dynamodb-access"
  role = aws_iam_role.ec2_projects.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DynamoDBAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "github_actions_iam_limited" {
  name = "github-actions-iam-limited-management"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "IAMRoleManagement"
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:UpdateRole",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy"
        ]
        Resource = [
          aws_iam_role.cost_explorer_reader.arn,
          aws_iam_role.ec2_projects.arn,
          aws_iam_role.github_actions.arn
        ]
      },
      {
        Sid    = "IAMInstanceProfileManagement"
        Effect = "Allow"
        Action = [
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:TagInstanceProfile",
          "iam:UntagInstanceProfile"
        ]
        Resource = [
          aws_iam_role.cost_explorer_reader.arn,
          aws_iam_role.ec2_projects.arn,
          aws_iam_role.github_actions.arn,
          aws_iam_instance_profile.ec2_projects.arn
        ]
      },
      {
        Sid    = "OIDCProviderManagement"
        Effect = "Allow"
        Action = [
          "iam:CreateOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:UpdateOpenIDConnectProviderThumbprint",
          "iam:AddClientIDToOpenIDConnectProvider",
          "iam:RemoveClientIDFromOpenIDConnectProvider",
          "iam:TagOpenIDConnectProvider",
          "iam:UntagOpenIDConnectProvider"
        ]
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_bedrock_access" {
  name = "ec2-bedrock-access"
  role = aws_iam_role.ec2_projects.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BedrockInvoke"
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = [
          "arn:aws:bedrock:${var.aws_region}::foundation-model/anthropic.claude-*",
          "arn:aws:bedrock:${var.aws_region}::foundation-model/minimax.*"
        ]
      },
      {
        Sid    = "BedrockDiscovery"
        Effect = "Allow"
        Action = [
          "bedrock:ListFoundationModels",
          "bedrock:GetFoundationModel"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "github_actions_tfstate" {
  name = "github-actions-tfstate-access"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3StateAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.tfstate_bucket_name}",
          "arn:aws:s3:::${var.tfstate_bucket_name}/*"
        ]
      }
    ]
  })
}
