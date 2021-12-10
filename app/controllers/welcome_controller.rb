class WelcomeController < ApplicationController
  def index
    # Welcome page, accessible without login
  end

  def login
    # Only accessible by logged in users, see `before_action` call
  end
end
