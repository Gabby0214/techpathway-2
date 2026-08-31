resource "aws_ecs_cluster" "main" {
  name = "techpathway-cluster"

  tags = {
    Name = "techpathway-cluster"
  }
}