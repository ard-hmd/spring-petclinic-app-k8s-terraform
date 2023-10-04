{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${aws_account_id}:oidc-provider/oidc.eks.eu-west-3.amazonaws.com/id/${oidc_id}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.eu-west-3.amazonaws.com/id/${oidc_id}:aud": "sts.amazonaws.com",
                    "oidc.eks.eu-west-3.amazonaws.com/id/${oidc_id}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
                }
            }
        }
    ]
}

