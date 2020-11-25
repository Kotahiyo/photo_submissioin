class Api::V1::ImageSerializer < ActiveModel::Serializer
  attributes :id, :images
  belongs_to :post
end
