# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Post, type: :model do
  context "指定のカラム title を入力したら" do
    let(:post) { build(:post) }
    it "投稿ができる" do
      expect(post).to be_valid
    end
  end

  context "指定のカラム title を入力しないと" do
    let(:post) { build(:post, title: nil) }
    it "エラーになる" do
      expect(post).to be_invalid
      expect(post.errors.messages[:title]).to eq ["can't be blank"]
    end
  end
end
