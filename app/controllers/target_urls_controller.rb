class TargetUrlsController < ApplicationController
  def create
    @target_url = TargetUrlService.shorten!(target_url_params[:url])
    if @target_url.persisted?
      redirect_to @target_url
      return
    end

    redirect_to :root, alert: @target_url.errors.full_messages
  end

  def show
    @target_url = TargetUrl.find(params[:id])
  end

  private

  def target_url_params
    params.require(:target_url).permit(:url)
  end
end
