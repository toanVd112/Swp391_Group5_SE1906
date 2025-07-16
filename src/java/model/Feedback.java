/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Arcueid
 */
public class Feedback {

    private int feedbackID;
    private int userID;
    private int bookingID;
    private int rating;
    private String comment;
    private Date feedbackDate;

    // Thông tin người dùng từ bảng users
    private String fullName;
    private String email;
    private String facebook;
    private String instagram;
    private String gender;

    // Cờ hiển thị
    private boolean showEmail;
    private boolean showFacebook;
    private boolean showInstagram;

    // --- Constructors ---
    public Feedback() {
    }

    public Feedback(int feedbackID, int userID, int bookingID, int rating, String comment, Date feedbackDate) {
        this.feedbackID = feedbackID;
        this.userID = userID;
        this.bookingID = bookingID;
        this.rating = rating;
        this.comment = comment;
        this.feedbackDate = feedbackDate;
    }

    // --- Getters & Setters ---
    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getFeedbackDate() {
        return feedbackDate;
    }

    public void setFeedbackDate(Date feedbackDate) {
        this.feedbackDate = feedbackDate;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFacebook() {
        return facebook;
    }

    public void setFacebook(String facebook) {
        this.facebook = facebook;
    }

    public String getInstagram() {
        return instagram;
    }

    public void setInstagram(String instagram) {
        this.instagram = instagram;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public boolean isShowEmail() {
        return showEmail;
    }

    public void setShowEmail(boolean showEmail) {
        this.showEmail = showEmail;
    }

    public boolean isShowFacebook() {
        return showFacebook;
    }

    public void setShowFacebook(boolean showFacebook) {
        this.showFacebook = showFacebook;
    }

    public boolean isShowInstagram() {
        return showInstagram;
    }

    public void setShowInstagram(boolean showInstagram) {
        this.showInstagram = showInstagram;
    }
}
