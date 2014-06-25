require 'nokogiri'
require 'net/http'
require 'therubyracer'
require 'fileutils'

class Chapter
  def initialize url
    @uri = URI(url)
  end

  def js_uri
    return @js_uri if @js_uri
    chapter = @uri.to_s[/\/([^\/]*)\/?$/, 1]
    doc = Nokogiri::HTML(Net::HTTP.get(@uri))
    @js_uri = URI.join(@uri, doc.at_css("script[src*=\"#{chapter}\"]")['src'])
  end

  def images
    return @images if @images
    cxt = V8::Context.new
    cxt.eval(Net::HTTP.get(js_uri))
    @hosts = cxt['hosts']
    @images = cxt['picAy'].map{|path| URI.join(@hosts.first, path)}
  end

  def download to: '.'
    FileUtils::mkdir_p to
    images.each_with_index do |img_uri, i|
      file_name = "#{i}#{File.extname(img_uri.to_s)}"
      file_path = File.join(to, file_name)
      print "#{img_uri} -> #{file_path}..."
      begin
        File.write file_path, Net::HTTP.get(img_uri)
        puts 'downloaded'
      rescue => e
        puts "#{e} #{e.message}"
      end
    end
  end
end

class Comic
  def initialize url
    @uri = URI(url)
    @comic_name = url[/\/([^\/]*)\/?$/, 1]
  end

  def download_all
    doc = Nokogiri::HTML(Net::HTTP.get(@uri))
    doc.css('ul.serialise_list.Blue_link2 li>a').each do |link|
      chapter_uri = URI.join(@uri, link['href'])
      chapter_name = File.basename(chapter_uri.to_s)
      Chapter.new(chapter_uri).download to: "#{@comic_name}/#{chapter_name}"
    end
  end
end

Comic.new('http://comic.sfacg.com/HTML/OnePiece/').download_all