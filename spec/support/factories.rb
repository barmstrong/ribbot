def create_forum params={}
  Forum.create!(forum_attributes.merge(params))
end

def create_user params={}
  User.create!(user_attributes.merge(params))
end

def create_user_with_forum p1={}, p2={}
  u = create_user(p1)
  f = create_forum(p2)
  f.add_owner(u)
  [u,f]
end

def create_ufpc
  u, f = create_user_with_forum
  p = create_post :forum => f, :user => u
  c = create_comment :forum => f, :user => u, :post => p
  [u,f,p,c]
end

def create_post params={}
  params[:user] ||= create_user
  params[:forum] ||= create_forum
  Post.create!(post_attributes.merge(params))
end

def create_comment params={}
  params[:user] ||= create_user
  params[:forum] ||= create_forum
  params[:post] ||= create_post
  Comment.create!(comment_attributes.merge(params))
end

def create_tag params={}
  params[:forum] ||= create_forum
  Tag.create!(tag_attributes.merge(params))
end

## Valid attributes

def forum_attributes
  {:subdomain => "test#{forum_count}"}
end

def user_attributes
  {:email => "user#{user_count}@example.com", :password => "test123", :verified_at => Time.zone.now, :created_at => 1.month.ago}
end

def post_attributes
  {:title => "Title of Post #{post_count}", :text => "foo bar fizz bang"}
end

def comment_attributes
  {:text => "Comment #{comment_count} text"}
end

def tag_attributes
  {:name => "Tag #{tag_count}"}
end

## Counters

def forum_count
  @forum_count = @forum_count.nil? ? 1 : (@forum_count+=1)
end

def user_count
  @user_count = @user_count.nil? ? 1 : (@user_count+=1)
end

def post_count
  @post_count = @post_count.nil? ? 1 : (@post_count+=1)
end

def comment_count
  @comment_count = @comment_count.nil? ? 1 : (@comment_count+=1)
end

def tag_count
  @tag_count = @tag_count.nil? ? 1 : (@tag_count+=1)
end