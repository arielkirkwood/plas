class HomeController < ApplicationController

  has_widgets do |root|
    @cu = current_user
    root << widget(:shoutbox, :current_user => current_user)
    root << widget(:opensource)
    root << widget(:welcome)
  end

  def index
    firebug "Initializing FirebugLogger..."	
  end

end
