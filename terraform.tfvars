cidr_blocks = [
  {
    cidr_block = "10.0.0.0/16"   # CIDR pour le VPC
    name       = "myapp-vpc"      # Nom du VPC
  },
  {
    cidr_block = "10.0.1.0/24"    # CIDR pour le premier sous-réseau
    name       = "myapp-subnet-1" # Nom du sous-réseau
  }
]

avail_zone = "europe-west3-a"  # Zone de disponibilité pour GCP (ex: europe-west3-a)
