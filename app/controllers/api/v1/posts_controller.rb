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

    def update
      post = current_user.posts.find(params[:id])
      post.update!(post_params)
      render json: post
    end

    def destroy
      post = current_user.posts.find(params[:id])
      post.destroy!
    end

    private

      def post_params
        params.require(:post).permit(:title, :body)
      end
  end
end
