
# Demo -1
# Creating RSA key and using the same define the public key
resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terraDemo" {
  key_name   = "terraDemokey"
  public_key = tls_private_key.mykey.public_key_openssh
}

# Demo # 2
resource "aws_iam_user" "OWASPDemo" {
  name          = "OWASP"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "OWASPDemo" {
  user    = aws_iam_user.OWASPDemo.name
  pgp_key = "keybase:terraform"  # define some existing user
}

output "password" {
  value = aws_iam_user_login_profile.OWASPDemo.encrypted_password
}


# Demo # 3
# Creating S3 Bucket

resource "aws_s3_bucket" "DemoBucket" {
  bucket = "owasp-south-florida-chapter"
  acl    = "private"

  tags = {
    Name        = "My Demo bucket"
    Environment = "Dev"
  }
}





#Demo 4
resource "aws_security_group" "instance" {
  name = "terraform-demo-instance"

  ingress {
    from_port   = 0
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}
resource "aws_instance" "terraDemo" {
  ami           = "ami-04bf6dcdc9ab498ca"
  key_name      = aws_key_pair.terraDemo.key_name
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  #key_name = "MyTerraformTest"
  tags = {
    Name        = "OWASP South Florida Chapter"
    Terraform   = "true"
    Environment = "dev"
  }
  connection {
    type = "ssh"
    user = "ec2_user"
    private_key = file("./MyTerraformTest.pem")
    host = self.public_ip
    #timeout = "5m"
    #agent = false
  }


}
