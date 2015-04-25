class Spree::Slide < ActiveRecord::Base

  has_attached_file :image,
                    styles: {
                      small: '',
                      large: ''
                    },
                    default_style: :large,
                    storage: :s3,
                    path: '/spree/slides/:id/:style/:basename.:extension',
                    url: ':s3_path_url',
                    convert_options: {
                      all: '-strip -auto-orient -colorspace sRGB',
                      :small => "-gravity north -thumbnail 150x150^ -extent 150x150",
                      :large => "-gravity north -thumbnail 940x800^ -extent 940x800"
                    }

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  scope :published, -> { where(published: true).order('position ASC') }

  belongs_to :product, touch: true

  def initialize(attrs = nil)
    attrs ||= {:published => true}
    super
  end

  def slide_name
    name.blank? && product.present? ? product.name : name
  end

  def slide_link
    link_url.blank? && product.present? ? product : link_url
  end

  def slide_image
    !image.file? && product.present? && product.images.any? ? product.images.first.attachment : image
  end
end
