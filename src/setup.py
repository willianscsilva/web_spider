from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import commands,re,sys
def set_path_lib():

	python_version = "Python %s.%s"%(sys.version_info[0],sys.version_info[1])
	#python_version = commands.getoutput('python -V')
	pattern_version = re.compile('(Python 2\.[0-9]{1})')
	result_version = re.search(pattern_version,python_version)
	if result_version != None:
		py_version = result_version.group(1).replace(" ","").lower()
		linux_arch = commands.getoutput('uname -a')
		pattern_arch = re.compile('x86_64')	
		result_arch = re.search(pattern_arch,linux_arch)
		if result_arch != None:
			path_libs = "/usr/lib64/%s/site-packages/"%(py_version)
			current_path = commands.getoutput('pwd')
			pattern_path = re.compile('((.*?)/buzzerd/)')
			result_path = re.search(pattern_path,current_path)
			if result_path != None:
				path_project = result_path.group(1)
				cmd_path_lib = "echo %s > %spath_lib.txt"%(path_libs,path_project)				
				commands.getoutput(cmd_path_lib)
				cmd_path_project = "echo %s > %spath_project.txt"%(path_project,path_libs)
				commands.getoutput(cmd_path_project)
				cmd_cp1 = "cp %sregex.conf %s"%(path_project,path_libs)
				cmd_cp3 = "cp %smeios_ativos.txt %s"%(path_project,path_libs)
				commands.getoutput(cmd_cp1)				
				commands.getoutput(cmd_cp3)
		else:
			print "Atencao: arquitetura incompativel, esperado linux 64 bits"
	else:
		print "Atencao: versao incompativel, esperado python2.x."

if len(sys.argv) == 2:
	arg = sys.argv[1]
	if arg == "build" or arg == "install":
		ext_modules = [Extension("class_daemon", ["class_daemon.pyx"]),Extension("class_mongodb",["class_mongodb.pyx"]),Extension("class_Meta",["class_Meta.pyx"]),Extension("class_Curl", ["class_Curl.pyx"]),Extension("class_Lks", ["class_Lks.pyx"])]
		# You can add directives for each extension too
		# by attaching the `pyrex_directives`
		for e in ext_modules:
			e.pyrex_directives = {"boundscheck": False}
		setup(
			name = "spider",
			cmdclass = {"build_ext": build_ext},
			ext_modules = ext_modules
		)
		set_path_lib()
	elif arg == "copy":
		set_path_lib()
