class SearchesController < ApplicationController
  def search
    keyword = params[:keyword]
    @search_type = params[:search_type]
    match_type = params[:match_type]

    case match_type
    when 'exact'
      query = keyword
    when 'forward'
      query = "#{keyword}%"
    when 'backward'
      query = "%#{keyword}"
    when 'partial'
      query = "%#{keyword}%"
    end

    case @search_type
    when 'User'
      @results = User.where('name LIKE ?', query)
    when 'Book'
      @results = Book.where('title LIKE ?', query)
    end
  end
end
