#!/bin/sh

while true
do
    /root/expect.sh
    sleep 60
done

# 默认都是放在了root目录下，当然是可以优化成相对目录的。
# 另外实际上应该可以写成一个单一脚本，对shell不熟悉，不太清楚如何替代expect的自动填充密码效果，而且在测试过程中发现expect直接做循环似乎有些问题，可能是我自己的问题。
# 可以做成服务。或者直接nohup
# 参数如自动执行的时间间隔可以根据实际情况调整，事实上应该是自动获取和调整的。
# 具体的，获取待分配奖励的量可以通过这个来获取：desmos query distribution commission  [validator] 和 desmos query distribution [validator] 
# 但是在我这里没有太大的必要，如果是竞赛性质的争投票权，或者gas费率会不断调整的情况下，需要更多地优化和调整
