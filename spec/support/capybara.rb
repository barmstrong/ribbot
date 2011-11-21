def set_subdomain sub
  Capybara.app_host = "http://#{sub}.example.com:7171"
end