
class Error                                               
  attr_accessor :currentError, :error_CannotEnterChatroom, :error_AllRelevantInforNotSent, :error_CannotSendMessage,
  :error_InvalidOperation
  def initialize()                  
   
   @error_CannotEnterChatroom = '1'
   @error_AllRelevantInforNotSent = '2'
   @error_CannotSendMessage = '3'
   @error_InvalidOperation = '4'
   
   @currentError = 0 
   
  end

  def ErrorMessage(connection)
    case @currentError
    when 0
      line = "Error - no error"
    when @error_CannotEnterChatroom
      line = "client cannot enter chatroom"
    when @error_AllRelevantInforNotSent
      line = "You did not send all relevant information to enter this Chatroom"
    when @error_CannotSendMessage
      line = "You did not send all relevant information to send this message"
    when @error_InvalidOperation
      line = "Invalid Operation"
    else
      line = "Unknown Error"
    end
     connection.puts "ERROR_CODE: #{@currentError}. ERROR_DESCRIPTION: #{line}"
  end
   
end
