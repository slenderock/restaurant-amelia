class ReserveController < ApplicationController
  def show
    @resource = Reserve.find(params[:id])
  end
end
