/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package colonia_de_hormigas;

/**
 *
 * @author
 * Oz
 */
public class Solution {
    
    private double[][][] g;
    private double[][] c;
    private double[][][][] q;
    private int n;
    private int I = 3;
    private int M = 8;

    private double OR[] = {1.4, 1};
    private double x = 1300;
    private double SFC[] = {3.834, 4.07};
    private double SCG[] = {4, 5, 6};
    private double SVT = 50;
    private double Tf = 0.25;
    private double k = 0.5;
    private double f1[] = {0, 0};
    private double f2[] = {0.345, 0.345};
    private double f3[] = {17.98, 17.98};
    private double ge1[][] = {{7, 14}, {7, 9}, {15, 20}};
    private double ge2[][] = {{3, 9}, {6, 9}, {9, 10}};
    private double ge3[][] = {{12, 11}, {13, 20}, {14, 20}};
    private double ds[] = {0, 0, 0, 0, 0, 0, 0, 0};
    
    private double[][] gi = {
        {11, 17, 5, 16, 11, 17, 5, 16},
        {10, 17, 5, 17, 10, 17, 5, 17},
        {11, 17, 5, 16, 11, 17, 5, 16}
    };
    private double[][] gf = {
        {17, 27, 6, 24, 17, 27, 6, 24},
        {16, 24, 7, 27, 16, 24, 7, 27},
        {16, 25, 7, 26, 16, 25, 7, 26}
    };
    private double[][] qi = {
        {211, 564, 75, 302, 141, 843, 75, 302},
        {171, 681, 73, 292, 171, 681, 73, 292},
        {141, 843, 75, 302, 211, 564, 75, 302}
    };
    private double[][] qf = {
        {377, 855, 114, 557, 214, 1506, 139, 456},
        {300, 1011, 107, 522, 252, 1201, 130, 426},
        {245, 1233, 108, 523, 309, 980, 130, 523}
    };
    private double[] ci = {65, 65, 65};
    private double[] cf = {90, 90, 90};
    private double s[][] = {
        {1770, 4989, 1770, 1827, 1770, 4989, 1770, 1827},
        {1770, 4989, 1770, 1827, 1770, 4989, 1770, 1827},
        {1770, 4989, 1770, 1827, 1770, 4989, 1770, 1827},
    };

    public Solution(int n) {
        this.n = n;
        g = new double[I][n][M];
        c = new double[I][n];
        q = new double[I][n][M][2];
        for (int i = 0; i < I; i++) {
            c[i][0] = ci[i];
            c[i][n - 1] = cf[i];
            for (int m = 0; m < M; m++) {
                q[i][0][m][0] = qi[m][i] * 0.98;
                q[i][0][m][1] = qi[m][i] * 0.02;
                g[i][0][m] = gi[m][i];
                q[i][n - 1][m][0] = qf[m][i] * 0.98;
                q[i][n - 1][m][1] = qf[m][i] * 0.02;
                g[i][n - 1][m] = gf[m][i];
            }
        }
        for (int i = 0; i < I; i++) {
            for (int m = 0; m < M; m++) {
                for (int j = 1; j < n - 2; j++) {
                    q[i][j][m][0] = q[i][j - 1][m][0] + (q[i][n - 1][m][0] - q[i][0][m][0]) / (double) n;
                    q[i][j][m][1] = q[i][j - 1][m][1] + (q[i][n - 1][m][1] - q[i][0][m][1]) / (double) n;
                }
            }
        }
        
    }

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
                        s3 += SFC[v] * FC(i, j, m, v, V);
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
                            s4 += SFC[v] * GE(i, j, m, v, e, V);
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
        return q[i][j][m][v] * (d1(i, j, m) * PF(i, j, m) + d2(i, j, m));
    }

    private double d1(int i, int j, int m) {
        return ((0.5 * c[i][j] * (1 - g[i][j][m] / c[i][j]) * (1 - g[i][j][m] / c[i][j])) / ( 1 - (Math.min(1, X(i, j, m)) * g[i][j][m] / c[i][j])));
    }
    
    private double X(int i, int j, int m) {
        return (q[i][j][m][0] + q[i][j][m][1])  * c[i][j] / (g[i][j][m] * s[i][m]);
    }

    private double d2(int i, int j, int m) {
        return 900 * Tf * ((X(i, j, m) - 1) + Math.sqrt((X(i, j, m) - 1) * (X(i, j, m) - 1) + (8 * k * l(i, j, m) * X(i, j, m)) / (Q(i, j, m) * Tf)));
    }

    private double Q(int i, int j, int m) {
        return s[i][m] * g[i][j][m] / c[i][j];
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
        return s0 / s[i][m];
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
        return 0.67 + s[i][m] * g[i][j][m] / 600.0;
    }

    private double Z(int i, int j, int m) {
        return X(i, j, m) - 1;
    }

    private double GE(int i, int j, int m, int v, int e, int V) {
        return  q[i][j][m][v] * (ge1[v][e] * x + ge2[v][e] * ds[m] + ge3[v][e] * h(i, j, m, v, V));
    }
    
    private double PF(int i, int j, int m) {
        switch ((int) (10 * g[i][j][m] / c[i][j])) {
            case 2: return 1.000;
            case 3: return 0.986;
            case 4: return 0.895;
            case 5: return 0.767;
            case 6: return 0.576;
            case 7: return 0.256;
            default: return 0;
        }
    }
    
    private double l(int i, int j, int m) {
        if (X(i, j, m) >= 1) {
            return 0.09;
        } else {
            switch ((int) (10 * X(i, j, m))) {
                case 4: return 0.992;
                case 5: return 0.858;
                case 6: return 0.769;
                case 7: return 0.650;
                case 8: return 0.500;
                case 9: return 0.314;
                default: return 1;
            }
        }
    }
    
}
