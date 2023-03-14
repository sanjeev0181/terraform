## C:\Users\sekhar.chebrolu\Downloads\dimpu\chan\devops key-pair path in local 

#making ssh connection
resource "aws_key_pair" "deployer" {
  key_name   = "id_rsa.pub"
  public_key = file("/home/ubuntu/.ssh/id_rsa.pub")
}