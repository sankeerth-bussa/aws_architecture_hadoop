# Using 3 different AWS accounts this can be even done with 1 AWS account
provider "aws" {
	alias = "sankeerth"
	region = "us-east-1"
	profile = "sankeerth"
}

provider "aws" {
        alias = "kumar"
        region = "us-east-1"
        profile = "kumar"
}

provider "aws" {
        alias = "nobel"
        region = "us-east-1"
        profile = "nobel"
}