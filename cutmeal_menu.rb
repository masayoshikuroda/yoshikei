require 'date'
require 'json'
require 'nokogiri'
require 'open-uri'

BASE_URL = 'https://www2.yoshikei-dvlp.co.jp/webodr/apl/10/101508_D.aspx'
DAYS     = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
DAYS_JA  = ["日",     "月",     "火",      "水",        "木",       "金",     "土"      ]

def beginning_of_week(date)
  return date - date.wday + 1
end

def get_url(date)
  bday = beginning_of_week(date)
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

def to_week(date)
  return DAYS[date.wday]
end

date = Date.today
if ARGV.length > 0 then
  date = DateTime.parse(ARGV[0])
end
url = get_url(date)
doc = Nokogiri::HTML(URI.open(url), nil, "shiftjis")
week = to_week(date)
section = get_section(doc, week)
item = if section.nil? then
  {
    "date-at-num"  => "#{date.month}/#{date.day}",
    "date-at-week" => "(#{DAYS_JA[date.wday]})",
    "title-name"   => "",
    "kind"         => "カットミール",
    "date"         => "#{date.month}/#{date.day}(#{DAYS_JA[date.wday]})",
    "info"         => "#{date.month}/#{date.day}(#{DAYS_JA[date.wday]})のお届けはありません。",
    "name"         => "",
    "message"      => "のヨシケイのメニューは、#{}"
  }
else
  get_menu_item(section)
end

prefix = if date == Date.today then
  "本日の"
else
  "#{date.month}月#{date.day}日の"
end

message = if item["name"].empty? then
  "お届けはありません。"
else
  "ヨシケイのメニューは、#{item['name']}です。"
end
item["message"] = prefix + message

puts item.to_json()

