class FavoritesController < ApplicationController
  # def create
  #   @favorite = current_user.favorites.build(book_id: params[:book_id])
  #   if @favorite.save
  #     # 成功時の処理
  #     puts 'success!!!'
  #   else
  #     # 失敗時の処理
  #     puts 'failed!!!!!'
  #     puts @favorite.errors.full_messages.join(", ")
  #   end
  #   redirect_to request.referer || root_url

  #   # favorite = current_user.favorites.create(book_id: params[:book_id])
  #   # redirect_back(fallback_location: root_path)
  # end

  # def destroy
  #   begin
  #     puts 'aaaa'
  #     puts params[:id]
  #     puts 'bbbb'
  #     favorite = current_user.favorites.find_by!(book_id: params[:id])
  #     favorite.destroy!
  #     puts "Successfully removed favorite."
  #   rescue ActiveRecord::RecordNotFound
  #     puts "Favorite not found."
  #   rescue ActiveRecord::RecordNotDestroyed => e
  #     puts "Could not remove favorite: #{e.record.errors.full_messages.join(", ")}"
  #   end
  #   redirect_to request.referer || root_url

  # end
  def create
    @book = Book.find(params[:book_id])
    current_user.favorite(@book)
    respond_to do |format|
      format.html { redirect_to @book }
      format.js
    end
  end

  def destroy
    @book = Book.find(params[:id])
    current_user.unfavorite(@book)
    respond_to do |format|
      format.html { redirect_to @book }
      format.js
    end
  end

end
