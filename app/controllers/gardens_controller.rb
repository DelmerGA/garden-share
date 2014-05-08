class GardensController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  
  def index
    @gardens = Garden.all
  end

  def new
    @garden = Garden.new
  end

  def create
    g = Geocoder.search(params[:garden]["address"] + " " + params[:garden]["city"])
    geo_location_array = []
    g[0].data["geometry"]["location"].each_value do |x| 
      geo_location_array.push(x)
    end

    @garden = Garden.new garden_params

    @garden.geo_location = geo_location_array.join(", ")
    @garden.neighborhood = g[0].data["address_components"][2]["long_name"]
    @garden.zipcode = g[0].data["address_components"][7]["long_name"]
    current_user.garden_id = @garden.id
    @garden.save

    redirect_to gardens_path
  end

  def show
    @garden = Garden.find(params[:id])
  end

  def update
  end

  def destroy
  end

  private
    def garden_params
     params.require(:garden).permit(:address, :city, :description, :rules)
    end
end