class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.tag_list = event_params[:tag_list]
    @event.save

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params) and @event.tag_list = event_params[:tag_list] and @event.save
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def join
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.users.count < @event.limit and not @event.users.include? current_user
        @event.users.append(current_user)
        format.html { redirect_to @event, notice: 'Event successfully joined' }
      else
        format.html { redirect_to @event, notice: 'Event over-subscribed' }
      end
    end
  end

  def leave
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.users.include? current_user
        @event.users.delete current_user
        format.html { redirect_to @event, notice: 'Event successfully left' }
      else
        format.html { redirect_to @event, notice: "You're not currently a member of this event" }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :description, :limit, :date, :tag_list)
    end
end
