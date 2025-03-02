/*
   ____          _          _   ____          __  __       _ _                     
  / ___|___   __| | ___  __| | | __ ) _   _  |  \/  | __ _| | |__   ___  _ __ ___  
 | |   / _ \ / _` |/ _ \/ _` | |  _ \| | | | | |\/| |/ _` | | '_ \ / _ \| '__/ _ \ 
 | |__| (_) | (_| |  __/ (_| | | |_) | |_| | | |  | | (_| | | |_) | (_) | | | (_) |
  \____\___/ \__,_|\___|\__,_| |____/ \__, | |_|  |_|\__,_|_|_.__/ \___/|_|  \___/ 
                                      |___/                                        
*/

require 'mysql'


if not PermaProps then PermaProps = {} end

PermaProps.SQL = {}

/*                                                                NOT WORKS AT THE MOMENT
PermaProps.SQL.MySQL = false
PermaProps.SQL.Host = "127.0.0.1"
PermaProps.SQL.Username = "username"
PermaProps.SQL.Password = "password"
PermaProps.SQL.Database_name = "PermaProps"
PermaProps.SQL.Database_port = 3306
PermaProps.SQL.Preferred_module = "mysqloo"
*/

local bd = rp._Stats

PermaProps.SQL.Query = function(q, f) bd:Query(q, f) end

PermaProps.SQL.Query("CREATE TABLE IF NOT EXISTS permaprops(id INT NOT NULL PRIMARY KEY, map TEXT NOT NULL, content TEXT NOT NULL);")