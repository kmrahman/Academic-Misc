/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
//package cache;

import java.io.*;
import java.util.*;
import java.lang.*;
import java.math.BigInteger;

/**
 *
 * @author Sabid Rahman
 */
public class cBody {
      int nBlocks;
     int nSets;
     int cacheSize;
     int cacheLineSize;
     int assoc;

     int blockBits;
     int setBits;
     int tagBits;


     int [][] cach;
     int [] RR;

     
     cBody(int cSize, int cLineSize, int assoc)
     {
         this.cacheSize= cSize;
         this.cacheLineSize= cLineSize;
         this.assoc = assoc;
         nBlocks = cacheSize*1024/cacheLineSize;
	 this.nSets = this.nBlocks/this.assoc;

	 this.blockBits = (int)(Math.log(this.cacheLineSize)/Math.log(2));
	 this.setBits = (int) (Math.log(nSets)/Math.log(2));

	 this.tagBits = 32 - this.blockBits - this.setBits;
	// System.out.println(blockBits + " " + setBits + " " + tagBits );
         

         cach = new int[nSets][this.assoc];
         
          for(int i=0;i<nSets;i++)
          {	for(int j=0;j<this.assoc;j++)
               {
                   cach[i][j] = -1; 
                }
          }
          RR = new int[nSets];
          for(int k=0;k< nSets;k++)
          {
              RR[k] = this.assoc -1;
          }
         
     }     

     int inCache(BigInteger address, int bytestoAccess)
    {

         long add = address.longValue();
	 int index=(int)(add>>(blockBits + setBits))% nSets;
	 int tag=(int)(add>>(blockBits + setBits))/nSets;


	int blkOffset ;
        blkOffset =  (int)( add % (this.cacheLineSize));

	for(int i= 0; i<assoc; i++)
	{	if(cach[index][i] == tag)
                {	
                    if( (blkOffset+ bytestoAccess)> this.cacheLineSize)
                    {
                       // System.out.println(index + " " + nSets +  "\n ");
                            if((index+ 1) >= this.nSets)
                            {
                                insert(index,tag);
                                insert(0, tag+1);
                                return -1;
                            }
                        for(int x = 0; x<assoc; x++)
                        {	
                            if(cach[index+1][x] == tag)
                            {
                                return i;
                             }
                        }
                        insert(index,tag);
                     //   if(index >= this.nSets)
                        {
                             insert(index+1, tag );
                        }
                       // System.out.println(" Evil! ");
                        return -1;
                    }
                      //System.out.println(" Evil! ");
                    return i;
                }
         
	}

        insert(index,tag);
	return -1;
}

     void insert(int index, int tag)
    {
         
	int i = RR[index];

         
             cach[index][i]= tag;
         
   	RR[index]--;

   	if(RR[index] == -1)
        { 
            RR[index] = this.assoc-1;
        }
   
    }


   int accessCache(BigInteger address, int bytestoAccess)
{
    int i = inCache(address,bytestoAccess);
	//System.out.println("In acces " + i );
	if(i==-1)
	{
                return 0;
	}
	else
	{
        return 1;

	}

} 
 
    
}
