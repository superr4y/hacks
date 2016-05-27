import requests
import re

linkedin_url = "https://www.linkedin.com/pub/dir/?first=%s&last=%s&search=Search"%("paul", "brand")

req = requests.get(linkedin_url)
#print re.findall(r'<table>(.*)</table>', req.content)
print req.content
