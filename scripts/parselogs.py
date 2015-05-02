#!/usr/bin/python
import psycopg2
import psycopg2.extras
import re
import pprint
from datetime import datetime
import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument('--log_file', help='The full path/filename of the log file to parse.', required=True)
parser.add_argument('--node_id', help='The id of the Node.', required=True)
parser.add_argument('--log_type', help="The type of log file being parsed. Options are 'nginx' or 'captiveportal'.", required=True)
args = parser.parse_args()

#################################
# Open the file
# read the lines    
# Loop through the lines
#   - Check for 200s
#   - Insert or Increment a counter for the specified node/hour

NODE_ID = args.node_id

# 30/Apr/2015:08:55:56 +0000
NGINX_DATE_FORMAT = "%d/%b/%Y:%H:%M:%S +0000"
counter = {}

conf = '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"'
regex = ''.join(
    '(?P<' + g + '>.*?)' if g else re.escape(c)
    for g, c in re.findall(r'\$(\w+)|(.)', conf))


def db_connect():
    conn_string = os.environ['DB_URL']
    conn = psycopg2.connect(conn_string)
    return conn, conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    

def process(log_file):
    while True:
        l = log_file.readline()       
     
        if len(l) != 0: 
            m = re.match(regex, l)
            #pprint.pprint(m.groupdict())
            sub_process(m.groupdict())
       
        if not l: 
            break


def sub_process(ld):
        if ld.get('status') == "200":
            date = datetime.strptime(ld.get('time_local'), NGINX_DATE_FORMAT)

            if date.year not in counter:
                counter[date.year] = {}
                
            if date.month not in counter[date.year]:
                counter[date.year][date.month] = {}
                
            if date.day not in counter[date.year][date.month]:
                counter[date.year][date.month][date.day] = {}
                
            if date.hour not in counter[date.year][date.month][date.day]:
                counter[date.year][date.month][date.day][date.hour] = 0
                
            counter[date.year][date.month][date.day][date.hour] = counter[date.year][date.month][date.day][date.hour] + 1
                
    
if __name__ == '__main__':
    conn, cursor = db_connect();

    log_file = open(args.log_file, 'r')
    
    if args.log_type == 'nginx':
        print 'Parsing nginx log \'%s\' for Node %s.' % (args.log_file, args.node_id, ) 
        process(log_file)
    
        for k_year, v_year in counter.items():
            for k_month, v_month in v_year.items():
                for k_day, v_day in v_month.items():
                    for k_hour, v_hour in v_day.items():
                        hourLoggedAt = "%s/%s/%s %s:00:00" % (k_year, k_month, k_day, k_hour)
                        
                        cursor.execute('SELECT * FROM node_access WHERE "nodeId"=%s AND "hourLoggedAt"=%s', 
                            (NODE_ID, hourLoggedAt, ))
                        
                        record = cursor.fetchone()

                        if record is None:
                            # INSERT A NEW RECORD
                            cursor.execute('INSERT INTO node_access ("nodeId", "hourLoggedAt", "pagesServed") VALUES (%s, %s, %s)', 
                                ( NODE_ID, hourLoggedAt, v_hour,))
                        
                        else:
                            # UPDATE AN EXISTING RECORD
                            cursor.execute('UPDATE node_access set "pagesServed" = %s WHERE ID=%s', 
                                (record['pagesServed'] + v_hour, record['id']))
                        
    elif args.log_type == 'captiveportal':
        raise Exception('Captive Portal log parsing is not yet implemented')
        
    else:
        raise Exception('Unknown log_type specified.')
        
    conn.commit()
    print 'Parsing complete.'  
    

#REGEX RESULT FOR NGINX PARSING
'''
{'body_bytes_sent': '0',
 'http_referer': '-',
 'http_user_agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36',
 'remote_addr': '192.168.88.254',
 'remote_user': '-',
 'request': 'GET /bar HTTP/1.1',
 'status': '200',
 'time_local': '30/Apr/2015:08:55:56 +0000'}
'''

# CREATE TABLE
'''
CREATE TABLE node_access (
    "id"              serial PRIMARY KEY,
    "nodeId"          integer NOT NULL,
    "hourLoggedAt"    timestamp NOT NULL,
    "pagesServed"     integer NOT NULL    
);
'''
    
            