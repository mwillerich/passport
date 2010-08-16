# http://webcache.googleusercontent.com/search?q=cache:Om9ftgMp24UJ:https://content.etrade.com/etrade/estation/pdf/API_Technical_Documentation.pdf+etrade+oauth&cd=3&hl=en&ct=clnk&gl=us&client=safari
# https://us.etrade.com/e/t/activetrading/api
class ETradeToken < OauthToken
  
  settings "",
    :authorize_url => "https://us.etrade.com/e/etws/authorize"
  
end
