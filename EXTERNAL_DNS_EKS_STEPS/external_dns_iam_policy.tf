# Create an IAM Policy
resource "aws_iam_policy" "allow_external_dns_updates" {
  name        = "AllowExternalDNSUpdates"
  description = "Allow access to Route53 Resources for ExternalDNS"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets"
        ],
        Resource = [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ],
        Resource = [
          "*"
        ]
      }
    ]
  })
}
