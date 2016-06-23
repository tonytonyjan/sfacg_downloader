# frozen_string_literal: true
require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'english'

module Sfacg
  class Chapter #:nodoc:
    SF_HOST = 'http://hotpic.sfacg.com/'.freeze

    def initialize(url)
      @uri = URI(url)
    end

    def chapter_number
      @chapter_number ||= @uri.to_s[%r{/([^/]*)/?$}, 1]
    end

    def js_uri
      @js_uri ||= (
        doc = Nokogiri::HTML(open(@uri))
        script = doc.at_css("script[src*=\"#{chapter_number}.js\"]")
        @uri.merge(script['src'.freeze])
      )
    end

    def js
      @js ||= open(js_uri).read
    end

    def hosts
      @hosts ||= js[/hosts\s*=\s*\[([^\]]*)\]/, 1].gsub(/[\s"']/, ''.freeze)
                                                  .split(','.freeze)
    end

    def images
      @images ||= (
        js.scan(/picAy\[\d+\]\s*=\s*"([^"]*)"/)
          .map { |pattern| URI.join(hosts.first, pattern.first) }
      )
    end

    def download(options = { to: '.' })
      to = options[:to]
      FileUtils.mkdir_p to
      threads = []
      images.each_with_index do |img_uri, i|
        threads << build_thread(img_uri, i, to)
      end
      threads.each(&:join)
    rescue
      $stderr.puts $ERROR_INFO.inspect, $ERROR_POSITION
    end

    def build_thread(img_uri, idx, dir_path)
      Thread.new do
        file_name = "#{idx}#{File.extname(img_uri.to_s)}"
        file_path = File.join(dir_path, file_name)
        download_to img_uri, file_path
      end
    end

    def download_to(src, path)
      File.write path,
                 open(src, 'Referer' => SF_HOST).read,
                 mode: 'wb'
      puts "#{src} -> #{path}"
    rescue
      $stderr.puts "#{img_uri} -> #{file_path}",
                   $ERROR_INFO.inspect, $ERROR_POSITION
    end
  end
end
