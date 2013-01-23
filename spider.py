from class_daemon import Daemon
from threading import Thread
from class_mongodb import __MONGOCONN__
from class_Meta import __METATAG__
from class_Lks import __LINKS__
import sys,time,os,re,urllib,random,commands
from datetime import date

class mThread(__METATAG__,__LINKS__):
	id_palavra,id_combine = None,None
	def __init__(self,metodo,argList):		
		for argName in argList:
			t=Thread(target=eval(metodo),args=(argName['url'],))
			t.start()
			t.join()			


def __INIT__():
	if len(sys.argv) == 3:
		if sys.argv[2] == "meta":
			argList = list() 
			metodo = "self.__INIT__META"
			url = "http://www.americanas.com.br/produto/6991805/blu-ray-batman-begins"
			argList.append({'url':url})
			mThread(metodo,argList)
		elif sys.argv[2] == "link":
			argList = list()
                        metodo = "self.__INIT__LINK"
                        url = "http://www.americanas.com.br/produto/6991805/blu-ray-batman-begins"
                        argList.append({'url':url})
                        mThread(metodo,argList)
	else:
		print "AQUI2"

if __name__ == "__main__":	
	__INIT__()

"""

class MyDaemon(Daemon):
        def run(self):
		while True:							
			__INIT__()
			time.sleep(300)

if __name__ == "__main__":
	pid_file = "/tmp/spider.pid"
        daemon = MyDaemon(pid_file)
        if len(sys.argv) >= 4:
                if 'start' == sys.argv[1]:
                        daemon.start()
                elif 'stop' == sys.argv[1]:
                        daemon.stop()
                elif 'restart' == sys.argv[1]:
                        daemon.restart()
                else:
                        print "Unknown command"
                        sys.exit(2)
                sys.exit(0)
        else:
                print "usage: %s start" % sys.argv[0]
		sys.exit(2)
"""
