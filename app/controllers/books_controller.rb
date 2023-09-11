class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :new, :create, :edit, :update, :destroy]  # 余計なアクションがあるかも

  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @book = Book.new
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
  end

  def index
    @books = Book.all
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user # ログイン中のユーザーをbookのuserとして設定

    if @book.save
      @new_book = Book.new
      redirect_to @book, notice: 'Book was successfully created.'
    else
      # エラーメッセージを表示して、ユーザーに問題を修正する機会を与えます。
      # indexアクションの@books変数も設定する必要があります
      @books = Book.all
      render :index
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, notice: 'Book was successfully destroyed.'
  end


  private

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user_id == current_user.id
      redirect_to books_path, alert: "You don't have permission to edit this book."
    end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end


end