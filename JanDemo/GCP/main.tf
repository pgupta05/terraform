provider "google" {
  project = "devops-230818"
  credentials = "${file("./devops-230818-6cce71bcf27a.json")}"
  region  = "us-east4"
  zone    = "us-east4-a"
}


resource "google_compute_instance" "default" {
  name = "terraformdemo"
  machine_type = "e2-medium"
  zone = "us-east4-a"

  tags = ["pradip", "rose"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }



   network_interface {
     network = "default"

     access_config {
       // Ephemeral IP
     }
   }

   metadata = {
     foo = "pradip"
   }

   metadata_startup_script = "echo Hello from TerraformDemo!! > /test.txt"


 }
