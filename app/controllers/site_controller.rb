class SiteController < ApplicationController
  include ApplicationHelper

  protect_from_forgery :except => :home
  before_action :validate_user, except: :home
  before_action :validate_record, only: :display
  before_action :prepare_jssdk, except: :home
  layout 'mobile', except: :home

  def home
    if request.get?
      render plain: params['echostr'] if check_signature
    elsif request.post?
      render 'home', :formats => :xml if check_signature && params[:xml][:MsgType] == "text"
    end
  end

  def record
    if request.get? && @user
      @categories = Category.all
      @record = @user.records.build(category_id: @categories.first.id, sticker_id: 1)
    elsif request.post?
      @record = Record.new(record_params)
      if @record.user.id == @user.id
        @record.save
        redirect_to display_path(openid: params[:openid], record_id: @record.id)
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def display
    redirect_to root_path unless @record
  end

  private

  def check_signature
    signature = params['signature'] or return false
    timestamp = params['timestamp'] or return false
    nonce = params['nonce'] or return false

    return signature == Digest::SHA1.hexdigest([Rails.application.config.weixin.token,
      timestamp, nonce].sort.join) ? true : false
  end

  def validate_user
    # Get openid
    if params['openid'].nil? && params['code']
      params['openid'] = JSON.parse(Net::HTTP.get(URI(
        "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{
        Rails.application.config.weixin.appid }&secret=#{
        Rails.application.config.weixin.appsecret }&code=#{
        params['code'] }&grant_type=authorization_code"
      )))['openid']
    end

    # Get user
    if params['openid']
      @user = User.find_by(openid: params['openid']) ||
        User.create(openid: params['openid'])
    end
  end

  def validate_record
    if params['record_id']
      @record = Record.find(params['record_id'])
    end
  end

  def prepare_jssdk
    @config = {
      url: request.url,
      timestamp: Time.now.to_i.to_s,
      noncestr: 16.times.map {
        [0..9, 'a'..'z', 'A'..'Z'].map { |r| r.to_a }.inject(&:+).shuffle.first
      }.join,
      jsapi_ticket: get_jsapi_ticket
    }
    @config[:signature] = Digest::SHA1.hexdigest(
      @config.keys.sort.map { |k| "#{k}=#{@config[k]}" }.join('&')
    )
    @config[:appid] = Rails.application.config.weixin.appid
  end

  def record_params
    params.require(:record).permit(:user_id, :category_id, :sticker_id, :attr_val, :text, :image)
  end
end
