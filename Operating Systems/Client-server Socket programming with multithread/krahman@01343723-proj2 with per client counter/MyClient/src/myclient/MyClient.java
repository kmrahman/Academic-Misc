/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package myclient;

/**
 *
 * @author Sabid Rahman
 */

import java.io.*;
import java.net.*;
import java.util.*;

public class MyClient {

    /**
     * @param args the command line arguments
     */
    Socket clientSocket;
    ObjectOutputStream out;
    ObjectInputStream in;
    String message;

    MyClient() {
    }

    void run() {
        try {
            //1. creating a socket to connect to the server
            clientSocket = new Socket("localhost", 2005);
            System.out.println("Connected to localhost in port 2005");
            //2. get Input and Output streams
            out = new ObjectOutputStream(clientSocket.getOutputStream());
            out.flush();
            in = new ObjectInputStream(clientSocket.getInputStream());
            //3: Communicating with the server
            do {
                try {
                    message = (String) in.readObject();
                    System.out.println("server>" + message);
                    sendMessage("Hi my server, this is client");
                    
                    //send requests
                    for(int i=0; i<1000;i++)
                    {    
                        message = randomRequest();
                        sendMessage(message);
                    }
                    
                    //end connection
                    message = "bye";
                    sendMessage(message);
                    
                    String finalmessage = (String) in.readObject();
                    System.out.println("server>" + finalmessage);                                 

                    
                } catch (ClassNotFoundException classNot) {
                    System.err.println("data received in unknown format");
                }
            } while (!message.equals("bye"));
        } catch (UnknownHostException unknownHost) {
            System.err.println("You are trying to connect to an unknown host!");
        } catch (IOException ioException) {
            ioException.printStackTrace();
        } finally {
            //4: Closing connection
            try {
                in.close();
                out.close();
                clientSocket.close();
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        }
    }

    void sendMessage(String msg) {
        try {
            out.writeObject(msg);
            out.flush();
            System.out.println("client>" + msg);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }
    
    String randomRequest()
    {
        String msg="";
        Random generator = new Random();
        int randomFunc = generator.nextInt(4);
        
        switch (randomFunc)
        {
            case 0:
            {   double a = generator.nextDouble();
                double b = generator.nextDouble();
                 a = a*100;
                 b= b*10;
                msg= "Add,"+ a + ","+ b;
                break;
            }
            case 1:        
            {
                double a = generator.nextDouble();
                double b = generator.nextDouble();
                a = a*100;
                 b= b*10;
                 msg= "Sub,"+ a + "," + b;
                 break;
            }
            case 2:
            {
               int a = generator.nextInt(1000);
               int b = generator.nextInt(1000);
               int c = generator.nextInt(1000);
               msg = "Min," + a + "," + b + "," + c;
               break;
            }
            case 3:
            {
               int a = generator.nextInt(1000);
               int b = generator.nextInt(1000);
               int c = generator.nextInt(1000);
               msg = "Max," + a + "," + b + "," + c;
               break;
            }
              
        }
        
        
        return msg;
    }

    public static void main(String[] args) {
        // TODO code application logic here
        MyClient client = new MyClient();
        client.run();    
    }
}
