class Build::Aws
  REGION = 'us-west-1'

  def deploy
    s3 = Aws::S3::Resource.new(region: REGION)
    bucket = s3.bucket('lol-schedule')

    Build::Html::YEARS_FILES.each_pair do |year, file|
      obj = bucket.object(file)
      obj.upload_file((Build.output_path + file).to_s,
        acl: 'public-read',
        cache_control: 'max-age=300',
        content_type: 'text/html'
      )
    end

    obj = bucket.object('icons.png')
    obj.upload_file((Build.output_path + 'icons.png').to_s,
      acl: 'public-read',
      cache_control: 'max-age=3600',
      content_type: 'image/png'
    )
  end

  def invalidate
    cloudfront = Aws::CloudFront::Client.new(region: REGION)
    cloudfront.create_invalidation({
      distribution_id: 'EZONQIMJRRGWP',
      invalidation_batch: {
        paths: {
          quantity: 2,
          items: Build::Html::YEARS_FILES.values.map { |v| "/#{v}" } + ['/icons.png']
        },
        caller_reference: "invalidation-#{Time.now.to_i}"
      }
    })
  end
end