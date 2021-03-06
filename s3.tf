# NOTE: for html
resource "aws_s3_bucket" "main" {
  bucket = "${local.name}-main"
  acl    = "private"

  force_destroy = true
}

data "aws_iam_policy_document" "main" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_s3_bucket_object" "main_to_main" {
  bucket = aws_s3_bucket.main.bucket
  key    = "main_to_main.html"
  content = templatefile("files/template.html", {
    title = "main to main"
    css   = "style.css"
    js    = "script.js"
    image = "image.png"
  })
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "to_sub2" {
  bucket = aws_s3_bucket.main.bucket
  key    = "to_sub2_asset.html"
  content = templatefile("files/template.html", {
    title = "main to sub2"
    css   = "https://sub2.reireias.link/style.css"
    js    = "https://sub2.reireias.link/script.js"
    image = "https://sub2.reireias.link/image.png"
  })
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "main_css" {
  bucket       = aws_s3_bucket.main.bucket
  key          = "style.css"
  source       = "files/style.css"
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "main_js" {
  bucket       = aws_s3_bucket.main.bucket
  key          = "script.js"
  source       = "files/script.js"
  content_type = "text/javascript"
}

resource "aws_s3_bucket_object" "main_image" {
  bucket       = aws_s3_bucket.main.bucket
  key          = "image.png"
  source       = "files/image.png"
  content_type = "image/png"
}

resource "aws_s3_bucket_object" "main_font" {
  bucket       = aws_s3_bucket.main.bucket
  key          = "fa-regular-400.woff2"
  source       = "files/fa-regular-400.woff2"
  content_type = "application/font-woff2"
}
