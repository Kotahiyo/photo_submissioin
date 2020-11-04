require "rails_helper"

RSpec.describe User, type: :model do
  context "指定のカラム name を入力したら" do
    it "ユーザーが作られる" do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  context "指定のカラム name を入力しないと" do
    it "ユーザー作成に失敗する" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors.messages[:name]).to eq ["can't be blank"]
    end
  end

  context "すでに同じ name が存在しても" do
    before { create(:user, name: "foo") }

    it "エラーにならない" do
      user = build(:user, name: "foo")
      expect(user).to be_valid
    end
  end
end
