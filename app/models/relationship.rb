class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # followerやfollowedというテーブルは存在しないため、class_name: "User"を用いてUserモデルを参照
end
