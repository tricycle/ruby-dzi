module FileStore

  def save_file(path, content)
    open(path, "w") { |f| f.puts(content) }
  end

  def save_image_file(image, path, quality)
    image.write(path) { self.quality = quality }
  end

  def remove_file(file)
    return false unless File.file?(file)

    File.delete file
    true
  end

  def remove_dir(dir)
    return false unless File.directory?(dir)

    FileUtils.remove_dir dir
    true
  end

  def create_dir(dir)
    FileUtils.mkdir_p(dir)
  end
end