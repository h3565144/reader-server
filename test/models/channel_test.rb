require 'test_helper'

class ChannelTest < Minitest::Test

  def test_should_fetch_items
    channel = create :channel, url: 'https://www.ruby-lang.org/en/feeds/news.rss'
    channel.fetch_items
    assert_equal 10, channel.items.count
    channel.fetch_items
    assert_equal 10, channel.items.count
  end

end
