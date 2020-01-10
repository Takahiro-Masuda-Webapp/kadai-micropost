class User < ApplicationRecord
    before_save { self.email.downcase! }
    has_secure_password
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      uniqueness: { case_sensitive: false } 
                      
    has_many :microposts 
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverses_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationships, source: :user
    has_many :favorites
    has_many :approvings, through: :favorites, source: :micropost
    
    def follow(other_user)
      unless self == other_user
        self.relationships.find_or_create_by(follow_id: other_user.id)
      end
    end
    
    def unfollow(other_user)
      relationship = self.relationships.find_by(follow_id: other_user.id)
      relationship.destroy if relationship
    end
    
    def following?(other_user)
      self.followings.include?(other_user)
    end
    
    def approve(other_micropost)
      self.favorites.find_or_create_by(micropost_id: other_micropost.id)
    end
  
    def disapprove(other_micropost)
      favorite = self.favorites.find_by(micropost_id: other_micropost.id)
      favorite.destroy if favorite
    end
  
    def approving?(other_micropost)
      self.approvings.include?(other_micropost)
    end
end
