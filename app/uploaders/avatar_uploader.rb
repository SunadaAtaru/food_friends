# app/uploaders/avatar_uploader.rb
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # デフォルト画像の設定
  # def default_url
  #   "/images/fallback/" + [version_name, "default_avatar.png"].compact.join('_')
  # end
  def default_url
    ActionController::Base.helpers.asset_path('fallback/default_avatar.png')
  end
  
  # アップロード後の処理
  # process resize_to_fit: [800, 800]
  process convert: 'jpg'
  process resize_to_limit: [800, 800]

  # version :thumb do
  #   process resize_to_fill: [200, 200]

  # end

  # サムネイルも単純化
  version :thumb do
    process resize_to_fit: [200, 200]
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  def resize_to_fit(*args)
    super
  rescue => e
    Rails.logger.error "Image resize failed: #{e.message}"
    raise CarrierWave::ProcessingError, "Failed to resize image"
  end

  # 画像処理の設定を追加
  def auto_orient
    manipulate! do |image|
      image.auto_orient
      image
    end
  end
end