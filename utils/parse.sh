#!/bin/bash
#
# Quick hacky script to parse out fio json into CSV
#
for d in */
do
	if [ -d "$d" ]; 
	then
		HOST=`echo $d |  cut -d - -f3- | sed -e 's/\///'`
		DEVICE=`echo $d |  cut -d - -f1`
		echo "=> $HOST - $DEVICE"
		cd "$d"
		pwd 
		for subdir in */*
		do
			BLOCKSIZE=`echo $subdir | cut -d / -f 2`
			echo "==> Blocksize $BLOCKSIZE"
			# Grab Json files
			for file in $DEVICE/$BLOCKSIZE/*.json
			do
				oTemp=`echo $file | cut -d / -f 3`
				jobType=`echo $oTemp | cut -d - -f 1`
				if  [ "$jobType" == "randread" ] || [ "$jobType" == "read" ] ; then
					jobSubType="read"
				fi
				if [ "$jobType" == "randwrite" ] || [ "$jobType" == "write" ] ;  then
					jobSubType="write"
				fi
				echo "===> $file is type $jobType - $jobSubType"
				SLAT_NS_MEAN=`cat $file | jq .jobs[0].$jobSubType.slat_ns.mean`
				SLAT_NS_STDDEV=`cat $file | jq .jobs[0].$jobSubType.slat_ns.stddev`
				CLAT_NS_MEAN=`cat $file | jq .jobs[0].$jobSubType.clat_ns.mean`
				CLAT_NS_STDDEV=`cat $file | jq .jobs[0].$jobSubType.clat_ns.stddev`
				LAT_NS_MEAN=`cat $file | jq .jobs[0].$jobSubType.lat_ns.mean`
				LAT_NS_STDDEV=`cat $file | jq .jobs[0].$jobSubType.lat_ns.stddev`
				IO_DEPTH=`cat $file | sed -s 's/job options/job_options/' | jq .jobs[0].job_options.iodepth | sed -s 's/\"//g' `
				NO_JOBS=`cat $file | sed -s 's/job options/job_options/' | jq .jobs[0].job_options.numjobs | sed -s 's/\"//g' `
				IOPS_MEAN=` cat $file | jq .jobs[0].$jobSubType.iops_mean`
				IOPS_STDDEV=` cat $file | jq .jobs[0].$jobSubType.iops_stddev`
				BW_MEAN=` cat $file | jq .jobs[0].$jobSubType.bw_mean`
				BW_DEV=` cat $file | jq .jobs[0].$jobSubType.bw_dev`
				#echo "$SLAT_NS_MEAN"
				#echo "$IO_DEPTH / $NO_JOBS - IOPS $IOPS_MEAN"
				CSV="$jobType,$HOST,$DEVICE,$BLOCKSIZE,$IO_DEPTH,$NO_JOBS,$IOPS_MEAN,$IOPS_STDDEV,$SLAT_NS_MEAN,$SLAT_NS_STDDEV,$CLAT_NS_MEAN,$CLAT_NS_STDDEV,$LAT_NS_MEAN,$LAT_NS_STDDEV,$BW_MEAN,$BW_DEV"	
				echo >>/tmp/results-single.csv $CSV
			done
		done
		cd ".."
	fi

done

