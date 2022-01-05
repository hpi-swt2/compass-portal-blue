module Locations
  def self.transform_leaflet_position(position, name)
    {
      latlng: position,
      div_icon: {
        html: name,
        class_name: "building-icon"
      }
    }
  end
end
