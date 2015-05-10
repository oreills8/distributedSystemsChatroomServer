require './chatroom'

class Server                                                
  attr_accessor :enteringClients, :chatroomCount, :ServerIP, :ServerPort, :ServerFilePort, :chatrooms, :socket, 
  :IsOpen, :ClientCount
  def initialize(iPAddress)
    @enteringClients = Queue.new
    @chatrooms = Array.new    
    @ServerPort = 2500
    @ServerIP = iPAddress
    @chatroomCount = 0
    @socket = TCPServer.open(@ServerPort)
    @IsOpen = true                              #Isopen is a boolean for if the socket is still open or not
    @ClientCount = 0   
  end

  def returnChatroom(id)
    totalLength = @chatrooms.length
    count = 0
    while totalLength > count
      tempChatroom = @chatrooms[count]
      if id == tempChatroom.RoomRef
        return tempChatroom
      end
      count = count + 1
    end
    return NULL
  end
  
  def returnRoomRef(name, client1)
    totalLength = @chatrooms.length
    count = 0
    while totalLength > count
      chatroom = @chatrooms[count]
      if chatroom.name != name     
        count = count + 1
      else     
        count = totalLength
        chatroom.jointClients.push(client1)
        return chatroom.RoomRef
      end    
    end
    @chatroomCount = @chatroomCount + 1 
    chatroom1 = Chatroom.new(name, @chatroomCount)
    chatroom1.jointClients.push(client1)
    @chatrooms.push(chatroom1)
    return chatroom1.RoomRef
  end
  
  def messageReceived(line, client1)
    lineTemp = line.split(' ')      
    lastWord = lineTemp.length - 1    
    body = lineTemp[1..lastWord].join(' ')
    case lineTemp[0]
    when "LEAVE_CHATROOM:"
      client1.leavingChatroom = true
    when "DISCONNECT:"
      client1.disconnecting = true
    when "JOIN_CHATROOM:" 
      client1.joiningChatroom = true
      client1.canClientEnter(line, self)
    else
      if client1.disconnecting
        client1.clientDisconnect(line)   
      elsif client1.leavingChatroom
        chatroom = returnChatroom(client1.RoomRef)
        chatroom.removeClient(line, client1)
      elsif client1.chatroomConnected
        chatroom = returnChatroom(client1.RoomRef)
        chatroom.forwardMessage(line, client1)             
      elsif client1.joiningChatroom
        client1.canClientEnter(line, self)        
      end 
    end    
                         
  end
end

