def call(path, component, env) {
		def prop = new Properties()
		def input
		def isDefaultNotFound = true
		try {
			input = new FileInputStream(path + "/default.properties")
			prop.load(input)
			
			isDefaultNotFound = false
			
			input = new FileInputStream(path + component + '/' + env +".properties")
			prop.load(input)
	
		} catch (Exception ex) {
			if (isDefaultNotFound) {
				try {
					input = new FileInputStream(component + '/' + env +".properties")
					prop.load(input)
				} catch (IOException e) {
					print e;
				}
				
			}
		}
		return prop;
}

return this;
