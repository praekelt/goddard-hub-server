# find each of the snapshot gz files
find /var/log/node/ -mtime 0 | grep .tar.gz | while read line; do

	# make the temp build folder
	mkdir -p /var/log/node.build

	# untar the log build folder
    tar -xf $line -C /var/log/node.build/

    # find all the log file in the log.build cache folder
    find /var/log/node.build/ | grep .log | while read logline; do

    	# read in with the script
    	cd /var/repos/goddard-hub-server/scripts

    	# right so run our scripts
    	python parse_nginx_logs.py --snapshot "$line" --log_file "$logline"

    done

    # change to the script directory
	cd /var/repos/goddard-hub-server/scripts

    # end by running the dashboard calc
    python calculate_dashboards.py

    # delete our cache of build
    rm -R /var/log/node.build/*

done