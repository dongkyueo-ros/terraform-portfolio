output "aws_lb_controller_release" {
  value = helm_release.aws_lb_controller.name
}