// // 完全グラフのためグラフを使用していない（頂点はint:頂点数nの時０ 〜 n-1）
// String dir = "/Users/nakano/Desktop/instanceData/" ;
// String dirF = "/Users/nakano/Desktop/data500/" ;
// final int nodenum = 500 ;
// final int bound = 300 ;
// final int objective = 3 ;
// final int experimentNum = 10 ;
// final int maxint = 999999 ;
// final int orderlength = 160000 ;
// final int follow = objective ;
// final int pre = objective + 1 ;
// final int empty = objective + 2 ;
// int removecount = 0 ;
// int addcount = 0 ;
//
// void setup() {
//   // dir = "../../data/" ;
//   int[] m = {0,1,2} ;
//   paretoSolution(m) ;
//   exit() ;
// }
//
// //solution：0 ~ nodenum-1 = pareto , nodenum ~ 2*nodenum-1 = update , 2*nodenum ~ 3*nodenum-1 = candidate
// void paretoSolution(int[] m) {
//   int[][][] weight = instanceText(m) ;
//   int[][] solution = solutionReset() ;
//   int start = millis() ;
//   // for(int i = 0 ; i < objective ; i++)
//   //   solution[3*nodenum][i] = 0 ;
//   solution[3*nodenum][objective] = nodenum ;
//   solution[3*nodenum][objective+1] = nodenum ;
//   solution[nodenum][objective] = 3*nodenum ;
//   solution[nodenum][objective+1] = 3*nodenum ;
//   solution[3*nodenum][empty] = 1 ;
//   boolean flag = true ;
//   int searchpoint = 3*nodenum ;
//   while(flag) {
//     flag = false ;
//     // for(int i = 0 ; i < nodenum ; i++)
//     //   for(int j = 0 ; j < nodenum ; j++)
//     for(int j = 0 ; j < nodenum ; j++)
//       for(int i = 0 ; i < nodenum ; i++)
//         if(i != j) {
//           int u1 = nodenum + i ;
//           int u2 = 2*nodenum + i ;
//           int v1 = nodenum + j ;
//           int v2 = 2*nodenum + j ;
//           for(int l = solution[u1][follow] ; l != u1 ; l = solution[l][follow]) {
//             int[] path = calculation(solution[l], weight[i][j]) ;
//             boolean pathflag = true ;
//
//             for(int pa = solution[j][follow] ; pa != j ; pa = solution[pa][follow]) {
//               int status = dominate(solution[pa], path) ;
//               if (status <= 1)  {
//                 pathflag = false ;
//                 break ;
//               }
//               if (status == 2) {
//                 removecount++ ;
//                 solution[solution[pa][pre]][follow] = solution[pa][follow] ;
//                 solution[solution[pa][follow]][pre] = solution[pa][pre] ;
//                 solution[pa][empty] = 0 ;
//               }
//             }
//
//             if(pathflag)
//               for(int pa = solution[v1][follow] ; pa != v1 ; pa = solution[pa][follow]) {
//                 int status = dominate(solution[pa], path) ;
//                 if (status <= 1)  {
//                   pathflag = false ;
//                   break ;
//                 }
//                 if (status == 2) {
//                   removecount++ ;
//                   solution[solution[pa][pre]][follow] = solution[pa][follow] ;
//                   solution[solution[pa][follow]][pre] = solution[pa][pre] ;
//                   solution[pa][empty] = 0 ;
//                 }
//               }
//
//             if(pathflag)
//               for(int pa = solution[v2][follow] ; pa != v2 ; pa = solution[pa][follow]) {
//                 int status = dominate(solution[pa], path) ;
//                 if (status <= 1)  {
//                   pathflag = false ;
//                   break ;
//                 }
//                 if (status == 2) {
//                   removecount++ ;
//                   solution[solution[pa][pre]][follow] = solution[pa][follow] ;
//                   solution[solution[pa][follow]][pre] = solution[pa][pre] ;
//                   solution[pa][empty] = 0 ;
//                 }
//               }
//
//             if(pathflag) {
//               addcount++ ;
//               flag = true ;
//               int s = emptysolution(solution, searchpoint) ;
//               if(s == -1)
//                 s = emptysolution(solution, 3*nodenum) ;
//               searchpoint = s ;
//               for(int k = 0 ; k < objective ; k++)
//                 solution[s][k] = path[k] ;
//               solution[s][follow] = v2 ;
//               solution[s][pre] = solution[v2][pre] ;
//               solution[solution[v2][pre]][follow] = s ;
//               solution[v2][pre] = s ;
//               solution[s][empty] = 1 ;
//             }
//           }
//         }
//     for(int i = 0 ; i < nodenum ; i++) {
//       int u1 = nodenum + i ;
//       int u2 = 2*nodenum + i ;
//       if(solution[u1][follow] != u1) {
//         solution[solution[i][pre]][follow] = solution[u1][follow] ;
//         solution[solution[u1][follow]][pre] = solution[solution[i][pre]][follow] ;
//         solution[solution[u1][pre]][follow] = i ;
//         solution[i][pre] = solution[u1][pre] ;
//         solution[u1][follow] = u1 ;
//         solution[u1][pre] = u1 ;
//       }
//       if(solution[u2][follow] != u2) {
//         solution[u1][follow] = solution[u2][follow] ;
//         solution[u1][pre] = solution[u2][pre] ;
//         solution[solution[u2][follow]][pre] = u1 ;
//         solution[solution[u2][pre]][follow] = u1 ;
//         solution[u2][follow] = u2 ;
//         solution[u2][pre] = u2 ;
//       }
//     }
//     println(solutionSize(solution)+","+addcount+","+removecount) ;
//   }
//   int times = millis() - start ;
//   println(times+","+solutionSize(solution)) ;
// }
//
// int dominate(int[] v , int[] u) {
//     int status = 0 ;
//     for (int k = 0 ; k < objective ; k++) {
//       int d = u[k] - v[k] ;
//       if (d > 0) status |= 1 ;
//       else if (d < 0) status |= 2 ;
//       if (status == 3) break ;
//     }
//     return status ;
//   }
//
// int[] calculation(int[] update, int[] weight) {
//   int[] path = new int[objective] ;
//   for(int i = 0 ; i < objective ; i++)
//     path[i] = update[i] + weight[i] ;
//   return path ;
// }
//
// int emptysolution(int[][] solution, int searchpoint) {
//   for(int i = searchpoint ; i < orderlength ; i++)
//     if(solution[i][empty] == 0) return i ;
//   return -1 ;
// }
//
// int solutionSize(int[][] solution) {
//   int count = 0 ;
//   for(int i = 3 * nodenum ; i < orderlength ; i++)
//     if(solution[i][empty] != 0) count++ ;
//   return count ;
// }
//
// //[値，値，値，後，前]
// int[][] solutionReset() {
//   int[][] solution = new int[orderlength][objective + 3] ;
//   for(int i = 0 ; i < orderlength ; i++) {
//     if(i < 3 * nodenum) {
//       solution[i][follow] = i ;
//       solution[i][pre] = i ;
//     }
//     solution[i][empty] = 0 ;
//   }
//   return solution ;
// }
//
// int[][][] instanceText(int[] m) {
//  int[][][] weight = new int[nodenum][nodenum][objective] ;
//  for (int k = 0 ; k < m.length ; k++) {
//    String[] lines = loadStrings(dir + "weight_" + nodenum + "_" + bound + "_" + m[k] + ".csv");
//    for(int i = 0 ; i < nodenum ; i++){
//      String[] values = split(lines[i], ",") ;
//      for(int j = 0 ; j < nodenum ; j++) {
//        weight[i][j][k] = int(values[j]) ;
//      }
//    }
//  }
//  return weight ;
// }

