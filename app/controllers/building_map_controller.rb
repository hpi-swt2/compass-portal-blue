class BuildingMapController < ApplicationController
    def index
        @start = params[:start]
        @destination = params[:dest]
    end
end
