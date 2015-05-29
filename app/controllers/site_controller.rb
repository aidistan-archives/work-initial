class SiteController < ApplicationController
  def home
    render plain: params['echostr'] if check_signature
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
