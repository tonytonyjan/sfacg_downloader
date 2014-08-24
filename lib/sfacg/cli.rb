require 'sfacg'
require 'sfacg/version'
require 'thor'

module Sfacg
  class Cli < Thor
    desc 'comic URL', 'Download a comic'
    long_desc <<-EOS
      Download a comic:
      \x5 $ sfacg chapter http://comic.sfacg.com/HTML/JJDJR/ --to /tmp
    EOS
    option :to, default: '.', banner: '<dir>', desc: 'Where to save.'
    def comic url
      Comic.new(url).download to: options[:to]
    end

    desc 'chapter URL', 'Download a chapter'
    long_desc <<-EOS
      Download a chapter:
      \x5 $ sfacg chapter http://comic.sfacg.com/HTML/JJDJR/056/ --to /tmp
    EOS
    option :to, default: '.', banner: '<dir>', desc: 'Where to save.'
    def chapter url
      Chapter.new(url).download to: options[:to]
    end

    desc 'version', 'Prints version'
    def version
      puts VERSION
    end
  end
end