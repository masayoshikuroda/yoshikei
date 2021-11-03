require 'optparse'
require 'json'
require_relative 'yoshikei'

params = ARGV.getopts("", 'user:', 'pass:') 
user = params['user']
pass =  params['pass']

yoshikei = Yoshikei.new
yoshikei.login(user, pass)
menu = yoshikei.get_todays_menu()
puts menu.to_json()
yoshikei.logout()
yoshikei.close()

