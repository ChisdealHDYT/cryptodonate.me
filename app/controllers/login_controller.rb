class LoginController <  Devise::OmniauthCallbacksController

  def mixer
    login_with_oauth(:mixer)
  end

  def twitch
    # https://github.com/CrosseyeJack/omniauth-twitch/commit/36f40cf83407d2c6703f3b9a6f95e653a58c8444
    login_with_oauth(:twitch)
  end


  def streamelements
    binding.pry
  end

  private

  def login_with_oauth(provider)
    streamer_by_oauth(provider)
    sign_in(@streamer)
    redirect_to internal_root_path
  end

  def streamer_by_oauth(provider)
    hash = request.env["omniauth.auth"]
    @streamer = Streamer.by_oauth(hash) || Streamer.create do |u|
      u.provider = hash["provider"]
      u.uid = hash["uid"]
      u.name = hash["info"]["name"]
      u.email = hash["info"]["email"]
      u.url = hash["info"]["urls"][provider.to_s.capitalize]
      u.token = hash["credentials"]["token"]
      u.refresh_token = hash["credentials"]["refresh_token"]
    end
  end
end
