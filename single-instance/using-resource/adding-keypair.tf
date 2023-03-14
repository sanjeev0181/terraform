## C:\Users\sekhar.chebrolu\Downloads\dimpu\chan\devops key-pair path in local 

#making ssh connection
resource "aws_key_pair" "deployer" {
  key_name   = "n.v_key"
  public_key = file("/home/ubuntu/terraform/terraform/single-instance/using-resource//private_key/n.v-cnv.pem")
}