import requests, re, csv
from bs4 import BeautifulSoup
# install bs4 as 'pip install beautifulsoup4'



# change this URL to crawl a different wiki page
# also change the filename down at the bottom
URL = "https://de.wikipedia.org/wiki/Angstst%C3%B6rung"








page = requests.get(URL)


soup = BeautifulSoup(page.content, "html.parser")

content = soup.find(id="content").find_all("a", attrs={'class': None}, href=True)


# get all links from the URL, put into list
all_primary_links = []
for i in content:
    if not re.match(r"^#.*$",i["href"]) and re.match(r"^/wiki/.*$", i["href"]) and not re.match(r"^/wiki/Wikipedia:Hinweis.*$", i["href"]) and not re.match(r"^/wiki/Kategorie:.*$", i["href"]) and not re.match(r"^/wiki/Wikipedia.*$", i["href"]):
        all_primary_links.append("https://de.wikipedia.org" + i["href"])


# start an edge tabe
edge_list = []
for i in all_primary_links:
    connection = [URL, i]
    edge_list.append(connection)




# now get all links from the sublinks
for subnode in all_primary_links:
    URL = subnode
    page = requests.get(URL)
    soup = BeautifulSoup(page.content, "html.parser")
    content = soup.find(id="content").find_all("a", attrs={'class': None}, href=True)
    all_secondary_links = []
    for i in content:
        if not re.match(r"^#.*$",i["href"]) and re.match(r"^/wiki/.*$", i["href"]) and not re.match(r"^/wiki/Wikipedia:Hinweis.*$", i["href"]) and not re.match(r"^/wiki/Kategorie:.*$", i["href"]) and not re.match(r"^/wiki/Wikipedia.*$", i["href"]):
            all_secondary_links.append("https://de.wikipedia.org" + i["href"])
    # only add these if to the edge list if they are already one layer deep
    for j in all_secondary_links:
        if j in all_primary_links:
            connection = [URL, j]
            edge_list.append(connection)




# save as csv
f = open("angst.csv", "w")
writer = csv.writer(f, lineterminator="\n")
writer.writerow(["from", "to"])
for j in edge_list:
    writer.writerow(j)

f.close()



