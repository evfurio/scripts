require 'open-uri'
require 'pp'

url = "http://qagi2.testecom.pvt"

open(url) do |f|
pp f.meta
pp f.content_type
pp f.last_modified.to_s

end