class Book
  
  attr_accessor :title, :isbn, :author, :excerpt, :cover

  def initialize(title, isbn, author, excerpt, cover)
    @title = title
    @isbn = isbn
    @author = author
    @excerpt = excerpt
    @cover = cover
  end

end
