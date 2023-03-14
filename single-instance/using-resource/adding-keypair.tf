## C:\Users\sekhar.chebrolu\Downloads\dimpu\chan\devops key-pair path in local 

#making ssh connection
resource "aws_key_pair" "deployer" {
  key_name   = "n.v-cnv"
  public_key = file("C:\Users\sekhar.chebrolu\Downloads\dimpu\chan\devops\n.v-cnv.pem")
}