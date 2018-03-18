L[O] = [O]
L[A] := [A] + merge(L[O],O) = [A]+ merge(O,O) = [A,O]
L[B] = [B,O]
L[C] = [C,O]
L[K1] := [K1] + merge(L[A],L[B],[A,B]) = [K1] + merge([A,O],[B,O],[A,B]) = [K1,A] + merge([O],[B,O],[B]) = [K1,A,B] + merge([O],[O]) = [K1,A,B,O]
L[K2] := [K2] + merge(L[A],L[C],[A,C]) = [K2] + merge([A,O],[C,O],[A,C]) = [K2,A] + merge([O],[C,O],[C]) = [K2,A,C] + merge([O],[O]) = [K2,A,C,O]
L[Z] := [Z] + merge(L[K1],L[K2],[K1,K2]) = [Z] + merge([K1,A,B,O],[K2,A,C,O],[K1,K2]) = [Z,K1] + merge([A,B,O],[K2,A,C,O],[K2]) = [Z,K1,A] + merge([B,O],[K2,C,O],[K2]) = [Z,K1,A,B] + merge([O],[K2,C,O],[K2]) = [Z,K1,A,B,K2] + merge([O],[C,O]) = [Z,K1,A,B,K2,C] + merge([O],[O]) = [Z,K1,A,B,K2,C,O]

不过根据这个算法：新算法与基于深度遍历的算法类似，但是不同在于新算法会对深度优先遍历得到的搜索路径进行额外的检查。其从左到右扫描得到的搜索路径，对于每一个节点解释器都会判断该节点是不是好的节点。如果不是好的节点，那么将其从当前的搜索路径中移除。

先深度优先得到：[Z,K1,A,O,B,O,K2,A,O,C,O]
然后根据上述算法排除后为：[Z,K1,B,K2,A,C,O]

不知道这两个结果哪个是对的，求解

参考：
http://kaiyuan.me/2016/04/27/C3_linearization/
https://en.wikipedia.org/wiki/C3_linearization