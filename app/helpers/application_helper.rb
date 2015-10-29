module ApplicationHelper
  # list of Canvas roles that allow user to be  editing
  CAN_EDIT = ["Instructor", "urn:lti:role:ims/lis/TeachingAssistant", "ContentDeveloper", "urn:lti:instrole:ims/lis/Administrator"]
  def can_edit?(current_user)
    CAN_EDIT.each {|r| return true if current_user.has_role?(r) }
    false;
  end
end
