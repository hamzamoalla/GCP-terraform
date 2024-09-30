# Identifiant du projet GCP
project_id = "votre-projet-gcp-id"

# Région dans laquelle déployer les ressources
region = "europe-west1"

# CIDR block pour le VPC
vpc_cidr_block = "10.0.0.0/16"

# CIDR block pour le subnet
subnet_cidr_block = "10.0.1.0/24"

# Zone de disponibilité GCP
avail_zone = "europe-west1-b"

# Préfixe d'environnement pour nommer les ressources
env_prefix = "dev"


# Type d'instance pour les machines virtuelles
instance_type = "e2-medium"

# Chemin vers votre clé publique SSH
public_key_location = "C:/Users/User/.ssh/id_rsa.pub"
