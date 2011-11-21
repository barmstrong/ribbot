def emails_sent
  ActionMailer::Base.deliveries.size
end

def last_email
  ActionMailer::Base.deliveries.last
end

def reset_email
  ActionMailer::Base.deliveries = []
end