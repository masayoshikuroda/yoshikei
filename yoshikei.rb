require 'selenium-webdriver'
require 'net/http'
require 'uri'
require 'date'

class Yoshikei
  BASE_URL = 'https://www2.yoshikei-dvlp.co.jp/webodr'

  def initialize
    pwd = Dir.pwd
    prefs = {
      prompt_for_download: false,
      default_directory: pwd,
      directory_upgrade: true
    }
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_preference(:download, prefs)
    options.add_argument('--headless')
    options.add_argument('--window-size=1024,768')
    @driver = Selenium::WebDriver.for :chrome, options: options
    @driver.manage.timeouts.implicit_wait = 10
  end

  def login(user, pass)
    @driver.navigate.to BASE_URL + '/apl/10/100201_D.aspx'
    form = @driver.find_element(:id, 'frmsch')
    form.find_element(:id, 'txtWeb_Login_Id').send_keys(user)
    form.find_element(:id, 'pwdPassword').send_keys(pass)
    btn = form.find_element(:class_name, 'btnLogin')
    btn.location_once_scrolled_into_view()
    btn.click()
  end

  def get_todays_menu()
    menu_item = {}
    info = @driver.find_element(:css, 'div.menu-item__info')
    if not info.nil?
      menu_item['kind'] = info.find_element(:css, 'span.crtitm-menu-name1').text
      menu_item['date'] = info.find_element(:css, 'div > span.menu-item__date.crtitm-day1').text
      menu_item['info'] = info.find_elements(:css, 'div > span.menu-item__date')[1].text
      menu_item['name'] = info.find_element(:css, 'h4.menu-item__name > a.menu-item__title-link').text
    end
    return menu_item 
  end

  def logout()
    @driver.find_element(:id, 'btnlogout').click()
  end

  def close()
    @driver.close()
  end
end
