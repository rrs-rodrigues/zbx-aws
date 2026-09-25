resource "aws_vcp" "main" {
    cidr_block           = "var.vpc_cidr"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.project_name}-${var.environment}-vpc"
    }
  
}

# subnets

resource "aws_subnet" "public" {
    count               = length(var.public_subnet_cidrs)
    vpc_id              = aws_vpc.main.id
    cidr_block          = var.public_subnet_cidrs[count.index]
    availability_zone   = var.avaliable_zones[count.index]

    tags = {
        Name = "${var.project_name}-${var.environment}-public-subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "private_app" {
    count               = length(var.private_app_subnet_cidrs)
    vpc_id              = aws_vpc.main.id
    cidr_block          = var.private_app_subnet_cidrs[count.index]
    availability_zone   = var.avaliable_zones[count.index]

    tags = {
        Name = "${var.project_name}-${var.environment}-private-app-subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "private_db" {
    count               = length(var.private_db_subnet_cidrs)
    vpc_id              = aws_vpc.main.id
    cidr_block          = var.private_db_subnet_cidrs[count.index]
    availability_zone   = var.avaliable_zones[count.index]

    tags = {
        Name = "${var.project_name}-${var.environment}-private-db-subnet-${count.index + 1}"
    }
}

# internet gateway and routing 

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}-${var.environment}-igw"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "${var.project_name}-${var.environment}-public-rt"
    }
}

resource "aws_route_table_association" "public" {
    count          = length(var.public_subnet_cidrs)
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

# nat gateway

resource "aws_eip" "nat" {
    count = var.nat_gateway_count
    domain = "vpc"
    tags = {
        Name = "${var.project_name}-${var.environment}-nat-eip-${count.index + 1}"
    }
}

resource "aws_nat_gateway" "nat" {
    count = var.nat_gateway_count
    allocation_id = aws_eip.nat[count.index].id
    subnet_id     = aws_subnet.public[count.index].id

    tags = {
        Name = "${var.project_name}-${var.environment}-nat-gateway-${count.index + 1}"
    }
}

# routing

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat[count.index % var.nat_gateway_count].id
    }
    tags = {
        Name = "${var.project_name}-${var.environment}-private-rt"
    }
}

resource "aws_route_table_association" "private_app" {
    count          = length(var.private_app_subnet_cidrs)
    subnet_id      = aws_subnet.private_app[count.index].id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db" {
    count          = length(var.private_db_subnet_cidrs)
    subnet_id      = aws_subnet.private_db[count.index].id
    route_table_id = aws_route_table.private.id
}


