class ErrorController < ApplicationController
  def show
    exception = params[:exception]
    @message = exception.inspect
  end
end
