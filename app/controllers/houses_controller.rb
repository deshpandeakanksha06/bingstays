class HousesController < ApplicationController
    
    def house_params
        params.require(:house).permit(:name, :avg_house_rating, :description, :avg_lord_rating,:price,:capacity,:lord_name)
    end
    
    def show
        id = params[:id] 
        @house = House.find(id) 
    end
    
    def index
        @all_house_ratings = House.all_house_ratings
        @selected_house_ratings = params[:houses_ratings] || {}
        if @selected_house_ratings == {}
          @selected_house_ratings = Hash[@all_house_ratings.map {|rating| [rating, rating]}]
        end
        if params[:houses_ratings] != session[:houses_ratings]
          session[:houses_ratings] = @selected_house_ratings
          redirect_to :houses_ratings => @selected_house_ratings and return
        end
        @houses = House.where(avg_house_rating: @selected_house_ratings.keys)
    end
    
    def new
    end
    
    def edit
        @house = House.find params[:id]
    end
    
    def update
        @house =House.find(params[:id])
        @house.update_attributes!(house_params)
        flash[:notice] = "#{@house.name} was successfully updated."
        redirect_to house_path(@house)
    end
  
    def create
        @house = House.create!(house_params)
        flash[:notice] = "#{@house.name} was successfully created."
        redirect_to houses_path()
    end
    
    def destroy
        @house = House.find(params[:id])
        @house.destroy
        flash[:notice] = "House '#{@house.name}' deleted."
        redirect_to houses_path
     end
end
