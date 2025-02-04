# app/uploaders/avatar_uploader.rb
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # デフォルト画像の設定
  def default_url
    "/images/fallback/" + [version_name, "default_avatar.png"].compact.join('_')
  end

  # アップロード後の処理
  process resize_to_fit: [800, 800]

  version :thumb do
    process resize_to_fill: [200, 200]
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end
end