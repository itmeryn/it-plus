
#!/bin/bash 
Njob=100 #任务总数 
Nproc=15 #最大并发进程数  
function PushQue {      #将PID值追加到队列中 
           Que="$Que $1" 
           Nrun=$(($Nrun+1)) 
}
 
function GenQue {       #更新队列信息，先清空队列信息，然后检索生成新的队列信息 
           OldQue=$Que 
           Que=""; Nrun=0 
           for PID in $OldQue; do 
                 if [[ -d /proc/$PID ]]; then 
                        PushQue $PID 
                 fi 
           done 
}
 
function ChkQue {       #检查队列信息，如果有已经结束了的进程的PID，那么更新队列信息 
           OldQue=$Que 
           for PID in $OldQue; do 
                 if [[ ! -d /proc/$PID ]];   then 
                 GenQue; break 
                 fi 
           done 
} 
 
for ((i=1; i<=$Njob; i++)); do 
           curl baidu.com & 
           PID=$! 
           PushQue $PID 
           while [[ $Nrun -ge $Nproc ]]; do          # 如果Nrun大于Nproc，就一直ChkQue 
                 ChkQue 
                 sleep 0.1 
           done 
done 
wait
 
echo -e "time-consuming: $SECONDS   seconds" 
