class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
  end




  private

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user_id == current_user.id
      redirect_to books_path, alert: "You don't have permission to edit this book."
    end
end

end