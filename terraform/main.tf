# resource "aws_ecr_repository" "flask_app" {
#   name = "my-flask-app"
#   image_scanning_configuration {
#     scan_on_push = true
#   }
  
#   tags = {
#     Environment = "dev"
#     Project     = "FlaskApp"
#   }
# }

resource "aws_ecr_repository" "flask_app" {
  name = "my-flask-app"
  image_scanning_configuration {
    scan_on_push = true
  }
  
  tags = {
    Environment = "dev"
    Project     = "FlaskApp"
  }
}

# provider "docker" {
#   host = "unix:///var/run/docker.sock"
# }

# resource "null_resource" "docker_build_and_push" {
#   provisioner "local-exec" {
#     command = <<EOT
#       aws ecr get-login-password --region us-east-1 \
#       | docker login --username AWS --password-stdin ${aws_ecr_repository.flask_app.repository_url}

#       docker build -t ${aws_ecr_repository.flask_app.repository_url}:latest .
#       docker push ${aws_ecr_repository.flask_app.repository_url}:latest
#     EOT
#   }

#   depends_on = [aws_ecr_repository.flask_app]
# }
