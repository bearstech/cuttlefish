class Filters::Dkim < Filters::Base
  def filter_mail(mail)
    if active?(mail)
      Mail.new(Dkim.sign(mail.to_s, selector: 'cuttlefish', private_key: delivery.app.dkim_key, domain: delivery.app.from_domain))
    else
      mail.sender = Rails.configuration.cuttlefish_sender_email
      # TODO Sign with DKIM for cuttlefish_sender_email domain if available
      mail
    end
  end

  def active?(mail)
    from_domain = mail.from.first.split("@")[1]
    delivery.app.dkim_enabled && from_domain == delivery.app.from_domain
  end
end
