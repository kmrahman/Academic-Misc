/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package myserver;

/**
 *
 * @author Sabid Rahman
 */
public class mathHandler extends Thread {
    MyMathClass parent;
    private String request;
    public mathHandler(MyMathClass parent, String request)
    {
        this.parent= parent;
        this.request= request;
    }
    
    public void run() 
    {
        //Code
          String[] requestUnmarshal = this.request.split(",");
          String function = requestUnmarshal[0];
          
          Double param1= Double.parseDouble(requestUnmarshal[1]);                        
          Double param2= Double.parseDouble(requestUnmarshal[2]);
          int intparam3=0;
          int intparam1=0;
          int intparam2=0;
          if(requestUnmarshal.length==4)
          {
            intparam1= (int)Double.parseDouble(requestUnmarshal[1]); 
            intparam2= (int)Double.parseDouble(requestUnmarshal[2]);
            intparam3= (int)Double.parseDouble(requestUnmarshal[3]);
          }

          
        //  System.out.println("Math thread>" + function  + param1 + param2);
          
          switch(function)
          {
              case "Add": 
                 double result = parent.magicAdd(param1, param2);
                  //System.out.println("Math thread Add result >" + result);
                  break;
              case "Sub": 
                 result = parent.magicSubtract(param1, param2);
                // System.out.println("Math thread Sub result >" + result);
                  break;
             case "Min": 
                 result = parent.magicFindMin(intparam1, intparam2,intparam3);
                 //System.out.println("Math thread Min result >" + result);
                  break;
              case "Max": 
                 result = parent.magicFindMax(intparam1, intparam2,intparam3);
                // System.out.println("Math thread Max result >" + result);
                  break;
           }
          
    }

    
}
