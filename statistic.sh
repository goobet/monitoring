#!/bin/bash
while true; do 
	curl -H "Content-Type: application/json" -X POST -d '{"hostname":"'`hostname`'","cores":"'`grep processor /proc/cpuinfo | wc -l`'","load_average":"'`cat /proc/loadavg | awk '{ print $1 }'`'","memory_usage":"'`free | awk 'FNR == 3 {print $3/($3+$4)*100}'`'", "available_memory":"'`cat /proc/meminfo | grep MemTotal | awk '{ print $2/1024 }'`'","status":"up"}' http://localhost:3000/machines_statistic; 
	sleep 1; 
done;
