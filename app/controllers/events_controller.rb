class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @event = Event.new(event_params)
    @event.session_hash = session_hash
    
    if @event.save
      render json: { status: 'success' }, status: :created
    else
      render json: { status: 'error', errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:game_id, :event_type)
  end
end
