class DashboardController < ApplicationController
  def index
    @matches = ProductMatch.all
  end
end
