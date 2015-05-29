module ApplicationHelper
  def get_access_token
    if Time.now.to_i >= Rails.application.config.weixin.access_token_expires_in
      json = JSON.parse(Net::HTTP.get(URI(
        "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{
        Rails.application.config.weixin.appid }&secret=#{
        Rails.application.config.weixin.appsecret }"
      )))

      # Check returned results
      if json['errcode']
        fail RuntimeError, json.inspect
      else
        Rails.application.config.weixin.access_token = json['access_token']
        Rails.application.config.weixin.access_token_expires_in = Time.now.to_i + json['expires_in']

        puts <<-END_OF_DOC
=== Weixin access token updated ===
config.weixin.access_token = #{ json['access_token'].inspect }
config.weixin.access_token_expires_in = #{ Time.now.to_i + json['expires_in'] } # #{ Time.now + json['expires_in'] }
        END_OF_DOC
      end
    end

    Rails.application.config.weixin.access_token
  end
end
