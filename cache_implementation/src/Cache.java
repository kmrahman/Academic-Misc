/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
//package cache;

/**
 *
 * @author Sabid Rahman
 */

import java.io.*;
import java.util.*;
import java.lang.*;
import java.math.BigInteger;

public class Cache {

     int nst = 0 ;
     int nrd = 0;
     int stHit = 0;
     int stMiss = 0;
     int rdHit = 0;
     int rdMiss = 0;
     
     int cachSize = 0;
     int cachLS = 0;
     int assc = 0;
   
   int fileOp(String strFilePath)
   {
     try
    {

        String line ;
        FileReader fr1=new FileReader(strFilePath);
        BufferedReader br1=new BufferedReader(fr1);
        
        cBody cach= new cBody(64,64,1);
        while((line=br1.readLine())!=null)
        {
          // System.out.println(line);
 
          String[] lineUnmarsal = line.split("\\s");
          if(lineUnmarsal.length <= 2)
          {
              continue;
          }
          String req = lineUnmarsal[0];
          String add = lineUnmarsal[1];
          String access = lineUnmarsal[2];
          int accs = Integer.parseInt(access);
          lineUnmarsal = add.split(",");
          add = lineUnmarsal[0];

          BigInteger bigInteger1 = new BigInteger (add);
          int res;
          res = cach.accessCache(bigInteger1, accs);
           //System.out.println(add + " " + accs);


        if("ST".equals(req))
        {
            this.nst++;
            if(res == 0)
            {
                this.stMiss++; 
            }
            else
            {
                this.stHit++;
            }
        }
        else if(req.equals("LD"))
        {
            this.nrd++;
            if(res == 0)
            {
                this.rdMiss++; 
            }
            else
            {
                this.rdHit++;
            }
        }

        } 

 
     //  System.out.println(nst + " " + nrd);
    }
     
    catch(FileNotFoundException fe)
    {
      System.out.println("FileNotFoundException : " + fe);
    }
    catch(IOException ioe)
    {
      System.out.println("IOException : " + ioe);
    }
  
       
   return 1;
   }
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        
        if(args.length<5)
        {
             System.out.println("Not enough arguments." );
             return;
        }
        else
        {
        System.out.println(args[0] + args[1] + args[2] );
        }
         Cache c = new Cache();
         c.cachSize = Integer.parseInt(args[0]);
         c.cachLS = Integer.parseInt(args[1]);
         c.assc = Integer.parseInt(args[2]);
         
         //args[4]
         c.fileOp(args[3]);
         //c.fileOp("sample9.in");
         
         
         System.out.println(" ST " + c.nst + " ST Miss " + c.stMiss + " ST Hit " + c.stHit 
                 +  "\n LD " + c.nrd + " LD Miss " + c.rdMiss + " LD Hit " + c.rdHit);
	//args[5]
        try{
             FileWriter fwr1=new FileWriter(args[4]);
            //FileWriter fwr1=new FileWriter("out9.out");
       int totalhit = c.rdHit + c.stHit;
       int totalMiss = c.rdMiss + c.stMiss;
       int totalaction = c.nst + c.nrd;
        BufferedWriter br1=new BufferedWriter(fwr1);
        String str1 = "\nLoad-Hits: " + c.rdHit + "," + (double)100*c.rdHit/c.nrd + "%" + 
        "\nLoad-Misses:" + c.rdMiss + "," + 100*c.rdMiss/c.nrd + "%" +
            "\nLoad-Accesses:" + c.nrd + ", 100.00%" +

                "\n\nStore-Hits:" + c.stHit + "," + 100* c.stHit/c.nst + "%" +
              "\nStore-Misses:" + c.stMiss + "," + 100 * c.stMiss/c.nst + "%" +
                "\nStore-Accesses:" + c.nst + ", 100.00%" + 
            
                "\n\n Total-Hits:" +  totalhit + "," + 100* totalhit/totalaction + "%" +
                "\n Total-Misses:" + totalMiss + "," + 100* totalMiss/totalaction + "%" +
                " \n Total-Accesses:" + totalaction + "," + "100.00%";
        br1.write(str1);
        br1.close();
        }
        catch(Exception ex)
        {
            System.out.println("Output exception : " + ex);
        }
         
    }//LD 3087003508, 30 & LD 3087003516, 4
}
