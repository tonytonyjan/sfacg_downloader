require 'nokogiri'
require 'net/http'
require 'therubyracer'
require 'fileutils'

module Sfacg
  class Chapter
    def initialize url
      @uri = URI(url)
    end

    def js_uri
      return @js_uri if @js_uri
      chapter = @uri.to_s[/\/([^\/]*)\/?$/, 1]
      doc = Nokogiri::HTML(Net::HTTP.get(@uri))
      @js_uri = URI.join(@uri, doc.at_css("script[src*=\"#{chapter}.js\"]")['src'])
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
      threads = []
      images.each_with_index do |img_uri, i|
        threads << Thread.new{
          file_name = "#{i}#{File.extname(img_uri.to_s)}"
          file_path = File.join(to, file_name)
          begin
            Net::HTTP.start(img_uri.host, img_uri.port, read_timeout: 5) do |http|
              response = http.request(Net::HTTP::Get.new(img_uri))
              File.write file_path, response.body
              puts "#{img_uri} -> #{file_path}"
            end
          rescue => e
            puts "#{e} #{e.message} #{img_uri} -> #{file_path}"
          end
        }
      end
      threads.each &:join
    end
  end
end