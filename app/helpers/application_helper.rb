module ApplicationHelper
  require "post_logger"
  # list of Canvas roles that allow user to be  editing
  CAN_EDIT = ["Instructor", "urn:lti:role:ims/lis/TeachingAssistant", "ContentDeveloper", "urn:lti:instrole:ims/lis/Administrator"]
  def can_edit?(current_user, course_id)
# don't even bother checking the roles if they've broken out of the iframe and changed  the course_id!!!
    return false if course_id != session[:lis_course_offering_sourcedid]  
    CAN_EDIT.each {|r| return true if current_user.has_role?(r) }
    false;
  end
  def log_post(cid, rid, action, type="info")
    msg =  "#{request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_ADDR']},#{cid},#{rid},#{action}"
#    PostLogger.send type.to_sym msg
    if type == "info"
      PostLogger.info(msg)
    else
      PostLogger.error(msg)
    end
  end
  
end
