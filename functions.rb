# q, c, g must be generated
# TODO: ds
module Functions
  def objetive_x(n)
    s0 = 0
    (0...n).each do |jc|
      s1 = 0
      (0...i).each do |ic|
        s2 = 0
        (0...m).each do |mc|
          sv1 = orijm[0] * d(ic, jc, mc, 0)
          sv2 = orijm[1] * d(ic, jc, mc, 1)
          s3 = sv1 + sv2
          s2 = s2 + s3
        end
        s1 = s1 + s2 * svt
      end
      s0 = s0 + s1
    end
    s0
  end

  def objective_y(n)
    s0 = 0
    (0...n).each do |jc|
      s1 = 0
      (0...i).each do |ic|
        s2 = 0
        (0...m).each do |mc|
          sv1 = sfcv[0] * fc(ic, jc, mc, 0)
          sv2 = sfcv[1] * fc(ic, jc, mc, 1)
          s3 = sv1 + sv2
          s2 = s2 + s3
        end
        s1 = s1 + s2
      end
      s0 = s0 + s1
    end
    s0
  end

  def objective_z(n)
    s0 = 0
    (0...n).each do |jc|
      s1 = 0
      (0...i).each do |ic|
        s2 = 0
        (0...e).each do |ec|
          s3 = 0
          (0...m).each do |mc|
            sv1 = sfcv[0] * ge(ci, cj, cm, 0, ce)
            sv2 = sfcv[1] * ge(ci, cj, cm, 1, ce)
            s4 = sv1 + sv2
          end
          s2 = s2 + scge[ec]*s3
        end
        s1 = s1 + s2
      end
      s0 = s0 + s1
    end
    s0
  end

  def d(ic, jc, mc, v)
    q[ic][jc][mc][v] * (d1(ic, jc, mc) * fpf(ic, jc, mc)) + d2(ic, jc, mc)
  end

  def d1(ic, jc, mc)
    ((0.5 * c[ic][jc] * (1 - g[ic][jc][mc] / c[ic][jc]) * (1 - g[ic][jc][mc] / c[ic][jc])) /
     ( 1 - ([1, x(ic, jc, mc)].min * g[ic][jc][mc] / c[ic][jc])))
  end

  def x(ic, jc, mc)
    (q[i][j][m][0] + q[i][j][m][1])  * c[i][j] / (g[i][j][m] * s[i][j][m]);
  end

  def d2(ic, jc, mc)
    900 * tf * ((x(ic, jc, mc) - 1) + Math.sqrt((x(ic, jc, mc) - 1) * (x(ic, jc, mc) - 1) + (8 * k * fl(ic, jc, mc) * x(ic, jc, mc)) / (bQ(ic, jc, mc) * tf)))
  end

  # "big Q"
  def bQ(ic, jc, mc)
    s[ic][jc][mc] * g[ic][jc][mc] / c[ic][jc]
  end

  def fc(ic, jc, mc, v)
    # TODO: ds
    q[ic][jc][mc][v] * (f1v[v] * xm + fp3v[v] * h(ic, jc, mc, v)) + (f2v[v] * d(ic, jc, mc, v))
  end

  def h(ic, jc, mc, v)
    0.9 * ((1 - u(ic, jc, mc)) / (1 - y(ic, jc, mc)) + (no(ic, jc, mc)) / (q[ic][jc][mc][v] * c[ic][jc]))
  end

  def u(ic, jc, mc)
    g[ic][jc][mc] / c[ic][jc];
  end

  def y(ic, jc, mc)
    (q[ic][jc][mc][0] + q[ic][jc][mc][1]) / s[ic][jc][mc]
  end

  def no(ic, jc, mc)
    xijmv = x(ic, jc, mc)
    xoijm = xo(ic, jc, mc)
    if (xijmv > xoijm)
      (bQ(ic, jc, mc) * tf / 4) * (z(ic, jc, mc) + Math.sqrt(z(ic, jc, mc) * z(ic, jc, mc) + (12 * (xijmv - xoijm)) / (bQ(ic, jc, mc) * tf)))
    else
      0
    end
  end

  def xo(ic, jc, mc)
    0.67 + s[i][j][m] * g[i][j][m] / 600.0
  end

  def z(ic, jc, mc)
    x(ic, jc, mc) - 1
  end

  def ge(ic, jc, mc, v, ec)
    # TODO: ds
    q[ic][jc][mc][v] * (ge1[v][ec] * x[mc] + ge2[v][ec] * ds[m] + ge3[v][ec] * h(ic, jc, mc, v))
  end

  def fpf(ic, jc, mc)
    index = "0.#{((10 * g[i][j][m] / c[i][j]).to_i)}0"
    pf[index] || 0
  end

  def fl(ic, jc, mc)
    xijm = x(ic, jc, mc)
    return 0.09 if xijm >= 1
    index = "0.#{((10 * xijm).to_i)}0"
    l[index] || l["1.00"]
  end
end
