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
      expect(res[0]["images"][0].keys).to eq ["id", "images"]
    end
  end

  describe "GET /posts/:id" do
    subject { get(api_v1_post_path(post_id)) }
    context "指定した ID の投稿が存在する時" do
      let(:post) { create(:post) }
      let(:post_id) { post.id }
      it "投稿の詳細が表示できる" do
        expect { subject }.to change { Image.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["id"]).to eq post.id
        expect(res["title"]).to eq post.title
        expect(res["body"]).to eq post.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq post.user_id
        expect(res["user"].keys).to eq ["id", "email", "name"]
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "Post /post" do
    subject { post(api_v1_posts_path, params: params, headers: headers) }

    let(:params) { { post: attributes_for(:post) } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

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

  describe "Patch /posts/:id" do
    subject { patch(api_v1_post_path(post.id), params: params, headers: headers) }

    let(:params) { { post: attributes_for(:post) } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分の作成した記事を更新しようとした時" do
      let(:post) { create(:post, user: current_user) }
      it "記事を更新できる" do
        expect { subject }.to change { post.reload.title }.from(post.title).to(params[:post][:title]) &
                              change { post.reload.body }.from(post.body).to(params[:post][:body])
        expect(response).to have_http_status(:ok)
      end
    end

    context "他人の作成した記事を更新しようとした時" do
      let(:other_user) { create(:user) }
      let!(:post) { create(:post, user: other_user) }
      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Post.count }.by(0)
      end
    end
  end

  describe "Delete /posts/id" do
    subject { delete(api_v1_post_path(post_id), headers: headers) }

    let(:current_user) { create(:user) }
    let(:post_id) { post.id }
    let(:headers) { current_user.create_new_auth_token }

    context "自分の記事を削除しようとする時" do
      let!(:post) { create(:post, user: current_user) }
      it "任意の記事が削除できる" do
        expect { subject }.to change { Post.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "他人の記事を削除しようとする時" do
      let(:other_user) { create(:user) }
      let!(:post) { create(:post, user: other_user) }
      it "削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Post.count }.by(0)
      end
    end
  end
end
