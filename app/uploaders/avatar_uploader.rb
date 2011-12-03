# encoding: utf-8
require 'carrierwave/processing/mini_magick'
###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
#
# This uploader is for handling the uploading of avatar using carrier wave.
###
class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

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
    when :large
      # "http://robohash.org/#{model.class.to_s.underscore}/#{model.id}.png?size=240x240"
      'application/avatar@240.png'
    when :small
      # "http://robohash.org/#{model.class.to_s.underscore}/#{model.id}.png?size=60x60"
      'application/avatar@60.png'
    when :tiny
      # "http://robohash.org/#{model.class.to_s.underscore}/#{model.id}.png?size=40x40"
      'application/avatar@40.png'
    when :icon
      # "http://robohash.org/#{model.class.to_s.underscore}/#{model.id}.png?size=20x20"
      'application/avatar@20.png'
    else
      # "http://robohash.org/#{model.class.to_s.underscore}/#{model.id}.png"
      'application/blank.gif'
    end
  end

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
  version :large do
    process :resize_to_fill => [240,240]
  end
  version :small do
    process :resize_to_fill => [60,60]
  end
  version :tiny do
    process :resize_to_fill => [40,40]
  end
  version :icon do
    process :resize_to_fill => [20,20]
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
