require "sinatra"
require "active_record"
require "rack-flash"
require_relative "lib/users_table"
require "gschool_database_connection"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @users_table = UsersTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )

  end

  get "/" do
    if session[:user_id]
      puts "We still have a session id #{session[:id]}"
    end
    erb :homepage
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
      flash[:notice] = "Thank you for registering"
      @users_table.create(params[:email], params[:username], params[:password])
      redirect "/"
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


end #class end