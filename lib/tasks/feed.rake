namespace :feed do
  task :environment do
    require_relative '../../config/env'
  end
  
  task add_fetch_jobs: :environment do
    Channel.all.each { |channel| Delayed::Job.enqueue FetchItemsJob.new(channel.id) }
  end

  task start_workers: :environment do
    3.times do
      Delayed::Worker.new(min_priority: ENV['MIN_PRIORITY'], 
        max_priority: ENV['MAX_PRIORITY']).start
    end
  end

  task clear_jobs: :environment do
    Delayed::Job.delete_all
  end

  task update_channel_avatars: :environment do
    Channel.all.each do |channel|
      channel.set_avatar
      channel.save!
    end
  end
end
