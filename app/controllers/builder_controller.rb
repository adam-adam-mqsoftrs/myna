class BuilderController < ApplicationController
  before_action :authenticate_user!
  layout "angular"

  def index
  end

end
