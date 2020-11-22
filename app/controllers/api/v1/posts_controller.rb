module Api::V1
  class PostsController < BaseApiController
    def index
      posts = Post.order(updated_at: :desc)

      render json: posts, each_serializer: Api::V1::PostPreviewSerializer
    end

    def create
      post = current_user.posts.create!(post_params)
      render json: post
    end

    private

      def post_params
        params.require(:post).permit(:title, :body)
      end
  end
end
