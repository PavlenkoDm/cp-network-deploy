### Object Storage Configuration
resource "yandex_iam_service_account" "storage_sa" {
  name        = "storage-sa"
  description = "Service account for Object Storage operations"
}

resource "yandex_resourcemanager_folder_iam_member" "storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.storage_sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "storage_key" {
  service_account_id = yandex_iam_service_account.storage_sa.id
  description        = "Static key for Object Storage access"
}

resource "yandex_storage_bucket" "netology_bucket" {
  bucket = var.bucket_name

  access_key = yandex_iam_service_account_static_access_key.storage_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.storage_key.secret_key

  anonymous_access_flags {
    read = true
    list = false
  }

  force_destroy = true
}

resource "yandex_storage_object" "picture" {
  bucket = yandex_storage_bucket.netology_bucket.bucket

  key    = "W3WH.jpg"
  source = var.picture_path
  acl    = "public-read"

  access_key = yandex_iam_service_account_static_access_key.storage_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.storage_key.secret_key
}