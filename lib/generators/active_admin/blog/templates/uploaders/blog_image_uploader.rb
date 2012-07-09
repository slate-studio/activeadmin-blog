class BlogImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    "images/blog/#{model.id}"
  end

  version :admin_thumb do
    process :resize_to_fill => [60, 40]
  end

  #process :quality => 95
end
