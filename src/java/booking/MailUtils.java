/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author Admin
 */
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;
public class MailUtils {

    // Hàm gửi mail Pending Booking kèm link
    public static void sendBookingPendingMail(String toEmail, String fullName, int bookingID,String token, String confirmLink) throws UnsupportedEncodingException {
        String subject = "[Hotel] Xác nhận giữ chỗ Booking #" + bookingID;

        String content = "Xin chào " + fullName + ",\n\n"
                + "Cảm ơn bạn đã đặt phòng tại khách sạn của chúng tôi.\n"
                + "✔️ Mã booking: #" + bookingID + "\n"
                   + "token booking: #" + token + "\n"
                + "⏳ Booking sẽ hết hạn trong 10 phút nếu bạn không thanh toán.\n\n"
                + "👉 Vui lòng kiểm tra hoặc thanh toán tại đây:\n"
                + confirmLink + "\n\n"
                + "Trân trọng,\nKhách sạn của bạn.";

        sendMail(toEmail, subject, content);
    }

    // Hàm core: Gửi mail qua Gmail
    public static void sendMail(String to, String subject, String content) throws UnsupportedEncodingException {
        final String fromEmail = "fcpctk@gmail.com"; // ✔️ Gmail bạn dùng để gửi
        final String password = "daeg attb munj hkxz";      // ✔️ App Password Gmail (16 ký tự)

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.debug", "true"); // Log debug chi tiết

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
          message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));
           message.setContent(content, "text/html; charset=UTF-8");
           


            Transport.send(message);

            System.out.println("✅ Gửi mail thành công đến: " + to);

        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException("❌ Lỗi gửi mail: " + e.getMessage());
        }
    }

}
