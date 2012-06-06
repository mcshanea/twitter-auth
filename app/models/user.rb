class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :rememberable,:omniauthable
  has_many :authentications
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :nickname, :name, :remember_me

  def async_create_edition
    Resque.enqueue(Edition, self.id)
  end
  
  def self.find_for_twitter_oauth(omniauth)
    authentication = Authentication.find_by_provider_and_uuid(omniauth['provider'], omniauth['uid'])
    if authentication && authentication.user
      authentication.user
    else
      user = User.create!(:nickname => omniauth['info']['nickname'], 
                            :name => omniauth['info']['name'])
      user.authentications.create!(:provider => omniauth['provider'], :uuid => omniauth['uid'],
                                    :token => (omniauth['credentials']['token'] rescue nil),
                                    :secret => (omniauth['credentials']['secret'] rescue nil))
      user.save
      user
    end
  end

  def twitter
    unless @twitter_user
      provider = self.authentications.find_by_provider('twitter')
      p provider
      @twitter_user = Twitter::Client.new(:oauth_token => provider.token, :oauth_token_secret => provider.secret) rescue nil
    end
    @twitter_user
  end

  protected

def apply_twitter(omniauth)
  if (extra = omniauth['extra']['user_hash'] rescue false)
    # Example fetching extra data. Needs migration to User model:
    # self.firstname = (extra['name'] rescue '')
  end
end

def hash_from_omniauth(omniauth)
  {
    :provider => omniauth['provider'],
    :uid => omniauth['uid'],
    :token => (omniauth['credentials']['token'] rescue nil),
    :secret => (omniauth['credentials']['secret'] rescue nil)
  }
end

end
