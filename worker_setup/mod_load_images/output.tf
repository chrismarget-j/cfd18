output "image_ids" {
  value = { for k, v in docker_image.o : k => v.image_id }
}
