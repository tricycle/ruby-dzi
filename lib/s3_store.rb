require 'aws/s3'

class S3Store
  def initialize(opts)
    @bucket = opts.delete(:bucket_name)
    AWS::S3::Base.establish_connection!(
      :access_key_id     => opts[:access_key_id],
      :secret_access_key => opts[:secret_access_key]
    )
  end

  def save_file(path, content)
    AWS::S3::S3Object.store(path, content, @bucket)
  end

  def save_image_file(image, path, quality)
    tmpfile = Tempfile.new('dzi-s3')
    image.write(tmpfile.path) { self.quality = quality }

    save_file path, open(tmpfile.path)

    tmpfile.delete
  end

  def remove_file(file)
    AWS::S3::S3Object.delete file, @bucket
  end
  alias_method :remove_dir, :remove_file

  def create_dir(dir)
    # do nothing
  end
end
