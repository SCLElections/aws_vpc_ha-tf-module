# aws_vpc_ha-tf-module
This modules creates AWS VPC's in High Availability Mode and subnets.

## Example

```hcl-terraform
module "vpc" {
  source             = "git@github.com:SCLElections/aws_vpc_ha-tf-module"
  allocated-cidr     = "10.0.0.0/8"
  region             = "eu-central-1"
  availability-zones = ["a", "b", "c"]
  tags               = {
    Name                   = "projectname"
    project                = "github-repo-name"
    environment            = "prd"
    cost-center            = "0000"
    creator                = "filipe.ferreira@sclgroup.cc"
  }
}

```

## Input Variables
* **tags** - **[map]** - (required) - AWS resource tags following company recommended.
* **allocated-cidr** - **[string]** - (required) - Allocated cidr block for the specific vpc.
* **region** - **[string]** - (required) - AWS Region to create the vpc.
* **availability-zones** - **[list]** - (required) - Availability zones for each of the subnets.
* **newbits** - **[string]** - (default: 8) - Number used to split vpc cidr.
 

## Output Variables
* **public-subnets** - List of public subnets.
* **private-subnets** - List of private subnets.
* **id** - ID of the VPC.
* **cidr** - Cidr block of the VPC.
* **ipv6-cidr** - IPV6 Cidr block of the VPC.
* **ngw** - Network gateway of the VPC.
* **igw** - Internet gateway of the VPC.