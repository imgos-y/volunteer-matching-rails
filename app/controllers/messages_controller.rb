class MessagesController < ApplicationController
  before_action :set_event
  before_action :require_chat_participant
  rate_limit to: 10, within: 1.minute, only: :create, by: -> { current_user.id },
             with: -> { redirect_to event_messages_path(@event), alert: "You're sending messages too fast." }

  def index
    @messages = chat_messages
    @message = Message.new
  end
  def create
    @message = @event.messages.new(message_params.merge(user: current_user))

    if @message.save
      redirect_to event_messages_path(@event)
    else
      @messages = chat_messages
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    message = @event.messages.find(params[:id])
    message.destroy if message.deletable_by?(current_user)
    redirect_to event_messages_path(@event)
  end

  private

  def require_chat_participant
    redirect_to events_path, alert: "You don't have access to this chat." unless @event.chat_participant?(current_user)
  end
  def set_event
    @event = Event.find(params[:event_id])
  end

  def chat_messages
    @event.messages.includes(user: :userable).order(:created_at)
  end

  def message_params
    params.expect(message: [ :body ])
  end
end
