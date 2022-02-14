class CalendarController < ApplicationController
  before_action :set_highlighted_event, only: [:show]

  # GET /calendar
  def show
    start_date = params[:start_date].to_date
    @month = start_date.month
    @year = start_date.year
    @events = Event.generate_calendar_events(Event.all,
                                             start_date.beginning_of_month.beginning_of_week,
                                             start_date.end_of_month.end_of_week).compact
  end

  def set_highlighted_event
    @highlighted_event_id = params[:event_id].to_i if params.key?(:event_id)
  end
end
