// 完全グラフのためグラフを使用していない（頂点はint:頂点数nの時０ 〜 n-1）
String dir = "/Users/nakano/Desktop/instanceData/" ;
String dirF = "/Users/nakano/Desktop/data500/" ;
final int nodenum = 500 ;
final int bound = 300 ;
final int objective = 3 ;
final int experimentNum = 10 ;
final int maxint = 999999 ;
final int orderlength = 150000 ;

void setup() {
  // dir = "../../data/" ;
  int[] m = {0,1,2} ;
  paretoSolution(m) ;
  exit() ;
}

//solution：0 ~ nodenum-1 = pareto , nodenum ~ 2*nodenum-1 = update , 2*nodenum ~ 3*nodenum-1 = candidate
void paretoSolution(int[] m) {
  int[][][] weight = instanceText(m) ;
  int[][] solution = new int[orderlength][objective] ;
  int[] pre = orderReset() ;
  int[] follow = orderReset() ;
  boolean[] empty = new boolean[orderlength] ;
  int start = millis() ;
  follow[3*nodenum] = nodenum ;
  pre[3*nodenum] = nodenum ;
  follow[nodenum] = 3*nodenum ;
  pre[nodenum] = 3*nodenum ;
  empty[3*nodenum] = true ;
  boolean flag = true ;
  int searchpoint = 3*nodenum ;
  while(flag) {
    flag = false ;
    for(int j = 0 ; j < nodenum ; j++)
      for(int i = 0 ; i < nodenum ; i++)
        if(i != j) {
          int u1 = nodenum + i ;
          int u2 = 2*nodenum + i ;
          int v1 = nodenum + j ;
          int v2 = 2*nodenum + j ;
          for(int l = follow[u1] ; l != u1 ; l = follow[l]) {
            int[] path = calculation(solution[l], weight[i][j]) ;
            boolean pathflag = true ;

            for(int pa = follow[j] ; pa != j ; pa = follow[pa]) {
              int status = dominate(solution[pa], path) ;
              if (status <= 1)  {
                pathflag = false ;
                break ;
              }
              if (status == 2) {
                follow[pre[pa]] = follow[pa] ;
                pre[follow[pa]] = pre[pa] ;
                empty[pa] = false ;
              }
            }

            if(pathflag)
              for(int pa = follow[v1] ; pa != v1 ; pa = follow[pa]) {
                int status = dominate(solution[pa], path) ;
                if (status <= 1)  {
                  pathflag = false ;
                  break ;
                }
                if (status == 2) {
                  follow[pre[pa]] = follow[pa] ;
                  pre[follow[pa]] = pre[pa] ;
                  empty[pa] = false ;
                }
              }

            if(pathflag)
              for(int pa = follow[v2] ; pa != v2 ; pa = follow[pa]) {
                int status = dominate(solution[pa], path) ;
                if (status <= 1)  {
                  pathflag = false ;
                  break ;
                }
                if (status == 2) {
                  follow[pre[pa]] = follow[pa] ;
                  pre[follow[pa]] = pre[pa] ;
                  empty[pa] = false ;
                }
              }

            if(pathflag) {
              flag = true ;
              int s = emptysolution(empty, searchpoint) ;
              if(s == -1)
                s = emptysolution(empty, 3*nodenum) ;
              searchpoint = s ;
              solution[s] = path ;
              follow[s] = v2 ;
              pre[s] = pre[v2] ;
              follow[pre[v2]] = s ;
              pre[v2] = s ;
              empty[s] = true ;
            }
          }
        }
    for(int i = 0 ; i < nodenum ; i++) {
      int u1 = nodenum + i ;
      int u2 = 2*nodenum + i ;
      if(follow[u1] != u1) {
        follow[pre[i]] = follow[u1] ;
        pre[follow[u1]] = follow[pre[i]] ;
        follow[pre[u1]] = i ;
        pre[i] = pre[u1] ;
        follow[u1] = u1 ;
        pre[u1] = u1 ;
      }
      if(follow[u2] != u2) {
        follow[u1] = follow[u2] ;
        pre[u1] = pre[u2] ;
        pre[follow[u2]] = u1 ;
        follow[pre[u2]] = u1 ;
        follow[u2] = u2 ;
        pre[u2] = u2 ;
      }
    }
  }
  int times = millis() - start ;
  println(times+","+solutionSize(empty)+","+emptysolution(empty, searchpoint)) ;
}

int dominate(int[] v , int[] u) {
    int status = 0 ;
    for (int k = 0 ; k < objective ; k++) {
      int d = u[k] - v[k] ;
      if (d > 0) status |= 1 ;
      else if (d < 0) status |= 2 ;
      if (status == 3) break ;
    }
    return status ;
  }

int[] calculation(int[] update, int[] weight) {
  int[] path = new int[objective] ;
  for(int i = 0 ; i < objective ; i++)
    path[i] = update[i] + weight[i] ;
  return path ;
}

int emptysolution(boolean[] empty, int searchpoint) {
  for(int i = searchpoint ; i < orderlength ; i++)
    if(!empty[i]) return i ;
  return -1 ;
}

int solutionSize(boolean[] empty) {
  int count = 0 ;
  for(int i = 3 * nodenum ; i < orderlength ; i++)
    if(empty[i]) count++ ;
  return count ;
}

int[] orderReset() {
  int[] order = new int[orderlength] ;
  for(int i = 0 ; i < orderlength ; i++) {
    if(i < 3 * nodenum)
      order[i] = i ;
    else order[i] = -1 ;
  }
  return order ;
}

int[][][] instanceText(int[] m) {
 int[][][] weight = new int[nodenum][nodenum][objective] ;
 for (int k = 0 ; k < m.length ; k++) {
   String[] lines = loadStrings(dir + "weight_" + nodenum + "_" + bound + "_" + m[k] + ".csv");
   for(int i = 0 ; i < nodenum ; i++){
     String[] values = split(lines[i], ",") ;
     for(int j = 0 ; j < nodenum ; j++) {
       weight[i][j][k] = int(values[j]) ;
     }
   }
 }
 return weight ;
}
