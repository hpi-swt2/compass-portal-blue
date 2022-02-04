class ErrorController < ApplicationController
  def show
    exception = params[:exception]
    logger.debug "BAUM: #{exception} .... #{exception.inspect}"
    @message = exception.inspect
  end
end
