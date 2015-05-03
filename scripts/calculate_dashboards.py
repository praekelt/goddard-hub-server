#!/usr/bin/python
import psycopg2
import psycopg2.extras
import os
import pprint
from datetime import date, datetime, timedelta

stats = {}
macstats = {}

def db_connect():
    conn_string = os.environ['DB_URL']
    conn = psycopg2.connect(conn_string)
    return conn, conn.cursor(cursor_factory=psycopg2.extras.DictCursor)


def upsert(cursor, nodeid, stat):
    for app_id, astat in stat.items():
        cursor.execute('SELECT id FROM node_dashboard_page_views WHERE "nodeId"=%s AND "appId"=%s', (node_id, app_id, ))
        row = cursor.fetchone()
        if row is None:
            # Record does not yet exist, lets add it. 
            print "Dashboard Calculations - Inserting node %s" % node_id
            cursor.execute('INSERT INTO node_dashboard_page_views ("nodeId", "appId", "h1", "h24", "h48", "d7", "d31", "d365", "allTime") \
                values (%s, %s, %s, %s, %s, %s, %s, %s, %s)', \
                (node_id, app_id, astat['h1'], astat['h24'], astat['h48'], astat['d7'], astat['d31'], astat['d365'], astat['all_time'], ))
        else:
            # Record does exist, lets update.
            print "Dashboard Calculations - Updating node %s" % node_id
            cursor.execute('UPDATE node_dashboard_page_views set "h1"=%s, "h24"=%s, "h48"=%s, "d7"=%s, "d31"=%s, "d365"=%s, \
                "allTime"=%s, timestamp=now() where "id"=%s',
                (astat['h1'], astat['h24'], astat['h48'], astat['d7'], astat['d31'], astat['d365'], astat['all_time'], row['id'] ))

def upsert_mac(cursor, nodeid, stat):
    cursor.execute('SELECT id FROM node_dashboard_macs WHERE "nodeId"=%s', (node_id, ))
    row = cursor.fetchone()
    if row is None:
        # Record does not yet exist, lets add it. 
        print "Dashboard MAC Calculations - Inserting node %s" % node_id
        cursor.execute('INSERT INTO node_dashboard_macs ("nodeId", "h1", "h24", "h48", "d7", "d31", "d365", "allTime") \
            values (%s, %s, %s, %s, %s, %s, %s, %s)', \
            (node_id, stat['h1'], stat['h24'], stat['h48'], stat['d7'], stat['d31'], stat['d365'], stat['all_time'], ))
    else:
        # Record does exist, lets update.
        print "Dashboard MAC Calculations - Updating node %s" % node_id
        cursor.execute('UPDATE node_dashboard_page_views set "h1"=%s, "h24"=%s, "h48"=%s, "d7"=%s, "d31"=%s, "d365"=%s, \
            "allTime"=%s, timestamp=now() where "id"=%s',
            (stat['h1'], stat['h24'], stat['h48'], stat['d7'], stat['d31'], stat['d365'], stat['all_time'], row['id'] ))


def get_sum(cursor, node_id, app_id, target):
    cursor.execute('SELECT SUM("pagesServed") FROM node_accesses WHERE "nodeId"=%s AND "appId"=%s AND "hourLoggedAt" >= %s', (node_id, app_id, target, ))
    r = cursor.fetchone()
    if r is None or r[0] is None: 
        return 0    
    else:
        return int(r[0])
        
        
def get_mac_sum(cursor, node_id, target):
    cursor.execute('SELECT count("id") FROM node_mac_accesses WHERE "nodeId"=%s AND "hourLoggedAt" >= %s', (node_id, target, ))
    r = cursor.fetchone()
    if r is None or r[0] is None: 
        return 0    
    else:
        return int(r[0])

    
def calculate_page_views(node_id, apps, cursor):
    print 'Dashboard Calculations - Calculating Stats For Node  %s' % node_id
    
    stats[node_id] = {}
    
    for app_id in apps:
        print "\t Processing Page Views for Node %s and appId %s" % (node_id, app_id,)
        
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
      
      
def calculate_mac_totals(node_id, cursor):
        print "\t Processing MACs for Node %s" % node_id
        
        macstats[node_id] = {}    
    
        now = datetime.now()

        # 1 hour
        t = now - timedelta(hours=1)
        macstats[node_id]['h1'] = get_mac_sum(cursor,node_id, t)
    
        # 24 hours
        t = now - timedelta(hours=24)
        macstats[node_id]['h24'] = get_mac_sum(cursor,node_id, t)
    
        # 48 hours
        t = now - timedelta(hours=48)
        macstats[node_id]['h48'] = get_mac_sum(cursor,node_id, t)    
    
        # 7 days
        t = now - timedelta(days=7)
        macstats[node_id]['d7'] = get_mac_sum(cursor,node_id, t) 
    
        # 31 days
        t = now - timedelta(days=31)
        macstats[node_id]['d31'] = get_mac_sum(cursor,node_id, t) 

        # 365 days
        t = now - timedelta(days=365)
        macstats[node_id]['d365'] = get_mac_sum(cursor,node_id, t) 

        # all time 
        t = date(1970, 1, 1)
        macstats[node_id]['all_time'] = get_mac_sum(cursor,node_id, t)  
      
        
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
        # Calculate Each Node's Data

        # NGINX LOGS
        calculate_page_views(row['id'], apps, cursor)
        
        # MAC ADDRESSES
        calculate_mac_totals(row['id'], cursor)
       

    # UPSERT THE DATA
    for node_id, stat in stats.items():
        print "Dashboard Pageview Calculations - Upcerting Node %s" % (node_id, )
        upsert(cursor, node_id, stat)
        
    for node_id, stat in macstats.items():
        print "Dashboard MAC Totals Calculations - Upcerting Node %s" % (node_id, )
        upsert_mac(cursor, node_id, stat)
    
    
    conn.commit()    
