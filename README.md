Comic Downloader for http://comic.sfacg.com

[![Build Status](https://travis-ci.org/tonytonyjan/sfacg_downloader.svg?branch=master)](https://travis-ci.org/tonytonyjan/sfacg_downloader)

Installation
==========

```bash
$ gem install sfacg
```

Usage
=====

Ruby
----

```ruby
# Download a chapter
Chapter.new('http://comic.sfacg.com/HTML/OnePiece/749/').download to: '.'

# Download a comic
Comic.new('http://comic.sfacg.com/HTML/OnePiece/').download to: '.'
```

Command
-------

```bash
$ sfacg -h
Commands:
  sfacg chapter URL     # Download a chapter, ex: http://comic.sfacg.com/HTML/JJDJR/056/
  sfacg comic URL       # Download a comic, ex: http://comic.sfacg.com/HTML/JJDJR/
  sfacg help [COMMAND]  # Describe available commands or one specific command
  sfacg version         # Prints version
```