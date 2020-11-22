require "rails_helper"

RSpec.describe "Api::V1::Posts", type: :request do
  describe "GET /post" do
    subject { get(api_v1_posts_path) }
    let!(:post1) { create(:post) }
    let!(:post2) { create(:post, updated_at: 3.days.ago) }
    let!(:post3) { create(:post, updated_at: 1.days.ago) }
    it "投稿の一覧が表示できる" do
      subject
      res = JSON.parse(response.body)
      expect(res[0]["id"]).to eq post1.id
      expect(res[0]["title"]).to eq post1.title
      expect(res.length).to eq 3
      expect(response).to have_http_status(:ok)
      expect(res.map {|d| d["id"] }).to eq [post1.id, post3.id, post2.id]
      expect(res[0]["user"].keys).to eq ["id", "email", "name"]
    end
  end

  describe "Post /post" do
    subject { post(api_v1_posts_path, params: params) }

    let(:params) { { post: attributes_for(:post) } }
    let(:current_user) { create(:user) }

    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "適切なパラメータを渡した時 " do
      it "記事が作成される。" do
        expect { subject }.to change { Post.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:post][:title]
        expect(res["body"]).to eq params[:post][:body]
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
