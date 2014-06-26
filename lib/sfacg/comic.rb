require 'sfacg/chapter'
module Sfacg
  class Comic
    def initialize url
      @uri = URI(url)
      @comic_name = url[/\/([^\/]*)\/?$/, 1]
    end

    def download to: '.'
      doc = Nokogiri::HTML(Net::HTTP.get(@uri))
      doc.css('ul.serialise_list.Blue_link2 li>a').each do |link|
        chapter_uri = URI.join(@uri, link['href'])
        chapter_name = File.basename(chapter_uri.to_s)
        Chapter.new(chapter_uri).download to: File.join(to, "#{@comic_name}/#{chapter_name}")
      end
    end
  end
end