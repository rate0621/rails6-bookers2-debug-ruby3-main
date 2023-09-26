class MessagesController < ApplicationController

  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id
    @receiver = User.find(params[:message][:receiver_id])

    if @message.save
      puts 'success'
      # メッセージの保存に成功した場合の処理
      redirect_to messages_path, notice: 'Message was successfully sent.'
    else
puts @message.errors.full_messages
      # メッセージの保存に失敗した場合の処理
      render :new
    end
  end

  def index
    # 現在のユーザーと相互にフォローしているユーザーのIDを取得
  following_ids = current_user.following.pluck(:id)
  follower_ids = current_user.followers.pluck(:id)

  mutual_followers_ids = following_ids & follower_ids

  @messages = Message.where(sender_id: mutual_followers_ids, receiver_id: current_user.id)
                     .or(Message.where(sender_id: current_user.id, receiver_id: mutual_followers_ids))

  end

  def select_recipient
    @mutual_followers = current_user.following & current_user.followers
  end

  def new
    @message = Message.new
    @recipient = User.find(params[:recipient_id]) if params[:recipient_id].present?
  end

  def conversation
    @partner = User.find(params[:id])
    @messages = Message.where(sender_id: [current_user.id, @partner.id], receiver_id: [current_user.id, @partner.id]).order(created_at: :asc)
  end


  private

  def message_params
    params.require(:message).permit(:content, :receiver_id)
  end

end
