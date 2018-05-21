  class UrlsController < ApplicationController
    TOP_URL_DELIMITER = 100.freeze
    ORDER_DELIMITER = 'desc'.freeze
    before_action :find_shortened_url, only: [:show, :shorty]

    def index
      @url = Url.new
    end

    def show
      redirect_to @url.sanitize_url
    end

    def create
      @url = Url.new(url_params)
      @url.sanitize
      if @url.new_url?
        if @url.save
          flash[:success] = "Your url its shorter now" 
          redirect_to shorty_path(@url.short_url)
        else
          flash[:error] = "Something went wrong: #{@url.errors}" 
          render 'index'
        end
      else
        flash[:success] = 'We found that url in our records'
        redirect_to shorty_path(@url.find_duplicate.short_url)
      end
    end

    def shorty
      @url = Url.find_by_short_url(params[:short_url])
      host = request.host_with_port
      @original_url = @url.sanitize_url
      @short_url = host + '/' + @url.short_url
    end

    def top
      @top_urls = Url.top(ORDER_DELIMITER, TOP_URL_DELIMITER)
    end


    private

    def find_shortened_url
      @url = Url.find_by_short_url(params[:short_url])
    end

    def url_params
      params.require(:url).permit(:url)
    end
  end
