 
require 'socket'
require './errors'

class Client                                                
  attr_accessor :connection, :Name, :chatroomConnected, :RoomRef, :leavingChatroom, :disconnecting, 
  :uploading, :joiningChatroom, :joinID, :RoomRef
  def initialize(setJoinID, setConnection)                  
   @connection = setConnection 
   @ClientIP = 0
   @ClientPort = 0
   @Name = "Default"
   @chatroomConnected = false
   @leavingChatroom = false
   @disconnecting = false
   @uploading = false
   @joiningChatroom = false
   @joinID = setJoinID
   @RoomRef = 0
   @chatroomName = "Default"
   
   @errors = Error.new()
  end
  
  def printDetailsJoining(serverIP,serverPort)
    return "JOIN_CHATROOM: #@chatroomName\nSERVER_IP: #{serverIP}\nPORT: #{serverPort}\nROOM_REF: #@RoomRef\nJOIN_ID: #@joinID\n"
  end
  
  def printDetailsLeaving()
    return "LEFT_CHATROOM: #@RoomRef\nJOIN_ID: #@joinID\n"
  end
  
  def releventInfo()
    if @ClientIP != 0 and @ClientPort != 0 and @joinID != 0
      return true
    else
      return false
    end
  end
  
  def returnResponce(command,response)  
   if  response == "ERROR"
     @errors.ErrorMessage(@connection)
   else
     @connection.puts command
     @connection.puts response
   end
  end
                 
  
  def canClientEnter(line,server1)
    headers,body = line.split      # Split response at first blank line into headers and body
    case headers
    when "JOIN_CHATROOM:"
      @chatroomName = body
      @RoomRef = server1.returnRoomRef(@chatroomName,self)
    when "CLIENT_IP:"
      @ClientIP = body
    when "PORT:"
      @ClientPort = body
    when "CLIENT_NAME:"
      @Name = body    
      if releventInfo() == true
        @connection.puts printDetailsJoining(server1.ServerIP,server1.ServerPort)
        @chatroomConnected = true
      else
      @errors.ErrorMessage(@errors.error_AllRelevantInforNotSent, @connection) 
      end
    else
      @errors.ErrorMessage(@errors.error_AllRelevantInforNotSent, @connection)            
    end      
  end
  
  def clientDisconnect(line)
    headers,body = line.split       # Split response at first blank line into headers and body 
    if headers == "CLIENT_NAME:"      
      @connection.close
    end   
  end
   
end
