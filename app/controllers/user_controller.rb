class UserController < ApplicationController
  def calendar
    @user_events = User.find(params[:id]).events
  end
end
