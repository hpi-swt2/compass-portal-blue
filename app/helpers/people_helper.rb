module PeopleHelper
  def tel_to(phone_number)
    link_to phone_number, "tel:#{phone_number}"
  end

  def mail_to(email)
    link_to email, "mailto:#{email}"
  end
end
