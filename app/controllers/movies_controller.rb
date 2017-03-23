class MoviesController < ApplicationController
 before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  def index
    @movies = Movie.all
  end

  def new
    @movie = Movie.new
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def edit
  if current_user != @group.user
    @movie = Movie.find(params[:id])
    redirect_to root_path, alert: "You have no permission."
  end
end


  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
    if @movie.save
       redirect_to movies_path
     else
       render :new
     end
     end

  def update
    @movie = Movie.find(params[:id])

    if current_user != @group.user
       redirect_to root_path, alert: "You have no permission."
     end

   if  @movie.update(movie_params)
  redirect_to movies_path, notice: "Update Success"
  else
  render :edit
  end
end

 def destroy
   @movie = Movie.find(params[:id])

   if current_user != @group.user
         redirect_to root_path, alert: "You have no permission."
       end

   if @movie.destroy
  flash[:alert] = "Movie deleted"
   redirect_to movies_path
else
  render :edit
 end
end

  private

   def movie_params
   params.require(:movie).permit(:title, :description)
end

end
