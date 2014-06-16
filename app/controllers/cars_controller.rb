class CarsController < ActionController::Base
  def index
    @cars = Car.all
    if request.headers["X-Api-Version"] == "v1"
      render 'v1_index'
    end
  end

  def show
    begin
      @car = Car.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render :status => 404, :json => {}
    end
    if request.headers["X-Api-Version"] == "v1"
      render 'v1_show'
    end
  end

  def create
    car_params = JSON.parse(request.body.read)
    token = request.headers["HTTP_AUTHORIZATION"]
    user = User.find_by(api_authentication_token: token)
    @car = Car.new(car_params)
    if user
      if request.headers["X-Api-Version"] == "v1"
        @car.save!
        render 'v1_show', :status => 201
      else
        if car_params["doors"]
          render :status => 401, :json => {}
        else
          @car.save!
          render 'show', :status => 201
        end
      end
    else
      render :status => 401, :json => {}
    end
  end
end
