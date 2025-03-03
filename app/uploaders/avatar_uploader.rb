# app/uploaders/avatar_uploader.rb
class AvatarUploader < CarrierWave::Uploader::Base
  # MiniMagickライブラリを取り込み、画像編集機能を有効化
  # これにより、リサイズや変換などの画像処理操作が可能になる
  include CarrierWave::MiniMagick

  # ファイルの保存先をローカルファイルシステムに設定
  # 本番環境では、storage :fog などでクラウドストレージに変更することが多い
  storage :file

  # アップロードされたファイルの保存ディレクトリを指定
  # model.class.to_s.underscore: モデル名（例: user）
  # mounted_as: アップローダーがマウントされた属性名（例: avatar）
  # model.id: レコードのID
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 画像が存在しない場合のデフォルト画像を設定
  # コメントアウトされた元の実装
  # def default_url
  #   "/images/fallback/" + [version_name, "default_avatar.png"].compact.join('_')
  # end

  # アセットパイプラインを使用した改良版のデフォルト画像設定
  # Rails.application.assets.findなどの代わりに、より安全なhelperメソッドを使用
  def default_url
    ActionController::Base.helpers.asset_path('fallback/default_avatar.png')
  end

  # 画像アップロード後の処理設定
  # コメントアウトされた以前の実装
  # process resize_to_fit: [800, 800]

  # すべての画像をJPG形式に変換
  process convert: 'jpg'

  # 画像サイズを最大800x800に制限（アスペクト比は保持）
  process resize_to_limit: [800, 800]

  # サムネイル用の設定（コメントアウトされた以前の実装）
  # version :thumb do
  #   process resize_to_fill: [200, 200]
  # end

  # 新しいサムネイル設定
  # resize_to_fitを使用して、アスペクト比を保持しながら200x200以内に収める
  version :thumb do
    process resize_to_fit: [200, 200]
  end

  # アップロード可能なファイル拡張子を制限
  # セキュリティのため重要（悪意のあるファイルのアップロードを防止）
  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  # リサイズ処理のエラーハンドリング強化版
  # 標準のresize_to_fitメソッドをオーバーライドし、エラー処理を追加
  def resize_to_fit(*args)
    # 親クラスの同名メソッドを呼び出す
    super
  # 例外が発生した場合の処理
  rescue StandardError => e
    # エラー内容をログに記録
    Rails.logger.error "Image resize failed: #{e.message}"
    # CarrierWave固有の例外を発生させる
    raise CarrierWave::ProcessingError, 'Failed to resize image'
  end

  # 画像の向きを自動的に修正するメソッド
  # スマートフォンで撮影した画像のEXIF情報に基づく向きを補正する
  def auto_orient
    manipulate! do |image|
      # MiniMagickの機能を使って画像の向きを自動修正
      image.auto_orient
      # 処理した画像オブジェクトを返す
      image
    end
  end
end
