import sys,re,pprint
from class_Curl import __CURL__

class __LINKS__(__CURL__):
	URL = None
	def __INIT__LINK(self,url):
		self.URL = url
		ret=self.open_url(url)
		self.get_lks(ret)
	
	def open_url(self,url):
		retorno = self.__curl_exec__(url,ssl_verifypeer=False)
		return retorno

	def get_lks(self,string):
		nm_collection = self.URL.replace("http://","")
		nm_collection = nm_collection.replace("www.","")
		nm_collection = nm_collection.replace(".","_")
		nm_collection = nm_collection.replace("-","_")
		nm_collection = nm_collection.replace("|","_")
		nm_collection = nm_collection.replace("%20","_")
		nm_collection = nm_collection.replace("/","_")
		nm_collection = "links_%s"%(nm_collection)
		#if self.get_collection_by_name(nm_collection) == False:
		pattern = "<a href=\"(.*?)\""    
		pt_compile = re.compile(pattern,re.IGNORECASE)
		result = re.findall(pt_compile,string)
		print result
			
			

	def get_collection_by_name(self,name):
		achei=False
		for nm in self.MC.get_collections_name():
			if nm == name:
				achei=True
		return achei
