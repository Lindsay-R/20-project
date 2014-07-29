require "sinatra"
require "active_record"
require "rack-flash"
require_relative "lib/users_table"
require_relative "lib/posts_table"
require "gschool_database_connection"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @users_table = UsersTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
    @posts_table = PostsTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
  end

  get "/" do
    # if session[:user_id]
    #   puts "We still have a session id #{session[:id]}"
    # end
    posts = @posts_table.all
    erb :homepage, locals: {posts: posts}
  end

  #---link to Join---
  get "/registration" do
    erb :registration
  end

  #---Join Form---
  post "/registration" do
    if params[:email] == '' && params[:username] == '' && params[:password] == ''
      flash[:error_flash] = "Username, email, and password are required"
      redirect "/registration"
    elsif params[:email] == '' && params[:username] == ''
      flash[:error_flash] = "Email and username are required"
      redirect "/registration"
    elsif params[:username] == '' && params[:password] == ''
      flash[:error_flash] = "Username and password are required"
      redirect "/registration"
    elsif params[:email] == '' && params[:password] == ''
      flash[:error_flash] = "Email and password are required"
      redirect "/registration"
    elsif params[:email] == ''
      flash[:error_flash] = "Email is required"
      redirect "/registration"
    elsif params[:username] == ''
      flash[:error_flash] = "Username is required"
      redirect "/registration"
    elsif params[:password] == ''
      flash[:error_flash] = "Password is required"
      redirect "/registration"
    else
      if @users_table.find_id_by_name(params[:username]) != nil
        flash[:error_flash] = "Username is already in use, please choose another."
        redirect "/registration"
      end
      flash[:notice] = "Thank you for registering, please signin."
      @users_table.create(params[:email], params[:username], params[:password])
      redirect "/signin"

    end
  end

  #---link to SignIn---
  get "/signin" do
    erb :signin
  end

  #---SignIn Form---
  post "/signin_post" do
    current_user = @users_table.find_by(params[:email], params[:password])
    if params[:email] == '' && params[:password] == ''
      flash[:error_flash] = "Email and password are required"
      redirect back
    elsif params[:password] == ''
      flash[:error_flash] = "Password is required"
      redirect back
    elsif params[:email] == ''
      flash[:error_flash] = "Email is required"
      redirect back
    else
      session[:user_id] = current_user["id"]
      flash[:not_logged_in] = true
    end
    redirect "/"
  end

  #---Logout... End user session---
  post "/logout" do
    session[:user_id] = nil
    redirect "/"
  end

  # ---link to Post page---
  get "/post_page" do
    erb :post_page
  end

  #---Post page Form---
  post "/post_page" do

    image = params[:image]
    description = params[:description]
    @posts_table.create(image, description, session[:user_id])

    flash[:notice] = "Post created"
    redirect "/"
  end

  # ---link to View page---
  # get "/view_post/:p_id" do
  #   post = @posts_table.find(params[:p_id])
  #   erb :"view_post", locals: {post: post}
  # end


  # ---patch to View page---
  # patch "/view_post/:p_id" do
  #   @posts_table.update(params[:p_id],{
  #     image: params[:image],
  #     description: params[:description]
  #   })
  # end



end #class end