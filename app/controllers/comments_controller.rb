class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.commenter = current_user

    if @comment.save
      flash[:notice] = "Comment created"
      redirect_to post_path(@post)
    else
      render '/posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.new(voter: current_user, voteable: @comment, vote: params[:vote])
    if @vote.save
      flash[:notice] = "Your vote was tallied"
    else
      flash[:error] = "You can only vote once"
    end

    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
