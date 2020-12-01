require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "Post /v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }
    context "登録済みのユーザーの情報を送信した時" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }
      it "ログインできる" do
        subject
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "email が一致していない時" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: "hoge", password: user.password) }
      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(res["errors"]).to eq ["Invalid login credentials. Please try again."]
        expect(res["access-token"]).to be_blank
        expect(res["client"]).to be_blank
        expect(res["expiry"]).to be_blank
      end
    end

    context "password が一致していない時" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: "hoge") }
      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(res["errors"]).to eq ["Invalid login credentials. Please try again."]
        expect(res["access-token"]).to be_blank
        expect(res["client"]).to be_blank
        expect(res["expiry"]).to be_blank
      end
    end
  end

  describe "Delete /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }
    context "ログインしているユーザーがログアウト処理をすると" do
      let(:user) { create(:user) }
      let!(:headers) { user.create_new_auth_token }
      it "ログアウトする" do
        subject
        res = JSON.parse(response.body)
        expect(res["access-token"]).to be_blank
        expect(res["client"]).to be_blank
        expect(res["expiry"]).to be_blank
      end
    end

    context "誤った情報を送信した時" do
      let(:user) { create(:user) }
      let!(:token) { user.create_new_auth_token }
      let!(:headers) { { "access-token" => "", "token-type" => "", "client" => "", "expiry" => "", "uid" => "" } }
      it "ログアウトできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to eq ["User was not found or was not logged in."]
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
