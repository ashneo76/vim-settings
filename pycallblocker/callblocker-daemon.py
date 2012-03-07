#!/usr/bin/env python
import os
import time
import re
import gobject, dbus
from dbus.mainloop.glib import DBusGMainLoop
 
blocklistFile = '/home/user/MyDocs/BlockedCallers.txt'
calllogFile = '/home/user/MyDocs/CallLog.txt'
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

    # Log all calls
    clFile = open(calllogFile,'a+')
    clFile.write('\n' + current_timestamp() + ':' + callernumber)
    clFile.flush()
    clFile.close()

    if recent_mtime > last_mtime:
        last_mtime = recent_mtime
        print "[%s] Re-loading blocker list from file..." % timestamp
        load_blocklist()

    print current_timestamp() + "Checking whether to block " + callernumber
    #if callernumber in blocklist:
    for numberentry in blocklist:
        print "Compiling pattern for " + numberentry
        p = re.compile(numberentry)
        if p.match(callernumber) != None:
            print '[%s] Blocking call from %s' % (timestamp, callernumber)
            bus = dbus.SystemBus()
            callobject = bus.get_object('com.nokia.csd.Call', '/com/nokia/csd/call/1')
            smsiface = dbus.Interface(callobject, 'com.nokia.csd.Call.Instance')
            smsiface.Release()
            break

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
