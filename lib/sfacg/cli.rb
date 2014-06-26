require 'sfacg'
require 'sfacg/version'
require 'thor'

module Sfacg
  class Cli < Thor
    desc 'comic URL', 'Download a comic, ex: http://comic.sfacg.com/HTML/JJDJR/'
    option :to, default: '.'
    def comic url
      Comic.new(url).download to: options[:to]
    end

    desc 'chapter URL', 'Download a chapter, ex: http://comic.sfacg.com/HTML/JJDJR/056/'
    option :to, default: '.'
    def chapter url
      Chapter.new(url).download to: options[:to]
    end

    desc 'version', 'Prints version'
    def version
      puts VERSION
    end
  end
end