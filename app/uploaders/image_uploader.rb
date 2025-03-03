# app/uploaders/image_uploader.rb
class ImageUploader < CarrierWave::Uploader::Base
  # MiniMagickを使用して画像処理機能を追加
  # これにより、リサイズやクロップなどの操作が可能になる
  include CarrierWave::MiniMagick

  # ファイルの保存先をローカルファイルシステムに設定
  # 本番環境ではS3などのクラウドストレージに変更することが多い
  # その場合は `storage :fog` などに変更する
  storage :file

  # アップロードしたファイルの保存先ディレクトリを指定
  # model.class.to_s.underscore: モデル名（例: food_post）
  # mounted_as: アップローダーがマウントされた属性名（例: image）
  # model.id: レコードのID
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 画像がアップロードされていない場合のデフォルト画像を設定
  # アセットパイプラインを使用してデフォルト画像のパスを取得
  def default_url
    ActionController::Base.helpers.asset_path('fallback/default_food_image.png')
  end

  # 画像のアップロード後に実行される処理
  # convert: 'jpg' - すべての画像をJPG形式に変換
  process convert: 'jpg'
  # resize_to_limit - 指定サイズを超える場合のみリサイズ（アスペクト比を維持）
  process resize_to_limit: [1200, 1200]
  # auto_orient - 画像の向きを自動的に修正（スマホで撮影した写真などで重要）
  process :auto_orient

  # サムネイルバージョンの作成（一覧表示などで使用）
  # resize_to_fill - 指定サイズにぴったり合わせる（必要に応じてクロップする）
  version :thumb do
    process resize_to_fill: [300, 200]
  end

  # 中サイズバージョンの作成（詳細表示などで使用）
  # resize_to_fit - アスペクト比を維持しながら指定サイズ内に収める
  version :medium do
    process resize_to_fit: [600, 400]
  end

  # アップロード可能なファイル拡張子を制限
  # セキュリティ上重要（悪意のあるファイルのアップロードを防止）
  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  # 画像の向きを自動的に修正するメソッド
  # スマホで撮った写真などはEXIF情報に基づいて回転が必要なことがある
  def auto_orient
    manipulate! do |image|
      image.auto_orient
      image
    end
  # エラーハンドリング - 画像処理中に問題が発生した場合
  rescue StandardError => e
    # エラーをログに記録
    Rails.logger.error "Image resize failed: #{e.message}"
    # 処理エラーとして例外を発生させる
    raise CarrierWave::ProcessingError, 'Failed to resize image'
  end
end
