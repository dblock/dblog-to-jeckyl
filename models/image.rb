class Image < ActiveRecord::Base
  self.table_name = 'Image'

  has_many :post_images, foreign_key: 'Image_Id'
end
