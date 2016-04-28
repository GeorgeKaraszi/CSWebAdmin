class RequestsController < ApplicationController

  def index
    request_query = Request.request_by(request_params)

    respond_to do |format|
      format.js {render json: request_query}
    end
  end

  def exportlist
    @request = Request.request_by(request_params)

    respond_to do |format|
      format.json {render json: @request}
    end
  end

  def export
    @request = Request.request_by(request_params)

    respond_to do |format|
      format.json {render json: @request}
    end
  end

  private

  def request_params
    JSON.load(params.require(:request_data))
  end

end
