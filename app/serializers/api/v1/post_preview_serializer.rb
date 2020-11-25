class Api::V1::PostPreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at
  belongs_to :user, serializer: Api::V1::UserSerializer
  has_many :images, serializer: Api::V1::ImageSerializer
end
