# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Tag, type: :model do
  context "指定のカラム name を入力したら" do
    it "タグが作成される" do
      tag = build(:tag)
      expect(tag).to be_valid
    end
  end

  context "指定のカラム name を入力しないと" do
    it "タグの作成に失敗する" do
      tag = build(:tag, name: nil)
      expect(tag).to be_invalid
      expect(tag.errors.messages[:name]).to eq ["can't be blank"]
    end
  end

end
