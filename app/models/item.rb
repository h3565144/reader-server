class Item
  include Mongoid::Document
  field :text, type: String

  belongs_to :channel

  def rss_entry; @rss_entry ||= Feedjira::Parser::RSSEntry.parse(text) end

end
