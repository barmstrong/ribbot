# Note you'll also have to set something like this in your /etc/hosts
# 127.0.0.1 test1.example.com test2.example.com test3.example.com test4.example.com test5.example.com

def set_subdomain sub
  Capybara.app_host = "http://#{sub}.example.com:7171"
end