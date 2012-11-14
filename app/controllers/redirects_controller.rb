class RedirectsController < ApplicationController

  def new
    @redirect = Redirect.new
  end

  def create
    Redirect.create_shortened_url params[:redirect][:original_url]
    redirect_to :redirects
  end

  def edit
  end

  def update
  end

  def show
    @redirect = Redirect.where(:shortened_id => params[:id]).to_a.last
    @redirect_logs = RedirectLog.where(:redirect_id => @redirect._id).to_a

    @browser_visits = {}
    @redirect_logs.each do |log|
      agent = log['headers']['HTTP_USER_AGENT']
      if @browser_visits[agent]
        @browser_visits[agent] = @browser_visits[agent] + 1
      elsif agent
        @browser_visits[agent] = 1
      else
        @browser_visits['other'] = @browser_visits['other'] ? @browser_visits['other'] + 1 : 1
      end
    end

    respond_to do |format|
      format.html
      format.svg {render :qrcode => @redirect.shortened_url}
    end
  end

  def index
    @redirects = Redirect.all.to_a
  end
end
