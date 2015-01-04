class Topic < ActiveRecord::Base
  self.table_name = 'Topic'

  has_many :post_topics, foreign_key: 'Topic_Id'
end
