class HomeController < ApplicationController

  def index

  end

  def get_root_domain
    main_domain = params[:main_domain]
    page = Crawler.process(main_domain)
    #is_valid_domain = check_valid_domain
    flash[:alert] = "Hello #{page}"
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  private

  def check_valid_domain
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
  end
end
