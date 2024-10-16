#provider "aws" {
#  region = "us-east-1"
#}

#Creacion de la VPC
resource "aws_vpc" "vpc_cloud_aws" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags={
        Name = "cloud_aws_vpc"
    }
    
}

#Creacion de la subred publica 1
resource "aws_subnet" "public_1" {
    vpc_id = aws_vpc.vpc_cloud_aws.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "public1"
    }
}


#Creacion de la subred publica 2
resource "aws_subnet" "public_2" {
    vpc_id     = aws_vpc.vpc_cloud_aws.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    
    tags = {
        Name = "public2"
    }
}
#Creacion de la subred privada 1
resource "aws_subnet" "private_1" {
    vpc_id     = aws_vpc.vpc_cloud_aws.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true
    
    tags = {
        Name = "private1"
        }
}
#Creacion de la subred privada 2
resource "aws_subnet" "private_2" {
    vpc_id     = aws_vpc.vpc_cloud_aws.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1d"
    map_public_ip_on_launch = true
    
    tags = {
        Name = "private2"
        }
}

#Creacion de Internet Gateway
resource "aws_internet_gateway" "igw_aws_cloud" {
    vpc_id = aws_vpc.vpc_cloud_aws.id
    
    tags = {
        Name = "Internet_Gateway"
        }
}

#Creacion de la tabla de enrrutamiento
resource "aws_route_table" "route_table_aws_public" {
    vpc_id = aws_vpc.vpc_cloud_aws.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_aws_cloud.id
        
        }
        
        tags = {
            Name = "tabla_enrrutamiento_aws"
            }
}

resource "aws_route_table" "route_table_aws_private" {
    vpc_id = aws_vpc.vpc_cloud_aws.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_aws_cloud.id
        
        }
        
        tags = {
            Name = "tabla_enrrutamiento_aws"
            }
}

#Asociasion de la tabla de enrrutamiento con las subredes
resource "aws_route_table_association" "asociacion_publica1" {
    subnet_id = aws_subnet.public_1.id
    route_table_id = aws_route_table.route_table_aws_public.id
}

resource "aws_route_table_association" "asociacion_publica2" {
    subnet_id = aws_subnet.public_2.id
    route_table_id = aws_route_table.route_table_aws_public.id  
}

resource "aws_route_table_association" "asociacion_privada1" {
    subnet_id = aws_subnet.private_1.id
    route_table_id = aws_route_table.route_table_aws_private.id  
}

resource "aws_route_table_association" "asociacion_privada2" {
    subnet_id = aws_subnet.private_2.id
    route_table_id = aws_route_table.route_table_aws_private.id  
}