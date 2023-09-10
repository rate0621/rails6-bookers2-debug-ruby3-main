
class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @comment = @book.book_comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      # エラーメッセージを表示するなどの処理
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @comment = current_user.book_comments.find(params[:id])

    if @comment.destroy
      redirect_back(fallback_location: root_path)
    else
      # エラーメッセージを表示するなどの処理
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.require(:book_comment).permit(:content)
  end

end
