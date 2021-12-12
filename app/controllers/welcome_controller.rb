class WelcomeController < ApplicationController
  # https://github.com/heartcombo/devise#controller-filters-and-helpers
  before_action :authenticate_user!, only: [:protected]
  # Alternative: before_action :authenticate_user!, :except => [:index]

  def index
    # Welcome page, accessible without login

    logged_into_owa = false

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

      # TODO replace with "yesterday" and "today"
      start_date = DateTime.parse("2021-12-12").iso8601
      end_date = DateTime.parse("2021-12-13").iso8601

      # TODO:
      # filter recurring items like seen here: https://github.com/WinRb/Viewpoint/blob/main/lib/ews/types/generic_folder.rb#L85
      # them filter the recurring items that match "today"
      # after that merge them with todays items

      one_year_earlier = DateTime.parse("2020-12-12")
      calendar_items = room_a_1_1_calendar.items_since(one_year_earlier)
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
