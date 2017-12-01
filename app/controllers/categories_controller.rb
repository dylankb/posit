class CategoriesController < ApplicationController
  before_action :require_user, only: [:new, :create]

  def new
    @category = Category.new
  end

  def create
    @post = Post.find(params[:post_id])
    @category = @post.categories.new(category_params)

    if @category.save
      flash[:notice] = "New category created"
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end