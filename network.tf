module "network_layer" {
  # Path to the module folder you created
  source = "./modules/network"
  # Pass variables from your root variables or directly
  vpc_cidr = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}
