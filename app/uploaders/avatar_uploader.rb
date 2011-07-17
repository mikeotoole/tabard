# encoding: utf-8
require 'carrierwave/processing/mini_magick'
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    #"/images/fallback/" + [version_name, "default.png"].compact.join('_')
    case version_name
    when :standard
      "http://robohash.org/#{model.class.to_s.underscore}/#{model.id}.png?size=70x70"
    else
      "http://robohash.org/#{model.class.to_s.underscore}/#{model.id}.png"
    end
  end
  
  #process :resize_to_fill => [700, 700]

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end
  
  version :standard do
    process :resize_to_fill => [70,70]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
