output "image_ids" {
  value = merge(
    module.docker_image_s4.image_ids,
    { haproxy = docker_image.lb.image_id },
    { for name in local.image_names : name => one(toset([
      module.docker_image_s1.image_ids[name],
      module.docker_image_s2.image_ids[name],
      module.docker_image_s3.image_ids[name],
    ])) }
  )
}

locals {
  image_names = toset(concat(
    [for k, v in module.docker_image_s1.image_ids : k],
    [for k, v in module.docker_image_s2.image_ids : k],
    [for k, v in module.docker_image_s3.image_ids : k],
  ))
}
