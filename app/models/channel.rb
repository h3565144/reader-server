class Channel
  include Mongoid::Document
  field :url,        type: String
  field :name,       type: String
  field :text,       type: String
  field :fetched_at, type: DateTime

  #
  #base
  #
  mount_uploader :avatar, AvatarUploader
  before_validation :prepare_attributes
  validates :url, uniqueness: true

  def set_avatar
    uri = URI url
    uri.path = '/favicon.ico'
    uri.query = nil
    begin
      favicon = timeout 5 do
        uri.open
      end
    rescue RuntimeError, SocketError
      unless uri.scheme == 'https'
        uri.scheme = 'https'
        retry
      end
    end
    def favicon.original_filename; 'favicon.ico' end
    self.avatar = favicon
  end

  private
  def prepare_attributes
    return unless url
    self.url = self.class.sanitize_url url
    text = self.class.read_url url
    doc = Nokogiri.parse(text).tap { |doc| doc.search('item').remove() }
    rss = Feedjira::Parser::RSS.parse(text)
    assign_attributes(
      name:   rss.title,
      text:   doc.to_s
    )
    set_avatar
  end

  class << self
    def find_feed(url); find_by_url sanitize_url(url) end

    def sanitize_url(url)
      striped = url.split('?')[0]
      return url if striped == url
      text1 = read_url striped
      text2 = read_url url
      text1 == text2 ? striped : url
    end

    def read_url(url)
      Feedjira::Feed.fetch_raw url
    end
  end
  

  #
  #items association
  #
  has_many :items, dependent: :destroy
  after_create :enqueue_fetch_items

  public
  def fetch_items
    if item = items.order(id: :desc).first
      last_pub = Feedjira::Parser::RSSEntry.parse(item.text).published
    else
      last_pub = Time.at(0)
    end
    text = self.class.read_url url #rescue return
    doc = Nokogiri.parse(text)
    doc.search('item').reverse.each do |item|
      text = item.to_s
      published = Feedjira::Parser::RSSEntry.parse(text).published
      Item.create! text: text, channel: self if published > last_pub
    end
    update(fetched_at: Time.now)
  end

  private
  def enqueue_fetch_items
    Delayed::Job.enqueue FetchItemsJob.new(id)
  end

end
