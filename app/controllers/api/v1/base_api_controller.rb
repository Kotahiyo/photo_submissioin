class Api::V1::BaseApiController < ApplicationController
  def current_user
    @current_user ||= Post.first
  end
end
