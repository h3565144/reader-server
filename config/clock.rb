require 'clockwork'
module Clockwork
  every(1.hour, 'fetch_feeds') { `rake feed:add_fetch_jobs` }
end
