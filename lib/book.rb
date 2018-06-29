class Book

  attr_accessor :title, :isbn, :author, :excerpt, :cover

  def initialize(title, isbn, author, cover, excerpt = "No excerpt found")
    @title = title
    @isbn = isbn
    @author = author
    @cover = cover
    @excerpt = excerpt
  end

end
