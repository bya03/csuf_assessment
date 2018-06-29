require 'erb'
require 'httparty'

module Commands
  @@list = []
  @@array = []
  @@dne = []

## Takes the local txt file of isbn numbers and parses it into an array
  def self.create_array
    file = File.open("lib/isbns.txt", "r")
    file.each do |f|
      if !f.scan(/\d/).empty?
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
      response != "{}" ? parsed = JSON.parse(response.body) : @@dne << f

      @@list << Book.new(
        parsed['ISBN:'+f]['title'],
        f,
        parsed['ISBN:'+f]['authors'][0]['name'],
        parsed['ISBN:'+f]['cover']['large'],
        parsed['ISBN:'+f]['excerpts'][0]['text']
      )
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
