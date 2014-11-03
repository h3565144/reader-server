require 'test_helper'

class ChannelsControllerTest < ControllerTest

  def test_should_get_new
    get '/channels/new'
    assert last_response.ok?
  end

  def test_should_create_channel
    assert_equal 0, Channel.count
    post '/channels', channel: {url: 'https://www.ruby-lang.org/en/feeds/news.rss'}
    assert_equal 1, Channel.count
    follow_redirect!
    assert_equal 'http://example.org/channels', last_request.url
    assert last_response.ok?
  end

  def test_should_destroy_channel
    channel = create :channel, url: 'https://www.ruby-lang.org/en/feeds/news.rss' 
    assert_equal 1, Channel.count
    delete "/channels/#{channel.id}"
    assert_equal 0, Channel.count
    follow_redirect!
    assert_equal 'http://example.org/channels', last_request.url
    assert last_response.ok?
  end

end
