resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/techpathway-backend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/techpathway-frontend"
  retention_in_days = 7
}