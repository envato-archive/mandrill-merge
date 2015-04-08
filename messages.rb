require 'i18n'
require 'i18n/backend/fallbacks'

class App < Sinatra::Application
  configure do
    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
    I18n.enforce_available_locales = true
    I18n.backend.load_translations
  end
end