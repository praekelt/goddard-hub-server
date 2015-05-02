#!/usr/bin/python
import psycopg2
import psycopg2.extras
import os
import pprint
from datetime import date, datetime, timedelta

stats = {}

def db_connect():
    conn_string = os.environ['DB_URL']
    conn = psycopg2.connect(conn_string)
    return conn, conn.cursor(cursor_factory=psycopg2.extras.DictCursor)


def upsert(cursor, nodeid, stat):
    for app_id, astat in stat.items():
        cursor.execute('SELECT id FROM node_dashboard_page_view WHERE "nodeId"=%s AND "appId"=%s', (node_id, app_id, ))
        row = cursor.fetchone()
        if row is None:
            # Record does not yet exist, lets add it. 
            print "Dashboard Calculations - Inserting node %s" % node_id
            cursor.execute('INSERT INTO node_dashboard_page_view ("nodeId", "appId", "h1", "h24", "h48", "d7", "d31", "d365", "allTime") \
                values (%s, %s, %s, %s, %s, %s, %s, %s, %s)', \
                (node_id, app_id, astat['h1'], astat['h24'], astat['h48'], astat['d7'], astat['d31'], astat['d365'], astat['all_time'], ))
        else:
            # Record does exist, lets update.
            print "Dashboard Calculations - Updating node %s" % node_id
            cursor.execute('UPDATE node_dashboard_page_view set "h1"=%s, "h24"=%s, "h48"=%s, "d7"=%s, "d31"=%s, "d365"=%s, \
                "allTime"=%s, timestamp=now() where "id"=%s',
                (astat['h1'], astat['h24'], astat['h48'], astat['d7'], astat['d31'], astat['d365'], astat['all_time'], row['id'] ))


def get_sum(cursor, node_id, app_id, target):
    cursor.execute('SELECT SUM("pagesServed") FROM node_access WHERE "nodeId"=%s AND "appId"=%s AND "hourLoggedAt" >= %s', (node_id, app_id, target, ))
    r = cursor.fetchone()
    if r is None or r[0] is None: 
        return 0    
    else:
        return int(r[0])

    
def calculate_page_views(node_id, apps, cursor):
    print 'Dashboard Calculations - Calculating Stats For Node  %s' % node_id
    
    stats[node_id] = {}
    
    for app_id in apps:
        print "\t Processing hits for appId %s" % app_id
        
        stats[node_id][app_id] ={}    
    
        now = datetime.now()

        # 1 hour
        t = now - timedelta(hours=1)
        stats[node_id][app_id]['h1'] = get_sum(cursor,node_id, app_id, t)
    
        # 24 hours
        t = now - timedelta(hours=24)
        stats[node_id][app_id]['h24'] = get_sum(cursor,node_id, app_id, t)
    
        # 48 hours
        t = now - timedelta(hours=48)
        stats[node_id][app_id]['h48'] = get_sum(cursor,node_id, app_id, t)    
    
        # 7 days
        t = now - timedelta(days=7)
        stats[node_id][app_id]['d7'] = get_sum(cursor,node_id, app_id, t) 
    
        # 31 days
        t = now - timedelta(days=31)
        stats[node_id][app_id]['d31'] = get_sum(cursor,node_id, app_id, t) 

        # 365 days
        t = now - timedelta(days=365)
        stats[node_id][app_id]['d365'] = get_sum(cursor,node_id, app_id, t) 

        # all time 
        t = date(1970, 1, 1)
        stats[node_id][app_id]['all_time'] = get_sum(cursor,node_id, app_id, t)
        
        
if __name__ == '__main__':
    conn, cursor = db_connect();
    
    apps = []

    # Populate apps list.
    cursor.execute("SELECT * FROM apps ORDER BY id")
    rows = cursor.fetchall()
    for row in rows:
        apps.append(row['id'])
    
    # Fetch all Nodes
    cursor.execute("SELECT * FROM nodes ORDER BY id")
    rows = cursor.fetchall()
    
    for row in rows:
        # Calculate for each node, passing apps.
        calculate_page_views(row['id'], apps, cursor)
       
    for node_id, stat in stats.items():
        print "Dashboard Calculations - Upcerting Node %s" % (node_id, )
        upsert(cursor, node_id, stat)
    
    conn.commit()    
        
        
'''
CREATE TABLE node_dashboard_page_view (
    "id"              serial PRIMARY KEY,
    "nodeId"          integer NOT NULL,
    "appId"           integer NOT NULL,
    "h1"              integer NOT NULL,
	"h24"             integer NOT NULL,
    "h48"             integer NOT NULL,
    "d7"              integer NOT NULL,
    "d31"             integer NOT NULL,
	"d365"            integer NOT NULL,
    "allTime"         integer NOT NULL, 
    "timestamp"       timestamp default current_timestamp
);
'''