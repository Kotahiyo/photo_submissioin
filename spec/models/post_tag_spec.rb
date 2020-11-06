# == Schema Information
#
# Table name: post_tags
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  tag_id     :bigint           not null
#
# Indexes
#
#  index_post_tags_on_post_id  (post_id)
#  index_post_tags_on_tag_id   (tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (tag_id => tags.id)
#
require "rails_helper"

RSpec.describe PostTag, type: :model do
  context "post 作成。tag 登録すると" do
    let(:post_tag) { create(:post_tag) }
    it "post と tag のリレーションが設定される" do
      expect(post_tag).to be_valid
    end
  end
end
