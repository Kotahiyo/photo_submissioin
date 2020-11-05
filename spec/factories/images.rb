# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  images     :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#
# Indexes
#
#  index_images_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
FactoryBot.define do
  factory :image do
    images { [Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test_2.jpg"))] }
    post
  end
end
