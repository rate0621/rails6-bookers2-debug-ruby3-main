class MessagesController < ApplicationController
  def create
    @receiver = User.find(params[:receiver_id])

    # 相互にフォローしているかの確認
    if current_user.following?(@receiver) && @receiver.following?(current_user)
      @message = current_user.sent_messages.build(message_params)
      @message.receiver = @receiver

      if @message.save
        # 保存に成功した場合の処理
        redirect_to messages_path(receiver_id: @receiver.id)
      else
        # 保存に失敗した場合の処理
        render :new
      end
    else
      # 相互にフォローしていない場合の処理
      redirect_to root_path, alert: "You can only send messages to mutual followers."
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


  private

  def message_params
    params.require(:message).permit(:content)
  end

end
