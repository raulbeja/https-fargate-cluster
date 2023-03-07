resource "aws_vpc" "vpc" {

  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "IGW"
    },
  )

  depends_on = [aws_vpc.vpc]
}

resource "aws_eip" "eip_ngw" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = merge(
    local.common_tags,
    {
      Name = "EIP-NAT-GW"
    },
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "pub_subnet" {
  count = min("${length(data.aws_availability_zones.available.names)}",var.min_avz)

  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, 100 + count.index)
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = merge(
    local.common_tags,
    {
      Type = "Public"
    },
  )

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "priv_subnet" {
  count = min("${length(data.aws_availability_zones.available.names)}",var.min_avz)

  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, 200 + count.index)
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = merge(
    local.common_tags,
    {
      Type = "Private"
    },
  )

  depends_on = [aws_vpc.vpc]
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip_ngw.id
  subnet_id     = "${element(aws_subnet.pub_subnet.*.id, 0)}"

  tags = merge(
    local.common_tags,
    {
      Name = "NAT-GW"
    },
  )
  
  depends_on = [aws_eip.eip_ngw]
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.common_tags,
    {
      Type = "Public"
      Name = "Route Table"
    },
  )
}

resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.common_tags,
    {
      Type = "Private"
      Name = "Route Table"
    },
  )
}

resource "aws_route" "priv_ngw_route" {
  route_table_id         = aws_route_table.priv_rt.id
  nat_gateway_id         = aws_nat_gateway.ngw.id
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [aws_nat_gateway.ngw]
}

resource "aws_route" "pub_igw_route" {
  route_table_id         = aws_route_table.pub_rt.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table_association" "pub_rt_association" {
  count = min("${length(data.aws_availability_zones.available.names)}",var.min_avz)

  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.pub_subnet[count.index].id 
}

resource "aws_route_table_association" "priv_rt_association" {
  count = min("${length(data.aws_availability_zones.available.names)}",var.min_avz)

  route_table_id = aws_route_table.priv_rt.id
  subnet_id      = aws_subnet.priv_subnet[count.index].id
}