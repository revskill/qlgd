class Survey < ActiveRecord::Base
  attr_accessible :name
  has_many :questions, :dependent => :destroy
end
