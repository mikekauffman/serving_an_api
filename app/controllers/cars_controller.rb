class CarsController < ActionController::Base
  def index
    @cars = Car.all
  end

  def show
    begin
      @car = Car.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render :status => 404, :json => {}
    end
  end
end