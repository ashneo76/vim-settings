#!/usr/bin/env python
import os
import time
import gobject, dbus
from dbus.mainloop.glib import DBusGMainLoop

calllogFile = '/home/user/MyDocs/calllogs.txt'
blocklistFile = '/home/user/MyDocs/BlockedCallers.txt'
blocklist = []
last_mtime = 0

def load_blocklist():
    global blocklist
    
    if os.path.exists(blocklistFile):
        try:
            blFile = open(blocklistFile,'rb')
            blocklist = [num.strip() for num in blFile.readlines()]
            blFile.close()
        except Exception:
            print "Blocklist missing, should be at " + blocklistFile

def current_timestamp():
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())

def handle_call(obj_path, callernumber):
    global blocklist
    # If file has been modified, re-load it...
    global last_mtime
    recent_mtime = os.stat(blocklistFile).st_mtime
    timestamp = current_timestamp()

    logFile = open(calllogFile,'a+')
    logFile.write(timestamp+ ': ' + callernumber + '\n')
    logFile.close()

    if recent_mtime > last_mtime:
        last_mtime = recent_mtime
        print "[%s] Re-loading blocker list from file..." % timestamp
        load_blocklist()

    if callernumber in blocklist:
        print '[%s] Blocking call from %s' % (timestamp, callernumber)
        bus = dbus.SystemBus()
        callobject = bus.get_object('com.nokia.csd.Call', '/com/nokia/csd/call/1')
        smsiface = dbus.Interface(callobject, 'com.nokia.csd.Call.Instance')
        smsiface.Release()

def wait_csd():

    # This is required for autostart to function, otherwise
    # looks like we fall through without getting a proper
    # dbus handler below and add_signal_receiver fails...
    while True:
        print 'Waiting on csd...'
        p=os.popen("ps -ef | grep /usr/sbin/csd | grep -v grep")
        x=p.readlines(1)
        p.close()
        if len(x):
            break
        time.sleep(1)

    print 'Done.'
    
    
if __name__ == "__main__":
    # Wait till csd is up and running
    wait_csd()
    DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()
    bus.add_signal_receiver(handle_call, path='/com/nokia/csd/call', dbus_interface='com.nokia.csd.Call', signal_name='Coming')
    gobject.MainLoop().run()
