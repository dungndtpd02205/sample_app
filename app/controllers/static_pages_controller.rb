class StaticPagesController < ApplicationController
  before_action :set_locale

  def home; end

  def help; end

  def about; end

  def contact; end

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = I18n.default_locale
    I18n.locale = locale if I18n.available_locales.include?(locale)
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
