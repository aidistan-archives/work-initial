namespace :weixin do
  desc 'Update the menu in weixin'
  task :menu do
    uri = URI.parse("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{ get_access_token }")
    req = Net::HTTP::Post.new(uri)
    req.body = File.read(Rails.root.join('lib', 'assets', 'menu.json'))
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
    p res.body
  end
end

# Weixin access token
#   expiration : 2015-05-30 02:44:56 +0800
@access_token = '9Vfz1Ljo3eJPoe8gFNll3vUJha8Ia9a4niBN61aWDrBsy1NFMC1-zyjsMsGc4snbEMQ4uYax7-9Td5RV9Hw7DE6T93IsXjgyqNYL6UOnV74'

def get_access_token
  return @access_token if @access_token

  json = JSON.parse(Net::HTTP.get(URI(
    "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{
    Rails.application.config.appid }&secret=#{
    Rails.application.config.appsecret }"
  )))

  # Check returned results
  if json['errcode']
    fail RuntimeError, json.inspect
  else
    puts <<-END_OF_DOC
# Weixin access token
#   expiration : #{ Time.now + json['expires_in'] }
@access_token = '#{ json['access_token'] }'
    END_OF_DOC
  end

  return json['access_token']
end
