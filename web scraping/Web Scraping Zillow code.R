library(rvest)

#####trying Zillow for Slater, IA#####
######################################
url = "https://www.zillow.com/slater-ia/?searchQueryState=%7B%22mapBounds%22%3A%7B%22north%22%3A41.930365556704984%2C%22east%22%3A-93.55027834838869%2C%22south%22%3A41.782563414617314%2C%22west%22%3A-93.76760165161134%7D%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22sort%22%3A%7B%22value%22%3A%22days%22%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sche%22%3A%7B%22value%22%3Afalse%7D%2C%22schm%22%3A%7B%22value%22%3Afalse%7D%2C%22schh%22%3A%7B%22value%22%3Afalse%7D%2C%22schp%22%3A%7B%22value%22%3Afalse%7D%2C%22schr%22%3A%7B%22value%22%3Afalse%7D%2C%22schc%22%3A%7B%22value%22%3Afalse%7D%2C%22schu%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%2C%22mapZoom%22%3A12%2C%22regionSelection%22%3A%5B%7B%22regionId%22%3A20522%2C%22regionType%22%3A6%7D%5D%2C%22pagination%22%3A%7B%7D%7D"
pg = read_html(url)

# get list of houses for sale that appears on the page
# each property card is called an article when you inspect the webpage
houselist <- read_html(url)%>%html_elements("article")

address <- read_html(url) %>% html_elements("address") %>% html_text()

#trying things for price that aren't working
price_listed <- pg %>% html_elements("\html\body\div[1]\div[5]\div\div\div[1]\div[1]\ul\li[2]\div\div\article\div\div[1]\div[2]\div\span") %>% html_text()

price_listed <- pg %>% html_elements(span.class = "srp__sc-16e8gqd-1 jLQjry") %>% html_text()