require 'selenium/webdriver'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument('--disable-popup-blocking') # ポップアップブロック無効化
  end)
end

Capybara.javascript_driver = :selenium_chrome
