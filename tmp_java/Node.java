/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package colonia_de_hormigas;

/**
 *
 * @author nestor
 */
public class Node {

    private double g[][][];
    private double c[][];
    private double q[][][][];
    
    private double OR[];
    private double x = 1300;
    private double PF[][][];
    private double SCF[];
    private double SCG[];
    private double SVT = 0;
    private double s[][][];
    private double Tf;
    private int k;
    private int l;
    private double f1[];
    private double f2[];
    private double f3[];
    private double ge1[][];
    private double ge2[][];
    private double ge3[][];
    private double ds[];

    public double getObjectiveX(int n, int I, int M, int V) {
        double s0 = 0;
        for (int j = 0; j < n; j++) {
            double s1 = 0;
            for (int i = 0; i < I; i++) {
                double s2 = 0;
                for (int m = 0; m < M; m++) {
                    double s3 = 0;
                    for (int v = 0; v < V; v++) {
                        s3 += OR[v] * D(i, j, m, v);
                    }
                    s2 += s3;
                }
                s1 += s2 * SVT;
            }
            s0 += s1;
        }
        return s0;
    }
    
    public double getObjectiveY(int n, int I, int M, int V) {
        double s0 = 0;
        for (int j = 0; j < n; j++) {
            double s1 = 0;
            for (int i = 0; i < I; i++) {
                double s2 = 0;
                for (int m = 0; m < M; m++) {
                    double s3 = 0;
                    for (int v = 0; v < V; v++) {
                        s3 += SCF[v] * FC(i, j, m, v, V);
                    }
                    s2 += s3;
                }
                s1 += s2;
            }
            s0 += s1;
        }
        return s0;
    }
    
    public double getObjectiveZ(int n, int I, int M, int V, int E) {
        double s0 = 0;
        for (int j = 0; j < n; j++) {
            double s1 = 0;
            for (int i = 0; i < I; i++) {
                double s2 = 0;
                for (int e = 0; e < E; e++) {
                    double s3 = 0;
                    for (int m = 0; m < M; m++) {
                        double s4 = 0;
                        for (int v = 0; v < V; v++) {
                            s4 += SCF[v] * GE(i, j, m, v, e, V);
                        }
                        s3 += s4;
                    }
                    s2 += SCG[e] * s3;
                }
                s1 += s2;
            }
            s0 += s1;
        }
        return s0;
    }

    private double D(int i, int j, int m, int v) {
        return q[i][j][m][v] * (d1(i, j, m) * PF[i][j][m]) + d2(i, j, m);
    }

    private double d1(int i, int j, int m) {
        return ((0.5 * c[i][j] * (1 - g[i][j][m] / c[i][j]) * (1 - g[i][j][m] / c[i][j])) / ( 1 - (Math.min(1, X(i, j, m)) * g[i][j][m] / c[i][j])));
    }
    
    private double X(int i, int j, int m) {
        return (q[i][j][m][0] + q[i][j][m][1])  * c[i][j] / (g[i][j][m] * s[i][j][m]);
    }

    private double d2(int i, int j, int m) {
        return 900 * Tf * ((X(i, j, m) - 1) + Math.sqrt((X(i, j, m) - 1) * (X(i, j, m) - 1) + (8 * k * l * X(i, j, m)) / (Q(i, j, m) * Tf)));
    }

    private double Q(int i, int j, int m) {
        return s[i][j][m] * g[i][j][m] / c[i][j];
    }

    private double FC(int i, int j, int m, int v, int V) {
        return  q[i][j][m][v] * (f1[v] * x + f2[v] * ds[m] + f3[v] * h(i, j, m, v, V));
    }

    private double h(int i, int j, int m, int v, int V) {
        return 0.9 * ((1 - u(i, j, m)) / (1 - y(i, j, m, V)) + (No(i , j, m)) / (q[i][j][m][v] * c[i][j]));
    }

    private double u(int i, int j, int m) {
        return g[i][j][m] / c[i][j];
    }

    private double y(int i, int j, int m, int V) {
        double s0 = 0;
        for (int v = 0; v < V; v++) {
            s0 += q[i][j][m][v];
        }
        return s0 / s[i][j][m];
    }

    private double No(int i, int j, int m) {
        double Xijmv = X(i, j, m);
        double Xoijm = Xo(i, j, m);
        if (Xijmv > Xoijm) {
            return (Q(i, j, m) * Tf / 4) * (Z(i, j, m) + Math.sqrt(Z(i, j, m) * Z(i, j, m) + (12 * (Xijmv - Xoijm)) / (Q(i, j, m) * Tf)));
        } else {
            return 0;
        }
    }

    private double Xo(int i, int j, int m) {
        return 0.67 + s[i][j][m] * g[i][j][m] / 600.0;
    }

    private double Z(int i, int j, int m) {
        return X(i, j, m) - 1;
    }

    private double GE(int i, int j, int m, int v, int e, int V) {
        return  q[i][j][m][v] * (ge1[v][e] * x + ge2[v][e] * ds[m] + ge3[v][e] * h(i, j, m, v, V));
    }
    
}