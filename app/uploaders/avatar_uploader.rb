class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :grid_fs

  version :thumb do
    process convert: 'jpg', resize_to_fill: [16, 16]
    def full_filename(for_file = nil) 
      'thumb.jpg'
    end 
  end

end
