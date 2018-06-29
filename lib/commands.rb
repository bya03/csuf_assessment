require 'erb'
require 'httparty'
require 'pry'

module Commands
  @@list = []
  @@array = []
  @@dne = []

## Takes the local txt file of isbn numbers and parses it into an array by first
## checking if the list item is an ISBN and also if it exists
  def self.create_array
    file = File.open("lib/isbns.txt", "r")
    file.each do |f|
      a = f.gsub(/,/, "").chomp
      url = "https://openlibrary.org/api/books?bibkeys=ISBN:#{a}&jscmd=data&format=json"
      response = HTTParty.get(url)

      if !f.scan(/\d/).empty? && !response.empty?
        @@array << f.gsub(/,/, "").chomp
      else
        @@dne << f
      end
    end
    file.close
  end

## Takes in an array of ISBN numbers and makes an api call to OpenLibrary API -
## then takes the response and generates a Book instance for each number and
## puts them into an array of Book Instances
  def self.convert(list)
    list.each do |f|
      f.gsub(/\n/, "")
      url = "https://openlibrary.org/api/books?bibkeys=ISBN:#{f}&jscmd=data&format=json"
      response = HTTParty.get(url)
      parsed = JSON.parse(response.body)
      excerpt = (parsed['ISBN:'+f]['excerpts'])

      if excerpt.nil?
        @@list << Book.new(
          parsed['ISBN:'+f]['title'],
          f,
          parsed['ISBN:'+f]['authors'][0]['name'],
          parsed['ISBN:'+f]['cover']['large']
        )
      else
        @@list << Book.new(
          parsed['ISBN:'+f]['title'],
          f,
          parsed['ISBN:'+f]['authors'][0]['name'],
          parsed['ISBN:'+f]['cover']['large'],
          parsed['ISBN:'+f]['excerpts'][0]['text']
        )
      end
    end
  end

## Creates an HTML page with - takes one input (the filename)
  def self.generate_html(filename)
    template = ERB.new(File.read("lib/skeleton.erb"))

    html_content = template.result(binding)

    File.open(filename, "w+") do |f|
      f.puts html_content
    end
  end

  def self.list
    @@list
  end

  def self.isbn_array
    @@array
  end

  def self.dne
    @@dne
  end

end
