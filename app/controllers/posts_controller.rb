class PostsController < ApplicationController
  before_filter :require_subdomain!
  before_filter :authenticate_user!, :except => [:show, :index]
  
  def new
    @post = Post.new
  end
  
  def create
    @post = current_forum.posts.new(params[:post])
    @post.user = current_user
    @post.forum = current_forum
    if @post.save
      redirect_to @post, :notice => "Post created!"
    else
      render :new
    end
  end
  
  def index
    if params[:search].present?
      @posts = Post.solr_search do
        keywords params[:search]
        with :forum_id, current_forum.id
        paginate :page => params[:page]
      end
    else
      @posts = current_forum.posts.with_tags(params[:tags], current_forum).page(params[:page])
      
      if params[:sort] == 'top'
        @posts = @posts.desc(:votes_point)
      elsif params[:sort] == 'latest'
        @posts = @posts.desc(:created_at)
      else
        @posts = @posts.desc(:ranking)
      end            
    end
  end
  
  def show
    @post = current_forum.posts.find(params[:id])
    if @post.nil?
      redirect_to root_path(:subdomain => current_forum.subdomain), :notice => "That post is no longer available."
      return
    end
    @comment = @post.comments.new
    @comments = @post.comments.asc(:lft).page(params[:page])
  end
  
  def edit
    @post = current_forum.posts.find(params[:id])
    authorize! :edit, @post
  end
  
  def update
    params[:post][:tag_ids] ||= []
    @post = current_forum.posts.find(params[:id])
    authorize! :update, @post
    if @post.update_attributes(params[:post])
      redirect_to @post, :notice => "Post updated!"
    else
      render :edit
    end
  end
  
  def destroy
    @post = current_forum.posts.find(params[:id])
    authorize! :destroy, @post
    @post.destroy
    redirect_to root_path, :notice => "Post deleted!"
  end
  
end
