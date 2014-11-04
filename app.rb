class Web < Sinatra::Base
  set :views, 'app/views'
  
  get '/' do
    redirect :'/channels'
  end

  get '/channels' do
    @channels = Channel.all
    haml :'channels/index'
  end
  
  get '/channels/new' do
    @channel = Channel.new
    haml :'channels/new'
  end

  post '/channels' do
    attributes = {url: params[:channel][:url]}
    @channel = Channel.new(attributes)
    if @channel.save
      redirect '/channels'
    else
      haml :'channels/new'
    end
  end

  delete '/channels/:id' do
    set_channel
    @channel.destroy
    redirect '/channels'
  end

  get '/channels/:id/avatar' do
    set_channel
    avatar = @channel.avatar
    avatar = avatar.thumb if params[:thumb]
    content_type 'image/png'
    headers['Content-Disposition'] = 'inline'
    avatar.file.read
  end

  private
  def set_channel
    @channel = Channel.find(params[:id])
  end
end

class API < Grape::API
  format :json
  default_format :json

  get '/api/channels' do
    channels = Channel.order(id: :asc).limit(20)
    if params[:after_id] && params[:after_id] =~ /\S+/
      channels = channels.where(:id.gte => params[:after_id]) 
    end
    Jbuilder.new do |json|
      json.channels channels do |channel|
        json.(channel, :id, :url, :name, :fetched_at)
      end
    end.attributes!
  end

  get '/api/items' do
    items = Item.order(id: :asc).limit(20)
    if params[:after_id] && params[:after_id] =~ /\S+/
      items = items.where(:id.gte => params[:after_id]) 
    end
    Jbuilder.new do |json|
      json.items items do |item|
        json.(item, :id, :channel_id)
        json.(item.rss_entry, :title, :published, :author, :url, :content, :summary)
      end
    end.attributes!
  end
end
