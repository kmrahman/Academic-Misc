/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package myserver;

import java.io.*;
import java.net.*;

/**
 *
 * @author Sabid Rahman
 */

public class MyServer extends Thread{

    /**
     * @param args the command line arguments
     */

   // ServerSocket serverSocket;
    Socket connection = null;
    ObjectOutputStream out;
    ObjectInputStream in;
    
    String message;
    

   MyMathClass mmc1;//, mmc2, mmc3, mmc4;
    
    MyServer(Socket conn) {
          this.connection = conn; 
          mmc1 = new MyMathClass();
        
    }

    public void run() {
        try {
         
            //3. get Input and Output streams
            out = new ObjectOutputStream(connection.getOutputStream());
            out.flush();
            in = new ObjectInputStream(connection.getInputStream());
            sendMessage("Connection successful");
            

            //4. The two parts communicate via the input and output streams
            do {
                try {
                    message = (String) in.readObject();
                    System.out.println("client>" + message); 
                    
                   //End connection
                    if (message.equals("bye")) {
                        //System.out.println("got bye");
                        
                        sendMessage("Bye, the total request handled" + " for client" + this.connection
                                + "is:: magicAdd: " 
                                + this.mmc1.getCounterAdd() + " magicSubtract: " 
                                + this.mmc1.getCounterSub() + " magicFindMin: "
                                + this.mmc1.getCounterMin() + " magicFindMax: "
                                + this.mmc1.getCounterMax());
                    }
                    else
                    {// //Handle requests
                       for(int i=0; i<1000;i++)
                       {
                            String request = (String) in.readObject();
                            // System.out.println("on server->"+ request);
                             Thread handler = new mathHandler(this.mmc1, request);
                             handler.start();
                            
                            try
                             {
                               this.sleep(10);
                              }
                            catch(Exception ioException)
                              {
                                 ioException.printStackTrace();
                               }
                       }
                                          
                    System.out.println("server->"+ this.mmc1.getCounterAdd()
                            + " "+ this.mmc1.getCounterSub() + " " + this.mmc1.getCounterMin()
                            + " "+ this.mmc1.getCounterMax());
                    }
                } catch (ClassNotFoundException classnot) {
                    System.err.println("Data received in unknown format");
                }
            } while (!message.equals("bye"));
        } catch (IOException ioException) {
            ioException.printStackTrace();
        } finally {
            //4: Closing connection
            try {
                in.close();
                out.close();
                connection.close();
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        }
    }

    void sendMessage(String msg) {
        try {
            out.writeObject(msg);
            out.flush();
            System.out.println("server>" + msg);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }

    public static void main(String[] args) {
        // TODO code application logic here
      //MyServer server = new MyServer();
        ServerSocket serverSocket= null;
        Socket connection = null;
        //1. creating a server socket
        try
         {
            serverSocket = new ServerSocket(2005);
         }
          catch(IOException ioException)
          {
              ioException.printStackTrace();
          }


        for (int i= 0;i <5; i++) {
          try{
           
            //2. Wait for connection
            System.out.println("Waiting for connection");
            connection = serverSocket.accept();
            System.out.println("Connection received from " + connection.getInetAddress().getHostName()
                    + " " + connection);
          }
          catch(IOException ioException)
          {
              ioException.printStackTrace();
          }
            if(connection != null)
            { 
                Thread tserver = new MyServer(connection);            
                tserver.start();
            }
           
        }
        
         try
         {
             serverSocket.close();
         }
          catch(IOException ioException)
          {
              ioException.printStackTrace();
          }
    }
    
}
