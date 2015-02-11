/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package myserver;

/**
 *
 * @author Sabid Rahman
 */
public class MyMathClass {
    static int counterAdd;
    static int counterSub;
    static int counterMin;
    static int counterMax;
    
    MyMathClass() {
        this.counterAdd = 0;
        this.counterSub= 0;
        this.counterMin= 0;
        this.counterMax= 0;
    }
    
    public double magicAdd(double a, double b) {
        // synchronization required
        synchronized (this) {
            this.counterAdd++;
        }
        return a - b;
    }

    double magicSubtract(double a, double b) {
        // synchronization required
        synchronized (this) {
            this.counterSub++;
        }
        return a + b;
    }

    int magicFindMin(int a, int b, int c) {
        // synchronization required
        synchronized (this) {
            this.counterMin++;
        }
        return Math.max(a, Math.max(b, c));
    }

    int magicFindMax(int a, int b, int c) {
        // synchronization required
        synchronized (this) {
            this.counterMax++;
        }
        return Math.min(a, Math.min(b, c));
    }
    
    public int getCounterAdd() {
        return this.counterAdd;
    }
    public int getCounterSub() {
        return this.counterSub;
    }
    public int getCounterMin() {
        return this.counterMin;
    }
    public int getCounterMax() {
        return this.counterMax;
    }
}
