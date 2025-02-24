output "website_bucket_release" {
  value = { 
    for website, bucket in aws_s3_bucket.static_website : 
    website => bucket
  }
}