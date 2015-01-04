class PostImage < ActiveRecord::Base
  self.table_name = 'PostImage'
  belongs_to :image, foreign_key: 'Image_Id'
  belongs_to :post, foreign_key: 'Post_Id'
end
