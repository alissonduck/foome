class PagesController < ApplicationController
  def home
    @home_data = PageService.get_home_page_data
  end
end
