class HealthController < ApplicationController
  def index
    render body: %q{<html><a href="https://www.youtube.com/watch?v=ir5bTic17k4">Crystal Palace, we're still here!</a></html>},
           content_type: 'text/html'
  end
end
