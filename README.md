Comic Downloader for http://comic.sfacg.com

Dependency
==========

```bash
$ gem install nokogiri therubyracer
```

Usage
=====

```ruby
# Download a chapter
Chapter.new('http://comic.sfacg.com/HTML/OnePiece/749/').download to: '.'

# Download a comic
Comic.new('http://comic.sfacg.com/HTML/OnePiece/').download to: '.'
```