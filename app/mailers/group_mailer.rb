class GroupMailer < ApplicationMailer

  def event_mail(owner, member, title, content)
  @content = content
  email = member.pluck(:email)
  # @name = member.pluck(:name)
  mail(
    from: '-',
    to: email,
    subject: title
  )
  end
end
