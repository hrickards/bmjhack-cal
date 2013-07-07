class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :check_privileges!, except: [:index, :show, :join, :leave, :leave_waitlist]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    unless params[:start].nil? or params[:start].empty? or params[:end].nil? or params[:end].empty?
      start_datetime = Time.iso8601(params[:start])
      end_datetime = Time.iso8601(params[:end])
      @events = @events.where('start_datetime BETWEEN ? AND ?', start_datetime.beginning_of_day, end_datetime.end_of_day)
    end

    unless params[:courses].nil? or params[:courses].empty?
      @events = @events.tagged_with(params[:courses], :on => :course, :any => true)
    end

    unless params[:years].nil? or params[:years].empty?
      @events = @events.tagged_with(params[:years], :on => :year, :any => true)
    end
      
    unless params[:tags].nil? or params[:tags].empty?
      @events = @events.tagged_with(params[:tags], :on => :tags, :any => true)
    end
    
    @events = @events.all

    respond_to do |format|
      format.html
      format.ical
      format.json
    end
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
    @event.tag_list = event_params[:tag_list].reject { |x| x.empty? }
    @event.year_list = event_params[:year_list].reject { |x| x.empty? }
    @event.course_list = event_params[:course_list].reject { |x| x.empty? }
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
    @event.tag_list = event_params[:tag_list].reject { |x| x.empty? }
    @event.year_list = event_params[:year_list].reject { |x| x.empty? }
    @event.course_list = event_params[:course_list].reject { |x| x.empty? }
    @event.save
    respond_to do |format|
      if @event.update(event_params)
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
        @event.waitlist_users.append(current_user)
        format.html { redirect_to @event, notice: 'Event over-subscribed. You have been placed on a waiting list.' }
      end
    end
  end

  def leave
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.users.include? current_user
        @event.users.delete current_user
        @event.check_waitlist
        format.html { redirect_to @event, notice: 'Event successfully left' }
      else
        format.html { redirect_to @event, notice: "You're not currently a member of this event" }
      end
    end
  end

  def leave_waitlist
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.waitlist_users.include? current_user
        @event.waitlist_users.delete current_user
        format.html { redirect_to @event, notice: 'Event waiting list successfully left' }
      else
        format.html { redirect_to @event, notice: "You're not currently a member of this event's waiting list" }
      end
    end
  end

  def email_group
    @event = Event.find params[:id]
  end

  def send_email_group
    @event = Event.find params[:id]
    @event.send_email_group params[:subject], params[:body]

    flash[:notice] = 'Email successfully sent.'
    redirect_to @event
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit!
    end

    def check_privileges!
        redirect_to "/", alert: 'You dont have enough permissions to be here' unless current_user.administrator?
    end
end
