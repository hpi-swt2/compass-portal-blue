module ApplicationHelper
  def route_active_class?(test_path)
    return 'active' if request.path == test_path

    ''
  end
end
