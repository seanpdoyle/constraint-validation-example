class Authentication
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Restorable

  attribute :username, :string
  attribute :password, :string
  attribute :session

  validates :username, presence: true
  validates :password, presence: true
  validate { errors.add(:base, :invalid) unless user.present? }

  def self.find(session)
    if (user_id = session[:user_id])
      User.find_by(id: user_id).tap { |user| session.delete(:user_id) if user.nil? }
    end
  end

  def user
    if (user = User.find_by(username: username)) && user.authenticate_password(password)
      user
    end
  end

  def save
    if valid?
      session[:user_id] = user.id
    end
  end

  def destroy
    session.delete(:user_id)
  end
end
