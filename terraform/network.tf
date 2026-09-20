# Discover available Availability Zones in the selected AWS region.
data "aws_availability_zones" "available" {
  state = "available"
}

# Project 5 VPC.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway for public internet connectivity.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public subnets across two Availability Zones.
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${count.index + 1}"

    # Used by Kubernetes/AWS load-balancing integrations
    # to identify public subnets.
    "kubernetes.io/role/elb" = "1"
  }
}

# Private subnets for EKS worker nodes and Pods.
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_name}-private-${count.index + 1}"

    # Identifies these as private subnets for internal
    # Kubernetes/AWS load balancers.
    "kubernetes.io/role/internal-elb" = "1"
  }
}
