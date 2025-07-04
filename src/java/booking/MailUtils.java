/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author Admin
 */

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailUtils {

    // 👉 Hàm dùng để gửi mail Pending Booking kèm link xác nhận
    public static void sendBookingPendingMail(String toEmail, String fullName, int bookingID, String confirmLink) {
        String subject = "Xác nhận giữ chỗ Booking #" + bookingID;

        String content = "Xin chào " + fullName + ",\n\n"
                + "Cảm ơn bạn đã đặt phòng tại khách sạn của chúng tôi.\n"
                + "✔️ Mã booking: #" + bookingID + "\n"
                + "⏳ Booking sẽ hết hạn trong 10 phút nếu bạn không thanh toán.\n\n"
                + "👉 Vui lòng kiểm tra hoặc thanh toán tại đây:\n"
                + confirmLink + "\n\n"
                + "Trân trọng,\nKhách sạn của bạn.";

        sendMail(toEmail, subject, content);
    }

    // 👉 Hàm core: Gửi mail
    public static void sendMail(String to, String subject, String content) {
        final String fromEmail = "booking@yourhotel.com"; // ✅ Sửa email gửi
        final String password = "zokr qsib sgws xics";    // ✅ Sửa pass (App Password Gmail hoặc pass mail hosting)

        // ---- CẤU HÌNH SMTP ----
        Properties props = new Properties();

        boolean useGmail = false; // ✅ Bật true nếu test Gmail

        if (useGmail) {
            // ---- GMAIL ----
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true"); // TLS
        } else {
            // ---- SMTP HOSTING ----
            props.put("mail.smtp.host", "mail.yourhotel.com"); // ✅ Sửa host
            props.put("mail.smtp.port", "587");                // Thường 587 TLS hoặc 465 SSL
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");    // Nếu dùng TLS

            // Nếu xài SSL (port 465) thì dùng:
            // props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            // props.put("mail.smtp.port", "465");
        }

        // ---- TẠO PHIÊN SMTP ----
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(content);

            Transport.send(message);

            System.out.println("✅ Gửi mail thành công đến: " + to);

        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException("❌ Lỗi gửi mail: " + e.getMessage());
        }
    }
}