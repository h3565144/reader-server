FetchItemsJob = Struct.new(:channel_id) do
  def perform
    Channel.find(channel_id).fetch_items
  end
end
