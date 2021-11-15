class TargetUrlsController < ApplicationController
  def create
    @target_url, short_url = TargetUrlService.shorten(target_url_params[:url])
    if @target_url.persisted?
      redirect_to target_url_path(@target_url, new_short_url_id: short_url.id)
      return
    end

    redirect_to :root, alert: @target_url.errors.full_messages
  end

  def search
    target_url = TargetUrl.new(url: target_url_params[:url])
    if target_url.valid?
      target_url =
        TargetUrl.where("lower(url) = ?", target_url.url.downcase).first
      if target_url
        redirect_to target_url
      else
        redirect_to :root,
          alert: "URL not found. Select \"Shorten\" to create a new short URL."
      end
    else
      redirect_to :root, alert: target_url.errors.full_messages
    end
  end

  def show
    @target_url = TargetUrl.find(params[:id])
    @new_short_url_id = params[:new_short_url_id]
  end

  private

  def target_url_params
    params.require(:target_url).permit(:url)
  end
end
