require 'optparse'
require './yoshikei.rb'

params = ARGV.getopts("", 'user:', 'pass:') 
user = params['user']
pass =  params['pass']

yoshikei = Yoshikei.new
yoshikei.login(user, pass)
menu = yoshikei.get_todays_menu()
print(menu)
yoshikei.logout()
yoshikei.close()

