Comic Downloader for http://comic.sfacg.com

Dependency
==========

```bash
$ gem install nokogiri therubyracer
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

Inline Command
--------------

```bash
$ curl https://raw.githubusercontent.com/tonytonyjan/sfacg_downloader/master/sfacg.rb | ruby - http://comic.sfacg.com/HTML/JJDJR/
```