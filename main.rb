require './version_changer'

version_changer = VersionChanger.new
version_changer.substitute("/home/jaguarxj/Documents/Projects/BoldAdmin/glados/glados-frontend/@boldadmin/glados-frontend/package.json",
                           "2.2.1", "2.3.0", 3)
