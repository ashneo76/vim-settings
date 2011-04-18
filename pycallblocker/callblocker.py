#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# PyCallBlocker for Maemo 5.
#
# Author: V@s3K
# Web: http://vas3k.ru/work/pycallblocker
# Date: 2010.02.27
#
# File: callblocker.py
# Version: 1.2
# 
# Special thanks to: 
#    http://maemos.ru
#    http://maemocentral.com/2010/02/22/how-to-block-unwanted-callers-on-the-n900/
#

blocklistFile = '/home/user/MyDocs/BlockedCallers.txt'
daemonFile = '/opt/pycallblocker/callblocker-daemon.py'
pidFile = '/tmp/callblocker_pid.txt'

# Это все, что нам нужно для Qt
from PyQt4 import QtGui, QtCore
from PyQt4.QtCore import SIGNAL, SLOT
import sys
import subprocess

class PyCallBlock(QtGui.QWidget):
    def __init__(self, parent = None):
        QtGui.QWidget.__init__(self, parent)
        self.setWindowTitle("PyCallBlocker")
        
        self.number_list = QtGui.QListWidget(self)
        self.new_button = QtGui.QPushButton("New number", self)
        self.del_button = QtGui.QPushButton("Delete number", self)
        
        self.layout = QtGui.QVBoxLayout(self)
        self.layout.addWidget(self.number_list)
        
        self.butt_layout = QtGui.QHBoxLayout()
        self.butt_layout.addWidget(self.new_button)
        self.butt_layout.addWidget(self.del_button)
        self.layout.addLayout(self.butt_layout)
        
        self.connect(self.new_button, SIGNAL('clicked()'), self.slotadd)
        self.connect(self.del_button, SIGNAL('clicked()'), self.slotdel)
        
        self.loadList()
        self.restartDaemon()
        
    def slotadd(self):
        text, ok = QtGui.QInputDialog.getText(self, "Enter new block number", "Phone:")
        if ok:
            blFile = open(blocklistFile, 'a')
            blFile.write(text + "\n")
            blFile.close()
        self.loadList()
        self.restartDaemon()
    
    def slotdel(self):
        row = self.number_list.currentRow()
        if row < 0:
            msgBox = QtGui.QMessageBox()
            msgBox.setText("First, tap the number in list")
            msgBox.exec_()
            return
        else:
            item = self.number_list.item(row)
            text, ok = QtGui.QInputDialog.getText(self, "Delete this number from blocklist?", "Phone:", text=item.text())
            if ok:
                self.deleteFromList(text)
            self.loadList()
            self.restartDaemon()
    
    def deleteFromList(self, text):
        blFile = open(blocklistFile, 'r')
        recent = []
        for num in blFile.readlines():
            if num.strip() != text:
                recent.append(num)
        blFile.close()
        blFile = open(blocklistFile, 'w')
        for num in recent:
            blFile.write(num)
        blFile.close()
        
    def loadList(self):
        self.number_list.clear()
        self.blocklist = []
        try:
            blFile = open(blocklistFile, 'r')
            self.blocklist = [num.strip() for num in blFile.readlines() if num.strip()]
            blFile.close()
        except:
            msgBox = QtGui.QMessageBox()
            msgBox.setText("Blocklist file has created at: %s" % blocklistFile)
            msgBox.exec_()
        for num in self.blocklist:
            QtGui.QListWidgetItem(num, self.number_list)
    
    def addNew(self):
        text = QtGui.QInputDialog.getText(self, "title", "Number:")
        
    def restartDaemon(self):
        try:
            pdFile = open(pidFile, 'r+')
            pid = pdFile.readline().strip()
            subprocess.Popen("kill -9 " + str(pid), shell=True)
            pdFile.close()
        except:
            pass
        
        proc = subprocess.Popen("python2.5 " + daemonFile + " &", shell=True)
        
        pdFile = open(pidFile, 'w+')
        pdFile.write(str(proc.pid + 1))
        pdFile.close()

# Execution
app = QtGui.QApplication(sys.argv)
myWindow = PyCallBlock()
myWindow.show()
sys.exit(app.exec_())
        
