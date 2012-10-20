###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for sent messages.
###
class SentMessagesController < MailboxController
  respond_to :html, :js
  layout 'messaging'
###
# Callbacks
###
  before_filter :block_unauthorized_user!

  # GET /mail/sent(.:format)
  def index
    @messages = current_user.sent_messages.sort_by!{|m| m.created_at}.reverse!
    @mailbox_view_state = 'sent'
    respond_with(@messages)
  end

  # GET /mail/sent/:id(.:format)
  def show
    @message = current_user.sent_messages.find(params[:id])
    authorize!(:read, @message)
    @mailbox_view_state = 'sent'
    respond_to do |format|
      format.html { render :show }
      format.js {
        render partial: 'messages/message', locals: { message: @message }
      }
    end
  end

  # GET /mail/compose(.:format)
  def new
    to = ((params[:id] && current_user.address_book.collect{ |p| p.id.to_s }.flatten.include?(params[:id])) ? [params[:id]] : [])
    @message = current_user.sent_messages.build(to: to)
    authorize!(:create, @message)
    @mailbox_view_state = 'compose'
    respond_with(@message)
  end

  # POST /sent(.:format)
  def create
    params[:message][:to].uniq! unless params[:message][:to].blank?
    @message = current_user.sent_messages.build(params[:message])
    authorize!(:create, @message)
    if @message.save
      flash[:success] = "Your message has been sent."
      redirect_to inbox_path
    else
      if @message.to.blank?
        errors = Array.new
        @message.errors.each{|attr,msg| errors << {attr: attr, msg: msg}}
        @message = current_user.sent_messages.build(to: [-1], subject: @message.subject, body: @message.body)
        errors.each{ |error| @message.errors.add(error[:attr],error[:msg]) }
        flash[:alert] = "You need at least one valid recipient"
      end
      render 'new'
    end
  end

  # GET /sent/autocomplete(.:format)
  def autocomplete
    @user_profiles = current_user.address_book.active.search params[:term]
    @character_proxies = CharacterProxy.search(params[:term]) & CharacterProxy.includes(:user_profile).where(user_profile_id: current_user.address_book.active)
    render json:
      @user_profiles.map{|up| {
        label: "<a>#{view_context.image_tag(view_context.image_path(up.avatar_url(:icon)))} <strong>#{up.display_name}</strong></a>",
        value: up.id,
        html: render_to_string(partial: 'to', locals: {user_profile: up}),
        display_name: up.display_name
      }} +
      @character_proxies.map{|cp| {
        label: "<a>#{view_context.image_tag(view_context.image_path(cp.avatar_url(:icon)))} <strong>#{cp.name}</strong> (#{cp.user_profile_display_name})</a>",
        value: cp.user_profile_id,
        html: render_to_string(partial: 'to', locals: {user_profile: cp.user_profile}),
        display_name: cp.user_profile_display_name
      }}
  end

end
