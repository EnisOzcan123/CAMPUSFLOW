class PlacesController < ApplicationController
  before_action :require_admin, except: %i[ index show ]
  before_action :set_place, only: %i[ show edit update destroy ]

  # GET /places or /places.json
  def index
    @categories = Place.distinct.order(:category).pluck(:category)
    @all_places = Place.order(:name)
    @total_places = @all_places.count
    @average_wifi_score = @all_places.average(:wifi_score)&.round(1) || 0
    @average_quiet_score = @all_places.average(:quiet_score)&.round(1) || 0
    @quietest_place = @all_places.reorder(quiet_score: :desc, name: :asc).first
    @upcoming_events = Event.upcoming.limit(3)
    @places = @all_places

    if params[:category].present?
      @places = @places.where(category: params[:category])
    end

    if params[:query].present?
      query = "%#{params[:query]}%"
      @places = @places.where("name ILIKE ? OR description ILIKE ?", query, query)
    end
  end

  # GET /places/1 or /places/1.json
  def show
  end

  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places or /places.json
  def create
    @place = Place.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: "Mekan başarıyla oluşturuldu." }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @place.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /places/1 or /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: "Mekan başarıyla güncellendi.", status: :see_other }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @place.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /places/1 or /places/1.json
  def destroy
    @place.destroy!

    respond_to do |format|
      format.html { redirect_to places_path, notice: "Mekan başarıyla silindi.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def place_params
      params.require(:place).permit(:name, :category, :description, :wifi_score, :quiet_score, :location_label, :map_x, :map_y, :latitude, :longitude)
    end
end
