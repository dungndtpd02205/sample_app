module UsersHelper
  def gravatar_for user, size: 80
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url =
      I18n.t("sigup_attr.gravatar_url",
        gravatar_id: gravatar_id, size: size)
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
