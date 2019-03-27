class UsersController < ApiController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :remove_user_role, :add_user_role]
  before_action :authenticate_user!

  protect_from_forgery with: :exception, only: [:home]

  layout "angular", only: [:home]


  # GET /users
  # GET /users.json
  def home
    render :index
  end

  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  def current
    @user = current_user
    # @roles = true
    render :show
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    # if a role is being passed in then add it if it doesnt already exist
    if !params[:user][:role].nil?
      if !@user.has_role? params[:user][:role]
        @user.add_role params[:user][:role]
      end
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_user_role
    role = Role.find(params[:role])
    if @user.delete_role role.name.to_sym
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def add_user_role
    role = Role.find(params[:role])
    if @user.add_role role.name.to_sym
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email)
    end

end
