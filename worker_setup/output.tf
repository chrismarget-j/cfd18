output "image_ids" {
  value = { for name in local.image_names : name => one(toset([
    local.s1_images[name],
    local.s2_images[name],
    local.s3_images[name],
  ])) }
}

locals {
  s1_images = { for k, v in docker_image.s1_images : k => v.image_id }
  s2_images = { for k, v in docker_image.s2_images : k => v.image_id }
  s3_images = { for k, v in docker_image.s3_images : k => v.image_id }
  image_names = toset(concat(
    [for k, v in docker_image.s1_images : k],
    [for k, v in docker_image.s2_images : k],
    [for k, v in docker_image.s3_images : k],
  ))
}