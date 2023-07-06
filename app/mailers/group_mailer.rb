class GroupMailer < ApplicationMailer

  def event_mail(owner, member, title, content)
  @content = content
  email = member.pluck(:email)
  email = ['sample@email.com']
  # @name = member.pluck(:name)
  mail(
    from: 'noreply@email.com',
    to: email,
    subject: title
  )
  end
end
