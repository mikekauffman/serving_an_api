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

  def create
    car_params = JSON.parse(request.body.read)
    @car = Car.create!(car_params)
    render 'show', :status => 201
  end
end