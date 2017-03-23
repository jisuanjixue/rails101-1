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
    @reviews = @movie.reviews.recent.paginate(:page => params[:page], :per_page => 5)
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
 current_user.favorite!(@movie)
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

def favorite
   @movie = Movie.find(params[:id])

    if !current_user.is_member_of?(@movie)
      current_user.favorite!(@movie)
      flash[:notice] = "成功收藏"
    else
      flash[:warning] = "你已经收藏了！"
    end

    redirect_to movie_path(@movie)
  end

  def hate
    @movie = Movie.find(params[:id])

    if current_user.is_member_of?(@movie)
      current_user.hate!(@movie)
      flash[:alert] = "已放弃收藏"
    else
      flash[:warning] = "你还没收藏此电影，喜欢就收藏！"
    end

    redirect_to movie_path(@movie)
  end

  private

   def movie_params
   params.require(:movie).permit(:title, :description)
end

end
