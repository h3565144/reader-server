require_relative '../config/env'
include FactoryGirl::Syntax::Methods
Channel.destroy_all
create :channel, url: 'https://www.ruby-lang.org/en/feeds/news.rss'
create :channel, url: 'http://news.163.com/special/00011K6L/rss_gj.xml'
create :channel, url: 'http://www.pingwest.com/feed'
