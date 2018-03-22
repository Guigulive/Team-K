L[O] = [O]
L[A] := [A] + merge(L[O],O) = [A]+ merge(O,O) = [A,O]
L[B] = [B,O]
L[C] = [C,O]
L[K1] := [K1] + merge(L[A],L[B],[A,B]) = [K1] + merge([A,O],[B,O],[A,B]) = [K1,A] + merge([O],[B,O],[B]) = [K1,A,B] + merge([O],[O]) = [K1,A,B,O]
L[K2] := [K2] + merge(L[A],L[C],[A,C]) = [K2] + merge([A,O],[C,O],[A,C]) = [K2,A] + merge([O],[C,O],[C]) = [K2,A,C] + merge([O],[O]) = [K2,A,C,O]
L[Z] := [Z] + merge(L[K1],L[K2],[K1,K2]) = [Z] + merge([K1,A,B,O],[K2,A,C,O],[K1,K2]) = [Z,K1] + merge([A,B,O],[K2,A,C,O],[K2]) = [Z,K1,A] + merge([B,O],[K2,C,O],[K2]) = [Z,K1,A,B] + merge([O],[K2,C,O],[K2]) = [Z,K1,A,B,K2] + merge([O],[C,O]) = [Z,K1,A,B,K2,C] + merge([O],[O]) = [Z,K1,A,B,K2,C,O]

同样可以用另一种算法描述：
先深度优先得到：[Z,K2,C,O,A,O,K1,B,O,A,O]
去掉「坏」（后面有继承自它的节点）节点后：[Z,K1,A,B,K2,C,O]

参考：
http://kaiyuan.me/2016/04/27/C3_linearization/
https://en.wikipedia.org/wiki/C3_linearization