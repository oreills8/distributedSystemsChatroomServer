# distributedSystemsChatroomServer

This project has the code for the distributed chatroom server. 
files client1.rb and client2.rb are for testing the chatroom. 
startServer.rb starts the server that functions as the chatroom.

startServer - sets up the threads that will handle different clients and initalises the server and client classes. This file contains the code for accepting clients on the 2500 port. 

server - contains the main file for the server. all messages pass through this class. all the messages first go the client class.

client - a client class is created for each of the clients that connect to the server. depending on the contents of the message the  message goes on to different classes. 

chatroom - this class contains all the functions nessesary for chatroom communication. and a class for the messages that are forwarded in the chatroom.

errors - this file contains a detailed list of all the potential errors in the program. each of this errors has an id associated with it. if an error occurs in the server the discription of this error is forwarded to the connected client, for whom the error occured.  

