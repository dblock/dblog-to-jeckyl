class Post < ActiveRecord::Base
  self.table_name = 'Post'

  has_many :post_topics, foreign_key: 'Post_Id'

  def topics
    post_topics.map { |pt| pt.topic.Name }
  end
end
