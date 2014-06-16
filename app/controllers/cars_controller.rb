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
    token = request.headers["HTTP_AUTHORIZATION"]
    user = User.find_by(api_authentication_token: token)
    @car = Car.new(car_params)
    if user
      @car.save!
      render 'show', :status => 201
    else
      render :status => 401, :json => {}
    end
  end
end
