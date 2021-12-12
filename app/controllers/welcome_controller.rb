class WelcomeController < ApplicationController
  # https://github.com/heartcombo/devise#controller-filters-and-helpers
  before_action :authenticate_user!, only: [:protected]
  # Alternative: before_action :authenticate_user!, :except => [:index]

  def todays_calendar_items(calendar)

    # https://docs.microsoft.com/en-us/exchange/client-developer/web-service-reference/calendarview
    # +
    # https://github.com/WinRb/Viewpoint/blob/e8fec4ab1af25fc128062cd96770afdb9fc38c68/lib/ews/soap/builders/ews_builder.rb#L695
    
    calendar_view = {:calendar_view => {
      :max_entries_returned => 100,
      :start_date => DateTime.current.beginning_of_day,
      :end_date => DateTime.current.end_of_day
    }}

    calendar.items(calendar_view)
  end

  def index
    # Welcome page, accessible without login

    logged_into_owa = true

    if logged_into_owa

      # ---------------------------------------------------------------------- #
      # TODO move to login function/page
      endpoint = "https://owa.hpi.uni-potsdam.de/ews/Exchange.asmx"
      user = "HPI\\firstname.lastname"
      pass = "password"

      cli = Viewpoint::EWSClient.new endpoint, user, pass
      # ---------------------------------------------------------------------- #

      room_management_folder = cli.get_folder_by_name "HPI Raumverwaltung", parent: :publicfoldersroot

      # TODO do this for all room types
      room_seminar_room_folder = cli.get_folder_by_name "HPI-Seminarraeume", parent: room_management_folder.id

      # TODO do this for all rooms
      room_a_1_1_calendar = cli.get_folder_by_name "HPI A1.1", parent: room_seminar_room_folder.id

      one_year_earlier = DateTime.parse("2020-12-12")
      calendar_items = todays_calendar_items(room_a_1_1_calendar)
      calendar_items.each do |item|
        # TODO update database
        p [item.subject, item.start, item.end, item.recurrence]
      end
    end
  end

  def protected
    # Only accessible by logged in users, see `before_action` call
  end
end
