class User < ApplicationRecord
  belongs_to :company, :nostalgic => true
  nostalgic_attr :tel
end
