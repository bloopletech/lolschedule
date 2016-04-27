class Build::Aws
  REGION = 'us-west-1'

  def deploy(index_path, icons_path)
    s3 = Aws::S3::Resource.new(region: REGION)
    bucket = s3.bucket('lol-schedule')

    obj = bucket.object('index.html')
    obj.upload_file(index_path.to_s, acl: 'public-read', cache_control: 'max-age=300', content_type: 'text/html')

    obj = bucket.object('icons.png')
    obj.upload_file(icons_path.to_s, acl: 'public-read', cache_control: 'max-age=3600', content_type: 'image/png')
  end

  def invalidate
    cloudfront = Aws::CloudFront::Client.new(region: REGION)
    cloudfront.create_invalidation({
      distribution_id: 'EZONQIMJRRGWP',
      invalidation_batch: {
        paths: {
          quantity: 2,
          items: ['/index.html', '/icons.png'],
        },
        caller_reference: "invalidation-#{Time.now.to_i}"
      }
    })
  end
end