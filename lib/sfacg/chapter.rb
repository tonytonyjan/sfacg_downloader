require 'nokogiri'
require 'open-uri'
require 'fileutils'

module Sfacg
  class Chapter
    SF_HOST = 'http://hotpic.sfacg.com/'.freeze
    def initialize url
      @uri = URI(url)
      @js_uri = @images = nil
    end

    def js_uri
      return @js_uri if @js_uri
      chapter_number = @uri.to_s[/\/([^\/]*)\/?$/, 1]
      doc = Nokogiri::HTML(open(@uri))
      @js_uri = @uri.merge(doc.at_css("script[src*=\"#{chapter_number}.js\"]")['src'])
    end

    def images
      return @images if @images
      js = open(js_uri).read
      @hosts = js[/hosts\s*=\s*\[([^\]]*)\]/, 1].gsub(/[\s"']/, '').split(',')
      @images = js.scan(/picAy\[\d+\]\s*=\s*"([^"]*)"/).map{|pattern| URI.join(@hosts.first, pattern.first)}
    end

    def download options = {to: '.'}
      to = options[:to]
      FileUtils::mkdir_p to
      threads = []
      images.each_with_index do |img_uri, i|
        threads << Thread.new{
          file_name = "#{i}#{File.extname(img_uri.to_s)}"
          file_path = File.join(to, file_name)
          begin
            Net::HTTP.start(img_uri.host, img_uri.port, read_timeout: 5) do |http|
              File.write file_path, open(img_uri, 'Referer' => SF_HOST).read, mode: 'wb'
              puts "#{img_uri} -> #{file_path}"
            end
          rescue
            $stderr.puts "#{img_uri} -> #{file_path}", $!.inspect, $@
          end
        }
      end
      threads.each(&:join)
    rescue
      $stderr.puts $!.inspect, $@
    end
  end
end
