class CommentsController < ApplicationController
    before_action :require_signed_in!, only: [:new, :create]
    before_action :index

    def index 
      @q = Sub.ransack(params[:q])
      @subs = @q.result
  end
  
    def new
      @comment = Comment.new(post_id: params[:post_id])
    end
  
    def create
      @comment = current_user.comments.new(comment_params)
  
      if @comment.save!
        redirect_to post_url(@comment.post_id)
      else
        flash[:errors] = @comment.errors.full_messages
        redirect_to new_post_comment_url(@comment.post_id)
      end
    end
  
    def show
      @comment = Comment.find(params[:id])
      @new_comment = @comment.child_comments.new
    end
  
    private
    def comment_params
      params.require(:comment).permit(:body, :post_id, :parent_comment_id)
    end
  
  end