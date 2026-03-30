package Utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

/**
 * Service for sending emails via Gmail SMTP (STARTTLS, port 587).
 *
 * Configuration:
 *   MAIL_USERNAME  - Gmail address (e.g. yourapp@gmail.com)
 *   MAIL_PASSWORD  - Gmail App Password (not your login password)
 *
 * To generate an App Password: Google Account → Security → 2-Step Verification → App Passwords
 */
public class EmailService {

    // ---- Paste your Gmail credentials here ----
    private static final String SMTP_HOST     = "smtp.gmail.com";
    private static final int    SMTP_PORT     = 587;
    private static final String MAIL_USERNAME = System.getenv("MAIL_USERNAME") != null
            ? System.getenv("MAIL_USERNAME") : "service.flowershop@gmail.com";
    private static final String MAIL_PASSWORD = System.getenv("MAIL_PASSWORD") != null
            ? System.getenv("MAIL_PASSWORD") : "odwh nwez shod jrvl";
    // -------------------------------------------

    private static final EmailService INSTANCE = new EmailService();

    private final Session mailSession;

    private EmailService() {
        Properties props = new Properties();
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host",             SMTP_HOST);
        props.put("mail.smtp.port",             String.valueOf(SMTP_PORT));
        props.put("mail.smtp.ssl.trust",        SMTP_HOST);

        mailSession = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(MAIL_USERNAME, MAIL_PASSWORD);
            }
        });
    }

    public static EmailService getInstance() {
        return INSTANCE;
    }

    /**
     * Send an OTP verification email to the given address.
     *
     * @param toEmail   recipient email
     * @param otp       6-digit OTP code
     * @throws MessagingException if the email fails to send
     */
    public void sendOtpEmail(String toEmail, String otp) throws MessagingException {
        Message message = new MimeMessage(mailSession);
        try {
            message.setFrom(new InternetAddress(MAIL_USERNAME, "AKDD House", "UTF-8"));
        } catch (java.io.UnsupportedEncodingException e) {
            // Fallback: set from without display name
            message.setFrom(new InternetAddress(MAIL_USERNAME));
        }
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Your Password Reset OTP - AKDD House");

        String body = buildOtpEmailBody(otp);
        message.setContent(body, "text/html; charset=UTF-8");

        Transport.send(message);
    }

    /** Build a simple HTML email body containing the OTP. */
    private String buildOtpEmailBody(String otp) {
        return "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;background:#f4f6f9;'>"
            + "<div style='max-width:480px;margin:32px auto;padding:32px;background:#fff;"
            +      "border:1px solid #e0e0e0;border-radius:12px;'>"
            + "<h2 style='color:#764ba2;margin-top:0;'>AKDD House</h2>"
            + "<p style='color:#333;'>You requested a password reset. Use the OTP code below:</p>"
            + "<div style='font-size:40px;font-weight:bold;letter-spacing:10px;"
            +      "color:#764ba2;text-align:center;padding:20px 0;'>" + otp + "</div>"
            + "<p style='color:#888;font-size:13px;'>This code is valid for <b>5 minutes</b>. "
            + "Do not share it with anyone.</p>"
            + "<p style='color:#888;font-size:13px;'>If you did not request a password reset, "
            + "you can safely ignore this email.</p>"
            + "<hr style='border:none;border-top:1px solid #eee;margin:20px 0;'>"
            + "<p style='color:#bbb;font-size:11px;text-align:center;'>AKDD House &copy; 2025</p>"
            + "</div></body></html>";
    }
}
