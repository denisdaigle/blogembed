# Preview all emails at http://localhost:3000/rails/mailers/general_mailer
class GeneralMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/general_mailer/general_email
  def general_email
    GeneralMailer.general_email
  end

end
