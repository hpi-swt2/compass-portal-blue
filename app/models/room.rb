# The model representing a room at HPI
class Room < ApplicationRecord
  belongs_to :building
  has_many :events
  has_and_belongs_to_many :people
  validates :name, presence: true
  validates :room_type, presence: true
  validates :floor, presence: true, numericality: { only_integer: true }

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

  def free?
    endpoint = "https://owa.hpi.uni-potsdam.de/ews/Exchange.asmx"
    file = File.open("tmp_credentials.txt")
    file_data = file.readlines.map(&:chomp)
    user = file_data[0] # "HPI\\firstname.lastname"
    pass = file_data[1] # "password"

    cli = Viewpoint::EWSClient.new endpoint, user, pass
    # ---------------------------------------------------------------------- #

    room_management_folder = cli.get_folder_by_name "HPI Raumverwaltung", parent: :publicfoldersroot

    # TODO do this for all room types
    room_room_type_folder = cli.get_folder_by_name room_type, parent: room_management_folder.id

    # TODO do this for all rooms
    room_calendar = cli.get_folder_by_name name, parent: room_room_type_folder.id

    calendar_items = todays_calendar_items(room_calendar)

    current_datetime = DateTime.now()

    free = false
    calendar_items.each do |item|
      free = (current_datetime < item.start) || (item.end < current_datetime)
      if !free
        return free
      end
    end
    return free
  end
end
