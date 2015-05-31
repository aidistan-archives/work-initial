require 'net/http'

class SiteController < ApplicationController
  include ApplicationHelper

  protect_from_forgery :except => [:home, :explore]
  before_action :validate_user, except: :home
  before_action :validate_record, only: :display
  before_action :prepare_jssdk, except: :home
  layout 'mobile', except: :home

  def home
    if request.get?
      render plain: params['echostr'] if check_signature
    elsif request.post?
      if check_signature
        case params[:xml][:MsgType]
        when 'text'
          @content = %w(阮嘟嘟 郭逗逗 谭噜噜).shuffle.first + '收到！'
          render 'home', :formats => :xml
        when 'event'
          case params[:xml][:Event]
          when 'subscribe'
            @content = <<-END_OF_DOC
在这个世界上，每个人都独一无二
在你的一生中，每个第一次都值得去铭记
何不记录下那些，让你激情不已，亦或是终生难忘的第一次呢？

点击【记录】，记录你的第一次
点击【探索】，看看别人的“第一次”有没有给你一些灵感
点击【回忆】，翻阅自己的回忆，回忆那些我们曾一起记录下的“第一次”

直接回复文字，给我们提出改进意见，您的支持将是我们前进的巨大动力
            END_OF_DOC
            render 'home', :formats => :xml
          end
        end
      end
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
        redirect_to display_path(openid: @user.openid, record_id: @record.id)
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

  def explore
    redirect_to root_path unless @user
    if request.post?
      @records = Record.all
      @record = @records[rand @records.size]
      redirect_to display_path(openid: @user.openid, record_id: @record.id, from_explore: '1')
    end
  end

  def timeline
    redirect_to root_path unless @user
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
