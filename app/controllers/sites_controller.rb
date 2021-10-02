class SitesController < ApplicationController
  before_action :set_site, only: %i[ show edit update destroy ]
  before_action :set_user

  # GET /sites or /sites.json
  def index
    @sites = @user.sites
  end

  # GET /sites/1 or /sites/1.json
  def show
  end

  # GET /sites/new
  def new
    @site = Site.new
    @repository_names = AvailableRepositories.new(@user, session[:token]).repository_names_and_installation_ids
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites or /sites.json
  def create
    @site = Site.new(site_params)
    @site.user = @user

    respond_to do |format|
      if @site.save
        SiteRemoteManager.new(@site).init_folder_content_and_download
        format.html { redirect_to user_sites_path(user_id: @user.id, id: @site.id), notice: "Site was successfully created." }
        format.json { render :show, status: :created, location: @site }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1 or /sites/1.json
  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to @site, notice: "Site was successfully updated." }
        format.json { render :show, status: :ok, location: @site }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1 or /sites/1.json
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to user_sites_path, notice: "Site was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
    end

  def set_user
    @user = User.find(params[:user_id])
  end

    # Only allow a list of trusted parameters through.
    def site_params
      params.require(:site).permit(:repo, :installation_id, :branch)
    end
end
