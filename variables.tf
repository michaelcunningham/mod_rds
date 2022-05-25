variable "region" {
  default = "us-west-2"
}

# To find which ami to use below, use this
# aws ec2 describe-images --profile michael --region us-east-1 --owners 099720109477 \
#   --filters "Name=architecture,Values=x86_64" "Name=is-public,Values=true" \
#   --query 'Images[?starts_with(ImageLocation,`099720109477/ubuntu/images/hvm-ssd`) == `true`]| sort_by(@, &CreationDate)[].[ImageId]' --output text | tail -1
#
# aws ec2 describe-images --profile michael --region us-west-2 --owners 099720109477 \
#   --filters "Name=architecture,Values=x86_64" "Name=is-public,Values=true" \
#   --query 'Images[?starts_with(ImageLocation,`099720109477/ubuntu/images/hvm-ssd`) == `true`]| sort_by(@, &CreationDate)[].[ImageId]' --output text | tail -1

variable "amis" {
  type = map
  default = {
    "us-east-1" = "ami-0424b3d654b495069"
    "us-west-2" = "ami-0424f1488823952f7"
  }
}
