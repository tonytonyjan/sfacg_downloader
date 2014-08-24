require 'sfacg/chapter'

describe Sfacg::Chapter do
  before :all do
    @chapter = Sfacg::Chapter.new 'http://comic.sfacg.com/HTML/OnePiece/757/'
  end

  it '#js_uri' do
    uri = @chapter.js_uri
    expect(uri).to be_a URI
    expect(uri.to_s).to eql 'http://comic.sfacg.com/Utility/2/757.js'
  end

  it '#images' do
    images = @chapter.images
    expect(images.map(&:to_s)).to match_array [
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/001_17670.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/002_22736.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/003_9374.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/004_14113.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/005_15235.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/006_24967.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/007_24880.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/008_11142.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/009_21826.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/010_20426.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/011_812.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/012_8585.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/013_30872.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/014_2534.png",
      "http://hotpic.sfacg.com/Pic/OnlineComic1/OnePiece/757/015_19383.png"
    ]
  end
end