class User < ActiveRecord::Base
  belongs_to :company, :nostalgic => true
  nostalgic_attr :tel
end
