///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package controller;
//
//import java.time.LocalDateTime;
//import java.util.Properties;
//import java.util.UUID;
//import javax.mail.Authenticator;
//import javax.mail.Message;
//import javax.mail.PasswordAuthentication;
//import javax.mail.Session;
//import javax.mail.Transport;
//import javax.mail.internet.InternetAddress;
//import javax.mail.internet.MimeMessage;
//
///**
// *
// * @author AD
// */
//public class resetService {
//    private final int LIMIT_MINUS = 10;
//    private final String from = "toan74428@gmail.com"; //lấy mail này để gửi tbao cho mail cần reset password
//    private final String password = "isdo vhiq atbe ikkw";
//    
//    public String generateTOken(){  //generate ra doan ma random
//        return UUID.randomUUID().toString();
//    }
//    
//    public LocalDateTime expireDateTime(){  //tgian het han token do 
//        return LocalDateTime.now().plusMinutes(LIMIT_MINUS);
//    }
//    
//    public boolean isExpireTime(LocalDateTime time){    //check xem token do het han chua
//        return LocalDateTime.now().isAfter(time);
//    }
//    
//    public void sendEmail(String to, String link, String name){
//        Properties props = new Properties();
//        props.put("mail.smtp.host", "smtp.gamil.com");  //dia chi may chu gmail
//        props.put("mail.smtp.port", "587"); //cong ket noi, 587 la cong tieu chuan
//        props.put("mail.smtp.auth", "true");
//        props.put("mail.smtp.starttle.enable", "true");
//        
//        Authenticator auth = new Authenticator() {
//            @Override
//            protected PasswordAuthentication getPasswordAuthentication(){
//                return new PasswordAuthentication(from, password);
//            }
//        };
//        
//        Session session = Session.getInstance(props); //luu cac field
//        
//        MimeMessage msg = new MimeMessage(session);
//        
//        try {
//            msg.addHeader("Content-type", "text/html; charset=UTF-8");
//            msg.setFrom(from);
//            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
//            msg.setSubject("Reset password", "UTF-8");
//            String content = "<h1>Hello" + name + "/h1" + "<p>Click the link to reset password " + 
//                    "<a href=" + link + ">Click here </a></p>";
//            msg.setContent(content, "text/html, charset=UTF-8");
//            Transport.send(msg);
//            System.out.println("Send successfully!");
//        } catch (Exception e) {
//            System.out.println("Send error!");
//            System.out.println(e);
//        }
//    }
//}
