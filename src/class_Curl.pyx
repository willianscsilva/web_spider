import sys,re,StringIO,pycurl,time,random
#from gerenteConfig import GerenteConfig
#from class_netinfo import NetInfo
#from class_date import Date
#########################################################################
# @param: (bool)PROXY - enable use of proxy				#
# @param: (string) cookie_file_name 					#
# @param: (bool) use_interface - enable use of all network interfaces   #
# @param: (string) url - addres to access				#
# @param: (bool) post - enable post					#
# @param: (bool) post_data - data to post  				#
# @param: (bool) ssl_verifypeer						#
# @return: (string) buffer content					# 
#########################################################################
class Storage:
	reset_limit = None
	def head(self, buf):
		pattern = re.compile("X-RateLimit-Reset: (.*)")
		ret = re.search(pattern,buf)
		if ret != None:
			self.reset_limit = ret.group(1)

#class __CURL__(NetInfo,Date):
class __CURL__:
	id_meio=None
	# interface_rotativo(argumento1,argumento2)
	# argumento1 = bool, liga ou desliga essa funcionalidade
	# argumento2 = tempo em minutos para fazer a troca para a proxima interface
	def __curl_exec__(self,url,post=False,post_data=None,cookie_file_name=None,ssl_verifypeer=True,rate_limit_twitter=False,interface_rotativo=(False,2),config_mode=True):

		buffer = StringIO.StringIO()
		c = pycurl.Curl()
		c.setopt( c.URL, url )
		c.setopt( c.USERAGENT,'Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120425 Firefox/10.0.4')
		if config_mode == True:
			pass
			#self.get_config_mode_request(c,interface_rotativo)
		if ssl_verifypeer == False:
			c.setopt( c.SSL_VERIFYPEER, False )
		if cookie_file_name != None:	
			c.setopt( c.COOKIEFILE,cookie_file_name )
			c.setopt( c.COOKIEJAR, cookie_file_name )
		if post != False:
			c.setopt(c.POST, 1)
			c.setopt(c.POSTFIELDS, str(post_data))
		c.setopt( c.WRITEFUNCTION, buffer.write )
		c.setopt( c.FOLLOWLOCATION, 1 )
		c.setopt( pycurl.VERBOSE, 1 )
		c.perform()
		c.close()
		content = buffer.getvalue()
		return content

	#################################
	# @param (void)			#
	# @return (string)		#
	#################################
	"""	
	def get_config_mode_request(self,c,interface_rotativo):
		# Verifica no db local qual o modo de requisicao, proxy ou interface
		gConf = GerenteConfig()
		arr_cmr = gConf.config_mode_request(self.id_meio)
		if arr_cmr != {}:
			use_interface = arr_cmr[0]['interface']
			PROXY = arr_cmr[0]['proxy']
			if PROXY != False:
				c.setopt(c.PROXY, '127.0.0.1')
				c.setopt(c.PROXYPORT, 8118)
			if use_interface != False:				
				interface = self.get_interface(interface_rotativo)
				c.setopt( c.INTERFACE, str(interface) )
	"""	

	######################### 
	# @param: (void)     	#
	# @return: (string)   	#	
	######################### 
	"""
	def get_interface(self,interface_rotativo):
		# Intercala as interfaces a cada 5 minutos
		ip_server_atual = self.get_ip()
		gConf = GerenteConfig()

		if interface_rotativo[0] == True:
			arr_interface = gConf.get_rotate_interface_in_use()
		else:
			arr_interface = gConf.get_interface_in_use()

		###############
		# TIRAR ISSO ANTES DE POR EM PRODUCAO
		#ip_server_atual = '216.67.232.114'
		################

		arr_server = gConf.get_spider_server(ip_server_atual)
		if arr_server != None:	
			for server_data in arr_server:
				id_spider_server = str(server_data['id_servers'])
				ip_spider_server = str(server_data['ip_servers'])
				arr_vi = gConf.get_virtuais_interfaces(id_spider_server)
				interface_valida=0
				for values_interface in arr_vi:
					values_interface['v_network_interface'] = str(values_interface['v_network_interface'])
					# verifica se ha alguma interface em uso
					if arr_interface != {}:
						# Caso o tempo de execucao da ultima interface seja maior que o tempo estipulado em interface_rotativo minutos
						# altera a interface a ser utilizada.
						if self.change_interface(arr_interface,interface_rotativo) == True:
							next_indice_interface = int(arr_interface[0]['interface'][5:])+1
							next_interface = "eth0:%d"%(next_indice_interface)
							if values_interface['v_network_interface'] == next_interface:
								interface_valida=interface_valida+1
								dt_cad_interface = "%s %s"%(self.get_date(),self.get_time())
								if interface_rotativo[0] == True:
									gConf.set_rotate_interface_in_use(values_interface['v_network_interface'],dt_cad_interface)
								else:
									gConf.set_interface_in_use(values_interface['v_network_interface'],dt_cad_interface)
								return values_interface['v_network_interface']
						else:
							return arr_interface[0]['interface']						
					else:
						# Caso nao haja nenhuma interface em uso cadastra uma. 
						dt_cad_interface = "%s %s"%(self.get_date(),self.get_time())
						if interface_rotativo[0] == True:
							gConf.set_rotate_interface_in_use(values_interface['v_network_interface'],dt_cad_interface)
						else:
							gConf.set_interface_in_use(values_interface['v_network_interface'],dt_cad_interface)
						return values_interface['v_network_interface']
				
				# Se a proxima interface nao existir volta a utilizar a 
				# primeira.
				if interface_valida == 0:
					first_interface="eth0:1"
					dt_cad_interface = "%s %s"%(self.get_date(),self.get_time())
					if interface_rotativo[0] == True:
						gConf.set_rotate_interface_in_use(first_interface,dt_cad_interface)
					else:
						gConf.set_interface_in_use(first_interface,dt_cad_interface)
					return first_interface 
	
	#################################
	# @param: (array) arr_interface	#
	# @return: (bool)		#	
	#################################  	
	def change_interface(self,arr_interface,interface_rotativo): 
		timestamp_atual = time.mktime((self.get_date().year,self.get_date().month,self.get_date().day,self.get_time_obj().hour,self.get_time_obj().minute,self.get_time_obj().second,0,1,0))
		self.split_datestr(arr_interface[0]['date'])
		timestamp = time.mktime((int(self.ano), int(self.mes), int(self.dia), int(self.hora), int(self.minuto), int(self.segundo), 0, 1, 0))
		time_last_execution = int((timestamp_atual-timestamp)/60)

		if time_last_execution > int(interface_rotativo[1]):
		#if time_last_execution > 1:
			return True
		else:
			return False
	"""
