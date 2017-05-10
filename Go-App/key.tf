##########################################################
# Key
# Register Key Pair for EC2 Instances
##########################################################

resource  "aws_key_pair" "ssh-key" {
   key_name = "${var.stack-name}-ssh_key"
   public_key = "${file(var.key-filename)}"
}
