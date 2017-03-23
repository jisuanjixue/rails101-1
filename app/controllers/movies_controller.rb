class MoviesController < ApplicationController
 before_action :authenticate_user! , only: [:new, :create]
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
    @movie = Movie.find(params[:id])
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
    @movie.update(movie_params)

    redirect_to movies_path
end

 def destroy
   @movie = Movie.find(params[:id])
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
