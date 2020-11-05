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
require "rails_helper"

RSpec.describe Image, type: :model do
  let(:pic_path) { Rails.root.join("spec/fixtures/test.jpg") }
  let(:pic) { Rack::Test::UploadedFile.new(pic_path) }

  context "画像が指定されれば" do
    it "画像がアップロードされる" do
      image = create(:image)
      expect(image).to be_valid
    end

    it "画像(複数)でもアップロードされる" do
      image = create(:image, images: [pic, pic])
      expect(image).to be_valid
    end
  end

  context "画像が指定されていないと" do
    it "エラーになる" do
      image = build(:image, images: nil)
      expect(image).to be_invalid
      expect(image.errors.messages[:images]).to eq ["can't be blank"]
    end
  end
end
