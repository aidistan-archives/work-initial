require Rails.root.join('app', 'helpers', 'application_helper')

namespace :weixin do
  include ApplicationHelper

  desc 'Update the menu in weixin'
  task :menu do
    uri = URI.parse("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{ get_access_token }")
    req = Net::HTTP::Post.new(uri)
    req.body = File.read(Rails.root.join('lib', 'assets', 'menu.json'))
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
    puts JSON.parse(res.body).to_yaml
  end
end
