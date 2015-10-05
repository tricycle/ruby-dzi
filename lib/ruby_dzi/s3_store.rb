module RubyDzi
  class S3Store
    attr_reader :bucket_name

    def initialize(opts)
      self.bucket_name = opts[:bucket_name]

      Aws.config(
        opts.slice(
          :access_key_id,
          :secret_access_key,
          :use_ssl,
          :proxy_uri
        )
      )
    end

    def s3_bucket
      @s3_bucket ||= Aws::S3::Resource.new.bucket(bucket_name)
    end

    def s3_object(path)
      s3_bucket.object(path)
    end

    def save_file(path, content)
      s3_object(path).put(
        body: content,
        acl:  :authenticated_read
      )
    end

    def save_image_file(image, path, quality)
      tmpfile = Tempfile.new('dzi-s3')
      image.write(tmpfile.path) { self.quality = quality }

      save_file path, open(tmpfile.path)

      tmpfile.delete
    end

    def remove_file(file)
      s3_object(file).delete
    end
    alias_method :remove_dir, :remove_file

    def create_dir(dir)
      # do nothing
    end

protected
    attr_writer :bucket_name

  end
end
