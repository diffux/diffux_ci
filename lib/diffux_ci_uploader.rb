require 'diffux_ci_utils'
require 's3'
require 'securerandom'

class DiffuxCIUploader
  BUCKET_NAME = 'diffux_ci-diffs'

  def initialize
    @s3_access_key_id = DiffuxCIUtils.config['s3_access_key_id']
    @s3_secret_access_key = DiffuxCIUtils.config['s3_secret_access_key']
  end

  def upload_diffs
    current_snapshots = DiffuxCIUtils.current_snapshots
    return [] if current_snapshots[:diffs].empty?

    bucket = find_or_build_bucket

    dir = SecureRandom.uuid

    diff_images = current_snapshots[:diffs].map do |diff|
      image = bucket.objects.build(
        "#{dir}/#{diff[:description]}_#{diff[:viewport]}.png")
      image.content = open(diff[:file])
      image.content_type = 'image/png'
      image.save
      diff[:url] = image.url
      diff
    end

    html = bucket.objects.build("#{dir}/index.html")
    path = File.expand_path(
      File.join(File.dirname(__FILE__), 'diffux_ci-diffs.html.erb'))
    html.content = ERB.new(File.read(path)).result(binding)
    html.content_type = 'text/html'
    html.save
    html.url
  end

  private

  def find_or_build_bucket
    service = S3::Service.new(access_key_id: @s3_access_key_id,
                              secret_access_key: @s3_secret_access_key)
    bucket = service.buckets.find(BUCKET_NAME)

    if bucket.nil?
      bucket = service.buckets.build(BUCKET_NAME)
      bucket.save(location: :us)
    end

    bucket
  end
end
