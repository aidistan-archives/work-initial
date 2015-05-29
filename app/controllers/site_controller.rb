class SiteController < ApplicationController
  protect_from_forgery :except => :home

  def home
    if request.get?
      render plain: params['echostr'] if check_signature
    elsif request.post?
      render 'home', :formats => :xml if check_signature && params[:xml][:MsgType] == "text"
    end
  end

  private

  def check_signature()
    signature = params['signature'] or return false
    timestamp = params['timestamp'] or return false
    nonce = params['nonce'] or return false

    if (signature == Digest::SHA1.hexdigest(
      [Rails.application.config.token, timestamp, nonce].sort.join
    ))
      return true
    else
      return false
    end
  end
end
