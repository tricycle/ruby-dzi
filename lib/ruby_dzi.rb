# Ruby Dzi generator
# A fork from Deep Zoom Slicer project
#
# Ruby Dzi slices images and generates a dzi file that is compatible with DeepZoom or Seadragon
#
# Requirements: rmagick gem (tested with version 2.9.0)
#
# Contributor: Marc Vitalis <marc.vitalis@live.com> 
#
# Original Author:: MESO Web Scapes (www.meso.net)
# By:: Sascha Hanssen <hanssen@meso.net>
# License:: MPL 1.1/GPL 3/LGPL 3
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
# for the specific language governing rights and limitations under the
# License.
#
require 'rubygems'
require 'fileutils'
require 'RMagick'
require 'open-uri'

class RubyDzi
  include Magick

  attr_accessor :image_path, :name, :format, :output_ext, :quality, :dir, :tile_size, :overlap

  def initialize(image_path)

    #set defaults
    @quality = 75
    @dir = '.'
    @tile_size = 254
    @overlap = 1
    @output_ext = 'dzi'

    @image_path = image_path

  end

  def generate!(name, format = 'jpg')
    @name = name
    @format = format
    
    @levels_root_dir     = File.join(@dir, @name + '_files')
    @xml_descriptor_path = File.join(@dir, @name + '.' + @output_ext)

    image = get_image(@image_path)
    
    image.strip! # remove meta information

    orig_width, orig_height = image.columns, image.rows

    remove_files!

    # iterate over all levels (= zoom stages)
    max_level(orig_width, orig_height).downto(0) do |level|
      width, height = image.columns, image.rows
      
      current_level_dir = File.join(@levels_root_dir, level.to_s)
      FileUtils.mkdir_p(current_level_dir)
      
      # iterate over columns
      x, col_count = 0, 0
      while x < width      
        # iterate over rows
        y, row_count = 0, 0
        while y < height          
          dest_path = File.join(current_level_dir, "#{col_count}_#{row_count}.#{@format}")
          tile_width, tile_height = tile_dimensions(x, y, @tile_size, @overlap)
          
          save_cropped_image(image, dest_path, x, y, tile_width, tile_height, @quality)
          
          y += (tile_height - (2 * @overlap))
          row_count += 1
        end
        x += (tile_width - (2 * @overlap))
        col_count += 1
      end
      
      image.resize!(0.5)
    end

    # generate xml descriptor and write file
    write_xml_descriptor(@xml_descriptor_path,
                         :tile_size => @tile_size,
                         :overlap   => @overlap,
                         :format    => @format,
                         :width     => orig_width,
                         :height    => orig_height)
  end

  def remove_files!
    files_existed = (File.file?(@xml_descriptor_path) or File.directory?(@levels_root_dir))

    File.delete @xml_descriptor_path if File.file? @xml_descriptor_path
    FileUtils.remove_dir @levels_root_dir if File.directory? @levels_root_dir

    return files_existed
  end

protected

  def tile_dimensions(x, y, tile_size, overlap)
    overlapping_tile_size = tile_size + (2 * overlap)
    border_tile_size      = tile_size + overlap
    
    tile_width  = (x > 0) ? overlapping_tile_size : border_tile_size
    tile_height = (y > 0) ? overlapping_tile_size : border_tile_size
    
    return tile_width, tile_height
  end

  def max_level(width, height)
    return (Math.log([width, height].max) / Math.log(2)).ceil
  end

  def save_cropped_image(src, dest, x, y, width, height, quality = 75)
    if src.is_a? Magick::Image
      img = src
    else
      img = Magick::Image::read(src).first
    end
    
    quality = quality * 100 if quality < 1

    # The crop method retains the offset information in the cropped image.
    # To reset the offset data, adding true as the last argument to crop.
    cropped = img.crop(x, y, width, height, true)
    cropped.write(dest) { self.quality = quality }
  end
  
  
  def write_xml_descriptor(path, attr)
    attr = { :xmlns => 'http://schemas.microsoft.com/deepzoom/2008' }.merge attr
    
    xml = "<?xml version='1.0' encoding='UTF-8'?>" + 
          "<Image TileSize='#{attr[:tile_size]}' Overlap='#{attr[:overlap]}' " + 
            "Format='#{attr[:format]}' xmlns='#{attr[:xmlns]}'>" + 
          "<Size Width='#{attr[:width]}' Height='#{attr[:height]}'/>" + 
          "</Image>"

    open(path, "w") { |file| file.puts(xml) }
  end

  def split_to_filename_and_extension(path)
    extension = File.extname(path).gsub('.', '')
    filename  = File.basename(path, '.' + extension) 
    return filename, extension
  end 

  def valid_url?(urlStr)
    url = URI.parse(urlStr)
    Net::HTTP.start(url.host, url.port) do |http|
      return http.head(url.request_uri).code == "200"
    end
  end

  def get_image(image_path)
    image = nil

    if File.file?(image_path)
      image = Image::read(image_path).first
    elsif valid_url?(image_path)
      f = open(image_path)
      image = Image.from_blob(f.read).first
      f.close
    end

    return image
  end

end
