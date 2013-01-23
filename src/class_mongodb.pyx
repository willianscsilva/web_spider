import sys
from pymongo import Connection

class __MONGOCONN__:
	connection,db,collection = None,None,None
	def mongo_connection(self):
		self.connection = Connection()

	def get_database(self,nm_database):
		self.db = self.connection[nm_database]

	def create_collection(self,nm_collection):
		#self.db.create_collection(nm_collection,)
		pass

	def get_collection(self,nm_collection):
		self.collection = self.db[nm_collection]

	def get_collections_name(self):
		return self.db.collection_names()

	def set_document(self,doc):
		self.collection.insert(doc)

