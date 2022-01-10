require 'date'
require 'json'
require 'nokogiri'
require 'open-uri'

BASE_URL = 'https://www2.yoshikei-dvlp.co.jp/webodr/apl/10/101508_D.aspx'
DAYS = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]

def beginning_of_week(day)
  return day - day.wday + 1
end

def get_url(day)
  bday = beginning_of_week(day)
  wk = bday.strftime("%Y%m%d")
  dy = bday.strftime("%Y%m%d")
  kb = '01'
  kd = '35'
  pt = '00'
  oa = '0'
  return BASE_URL + "?WK=#{wk}&DY=#{dy}&KB=#{kb}&KD=#{kd}&PT=#{pt}&OA=#{oa}"
end

def get_section(doc, week)
  return doc.at_css('#' + week)
end

def get_menu_item(section)
  menu_item = {}
  menu_item['date-at-num' ] = section.at_css('div.top-section__date span.top-section__date-at__num').text
  menu_item['date-at-week'] = section.at_css('div.top-section__date span.top-section__date-at__week').text
  menu_item['title-name']   = section.at_css('span.menu-page-title__name').text
  menu_item['kind'] = section.at_css('span.top-section__category').text
  menu_item['date'] = menu_item['date-at-num'] + menu_item['date-at-week']
  menu_item['info'] = section.at_css('span.top-section__delivery').text
  menu_item['name'] = menu_item['title-name']
  return menu_item
end

def to_week(day)
  return DAYS[day.wday]
end

day = Date.today
if ARGV.length > 0 then
  day = DateTime.parse(ARGV[0])
end
url = get_url(day)
doc = Nokogiri::HTML(open(url), nil, "shiftjis")
week = to_week(day)
section = get_section(doc, week)
item = get_menu_item(section)
puts item.to_json()
