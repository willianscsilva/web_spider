import sys,re,pprint
from class_mongodb import __MONGOCONN__
from class_Curl import __CURL__

class __METATAG__(__CURL__):
	URL,MC = None,None
	def __INIT__META(self,url):
		self.obj_mongo_connect()
		self.URL = url
		ret = self.open_url(url)	
		self.get_meta(ret)

	def obj_mongo_connect(self):
		self.MC = __MONGOCONN__()
		self.MC.mongo_connection()
		self.MC.get_database("spiderdb")
	
	def open_url(self,url):
		retorno = self.__curl_exec__(url,ssl_verifypeer=False)
		return retorno

	def get_meta(self,string):
		nm_collection = self.URL.replace("http://","")
		nm_collection = nm_collection.replace("www.","")
		nm_collection = nm_collection.replace(".","_")
		nm_collection = nm_collection.replace("-","_")
		nm_collection = nm_collection.replace("|","_")
		nm_collection = nm_collection.replace("%20","_")
		nm_collection = nm_collection.replace("/","_")
		nm_collection = "meta_%s"%(nm_collection)
		if self.get_collection_by_name(nm_collection) == False:
			pattern = "<meta(.*?)[\/]?>"	
			pt_compile = re.compile(pattern,re.IGNORECASE)
			result = re.findall(pt_compile,string)
			if result != [] and result != None:
				for res in result:
					pattern_explode = "(.*?)=\"(.*?)\"|(.*?)='(.*?)'"
					ptc_explode = re.compile(pattern_explode)		
					result_explode = re.findall(ptc_explode,res)
					
					for meta in result_explode:
						new_doc = None
						if meta[0] != '':
							new_doc = {meta[0].strip().lower():meta[1].strip().lower()}
						elif meta[2] != '':
							new_doc = {meta[2].strip().lower():meta[3].strip().lower()}
						if new_doc != None:
							self.MC.get_collection(nm_collection)
							self.MC.set_document(new_doc)
			else:
				print "nao foi possivel recuperar as metas!"
		else:
			print "Essa collection ja existe!"
					

					
	def get_collection_by_name(self,name):
		achei=False
		for nm in self.MC.get_collections_name():
			if nm == name:
				achei=True
		return achei
