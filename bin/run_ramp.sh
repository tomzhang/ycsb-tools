source ./config 
source ./lib/validate-config

outputdir=./output/$(date +%Y-%h-%d-%H:%M)
mkdir -p $outputdir

for threads in 8 16 
do
	for workload in update-heavy read-mostly read-only
	do
		workload_name=$dataset-${threads}threads-$workload
		./downloads/mongodb-linux-x86_64-2.6.0/bin/mongostat --noheaders --host $url --discover > $outputdir/${workload_name}-mongostat & 
		PID=$!
		./YCSB/bin/ycsb run mongodb -P ./datasets/$dataset -P ./workloads/$workload -p mongodb.url=$url -p maxexecutiontime=$seconds -threads $threads -s -t &> $outputdir/$workload_name
		kill $PID
	done
done
