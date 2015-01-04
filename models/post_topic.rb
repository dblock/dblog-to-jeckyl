class PostTopic < ActiveRecord::Base
  self.table_name = 'PostTopic'
  belongs_to :topic, foreign_key: 'Topic_Id'
  belongs_to :post, foreign_key: 'Post_Id'
end