// 完全グラフのためグラフを使用していない（頂点はint:頂点数nの時０ 〜 n-1）
String dir = "/Users/nakano/Desktop/instanceData/" ;
String dirF = "/Users/nakano/Desktop/data500/" ;
final int nodenum = 500 ;
final int bound = 300 ;
final int objective = 3 ;
final int experimentNum = 10 ;
final int maxint = 999999 ;
final int orderlength = 160000 ;
final int follow = objective ;
final int pre = objective + 1 ;
final int empty = objective + 2 ;

void setup() {
  // dir = "../../data/" ;
  int[] m = {0,1,2} ;
  paretoSolution(m) ;
  exit() ;
}

//solution：0 ~ nodenum-1 = pareto , nodenum ~ 2*nodenum-1 = update , 2*nodenum ~ 3*nodenum-1 = candidate
void paretoSolution(int[] m) {
  int[][][] weight = instanceText(m) ;
  int[][] solution = solutionReset() ;
  int start = millis() ;
  solution[3*nodenum][objective] = nodenum ;
  solution[3*nodenum][objective+1] = nodenum ;
  solution[nodenum][objective] = 3*nodenum ;
  solution[nodenum][objective+1] = 3*nodenum ;
  solution[3*nodenum][empty] = 1 ;
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
          for(int l = solution[u1][follow] ; l != u1 ; l = solution[l][follow]) {
            int[] path = calculation(solution[l], weight[i][j]) ;
            boolean pathflag = true ;

            for(int pa = solution[j][follow] ; pa != j ; pa = solution[pa][follow]) {
              int status = dominate(solution[pa], path) ;
              if (status <= 1)  {
                pathflag = false ;
                break ;
              }
              if (status == 2) {
                solution[solution[pa][pre]][follow] = solution[pa][follow] ;
                solution[solution[pa][follow]][pre] = solution[pa][pre] ;
                solution[pa][empty] = 0 ;
              }
            }

            if(pathflag)
              for(int pa = solution[v1][follow] ; pa != v1 ; pa = solution[pa][follow]) {
                int status = dominate(solution[pa], path) ;
                if (status <= 1)  {
                  pathflag = false ;
                  break ;
                }
                if (status == 2) {
                  solution[solution[pa][pre]][follow] = solution[pa][follow] ;
                  solution[solution[pa][follow]][pre] = solution[pa][pre] ;
                  solution[pa][empty] = 0 ;
                }
              }

            if(pathflag)
              for(int pa = solution[v2][follow] ; pa != v2 ; pa = solution[pa][follow]) {
                int status = dominate(solution[pa], path) ;
                if (status <= 1)  {
                  pathflag = false ;
                  break ;
                }
                if (status == 2) {
                  solution[solution[pa][pre]][follow] = solution[pa][follow] ;
                  solution[solution[pa][follow]][pre] = solution[pa][pre] ;
                  solution[pa][empty] = 0 ;
                }
              }

            if(pathflag) {
              flag = true ;
              int s = emptysolution(solution, searchpoint) ;
              if(s == -1)
                s = emptysolution(solution, 3*nodenum) ;
              searchpoint = s ;
              for(int k = 0 ; k < objective ; k++)
                solution[s][k] = path[k] ;
              solution[s][follow] = v2 ;
              solution[s][pre] = solution[v2][pre] ;
              solution[solution[v2][pre]][follow] = s ;
              solution[v2][pre] = s ;
              solution[s][empty] = 1 ;
            }
          }
        }
    for(int i = 0 ; i < nodenum ; i++) {
      int u1 = nodenum + i ;
      int u2 = 2*nodenum + i ;
      if(solution[u1][follow] != u1) {
        solution[solution[i][pre]][follow] = solution[u1][follow] ;
        solution[solution[u1][follow]][pre] = solution[solution[i][pre]][follow] ;
        solution[solution[u1][pre]][follow] = i ;
        solution[i][pre] = solution[u1][pre] ;
        solution[u1][follow] = u1 ;
        solution[u1][pre] = u1 ;
      }
      if(solution[u2][follow] != u2) {
        solution[u1][follow] = solution[u2][follow] ;
        solution[u1][pre] = solution[u2][pre] ;
        solution[solution[u2][follow]][pre] = u1 ;
        solution[solution[u2][pre]][follow] = u1 ;
        solution[u2][follow] = u2 ;
        solution[u2][pre] = u2 ;
      }
    }
  }
  int times = millis() - start ;
  println(times+","+solutionSize(solution)) ;
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

int emptysolution(int[][] solution, int searchpoint) {
  for(int i = searchpoint ; i < orderlength ; i++)
    if(solution[i][empty] == 0) return i ;
  return -1 ;
}

int solutionSize(int[][] solution) {
  int count = 0 ;
  for(int i = 3 * nodenum ; i < orderlength ; i++)
    if(solution[i][empty] != 0) count++ ;
  return count ;
}

//[値，値，値，後，前]
int[][] solutionReset() {
  int[][] solution = new int[orderlength][objective + 3] ;
  for(int i = 0 ; i < orderlength ; i++) {
    if(i < 3 * nodenum) {
      solution[i][follow] = i ;
      solution[i][pre] = i ;
    }
    solution[i][empty] = 0 ;
  }
  return solution ;
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
