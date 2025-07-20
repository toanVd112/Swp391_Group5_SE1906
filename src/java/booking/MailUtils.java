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

        String content = "Hello, " + fullName + ",\n\n"
                + "Thank you for booking a room at our hotel.\n"
                + "✔️Booking code: #" + bookingID + "\n"
                   + "token booking: #" + token + "\n"
                + "⏳ Booking will expire in 10 minutes if you do not pay.\n\n"
                + "👉 Please check or pay here:\n"
                + confirmLink + "\n\n"
                + "Thank you so much,\nHoang Nam Hotel."; 

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

    public static void sendBookingSuccessMail(String toEmail, String fullName, int bookingID, String checkIn, String checkOut) throws UnsupportedEncodingException {
    String subject = "[Hotel] Đặt phòng thành công - Booking #" + bookingID;

    String content = "Xin chào, " + fullName + ",<br><br>"
            + "Chúng tôi đã nhận được thanh toán của bạn. Dưới đây là thông tin đặt phòng:<br>"
            + "✔️ Mã đặt phòng: #" + bookingID + "<br>"
            + "📅 Nhận phòng: " + checkIn + "<br>"
            + "📤 Trả phòng: " + checkOut + "<br><br>"
            + "Cảm ơn bạn đã lựa chọn khách sạn Hoàng Nam!<br>";

    sendMail(toEmail, subject, content);
}

   public static void sendWelcomeDiscountMail(String toEmail, String fullName, String discountCode) throws UnsupportedEncodingException {
    String subject = "[Hoang Nam Hotel] Mã ưu đãi dành riêng cho bạn!";
    String content = "Xin chào <b>" + fullName + "</b>,<br><br>"
            + "Cảm ơn bạn đã thực hiện đơn đặt phòng đầu tiên tại <b>Hoang Nam Hotel</b>.<br>"
            + "🎁 Mã giảm giá dành cho bạn: <b style='color:#d97706;'>" + discountCode + "</b><br><br>"
            + "👉 Vui lòng nhập mã này ở bước thanh toán trong booking lần tới để nhận ưu đãi.<br><br>"
            + "Trân trọng,<br>Đội ngũ Hoang Nam Hotel.";
    sendMail(toEmail, subject, content);
}



}
