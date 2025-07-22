package model;

import java.sql.Timestamp;

public class Feedback {
    private int feedbackID;
    private int bookingID;
    private int userID;
    private int roomTypeID;
    private int rating;
    private String comment;
    private Timestamp feedbackDate;
    private boolean isAnonymous;
    
    // Additional fields for display purposes
    private String userName;
    private String userEmail;
    private String userAvatar;
    private String roomTypeName;
    private RoomType roomType;

    // Default constructor
    public Feedback() {
        this.feedbackDate = new Timestamp(System.currentTimeMillis());
    }

    // Constructor with basic fields
    public Feedback(int bookingID, int userID, int roomTypeID, int rating, String comment, boolean isAnonymous) {
        this();
        this.bookingID = bookingID;
        this.userID = userID;
        this.roomTypeID = roomTypeID;
        this.rating = rating;
        this.comment = comment;
        this.isAnonymous = isAnonymous;
    }

    // Constructor with all fields
    public Feedback(int feedbackID, int bookingID, int userID, int roomTypeID, int rating, 
                   String comment, Timestamp feedbackDate, boolean isAnonymous) {
        this.feedbackID = feedbackID;
        this.bookingID = bookingID;
        this.userID = userID;
        this.roomTypeID = roomTypeID;
        this.rating = rating;
        this.comment = comment;
        this.feedbackDate = feedbackDate;
        this.isAnonymous = isAnonymous;
    }

    // Getters and Setters
    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getRoomTypeID() {
        return roomTypeID;
    }

    public void setRoomTypeID(int roomTypeID) {
        this.roomTypeID = roomTypeID;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        if (rating >= 1 && rating <= 5) {
            this.rating = rating;
        } else {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getFeedbackDate() {
        return feedbackDate;
    }

    public void setFeedbackDate(Timestamp feedbackDate) {
        this.feedbackDate = feedbackDate;
    }

    public boolean isAnonymous() {
        return isAnonymous;
    }

    public void setAnonymous(boolean anonymous) {
        this.isAnonymous = anonymous;
    }

    // Display fields getters and setters
    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserAvatar() {
        return userAvatar;
    }

    public void setUserAvatar(String userAvatar) {
        this.userAvatar = userAvatar;
    }

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
    }

    // Helper methods
    public String getDisplayAvatar() {
        if (isAnonymous || userAvatar == null || userAvatar.trim().isEmpty()) {
            return "assets/images/anonymous-avatar.png";
        }
        return userAvatar;
    }

    public String getDisplayName() {
        if (isAnonymous || userName == null || userName.trim().isEmpty()) {
            return "Anonymous Guest";
        }
        return userName;
    }

    public boolean hasComment() {
        return comment != null && !comment.trim().isEmpty();
    }

    public String getFormattedComment() {
        if (hasComment()) {
            return comment.trim();
        }
        return "No comment provided";
    }

    public String getRatingStars() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }

    // Validation methods
    public boolean isValidRating() {
        return rating >= 1 && rating <= 5;
    }

    public boolean isValidComment() {
        return comment == null || comment.length() <= 1000;
    }

    public boolean isValid() {
        return isValidRating() && isValidComment() && 
               bookingID > 0 && userID > 0 && roomTypeID > 0;
    }

    // Utility methods
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Feedback feedback = (Feedback) obj;
        return feedbackID == feedback.feedbackID;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(feedbackID);
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "feedbackID=" + feedbackID +
                ", bookingID=" + bookingID +
                ", userID=" + userID +
                ", roomTypeID=" + roomTypeID +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", feedbackDate=" + feedbackDate +
                ", isAnonymous=" + isAnonymous +
                ", userName='" + userName + '\'' +
                ", roomTypeName='" + roomTypeName + '\'' +
                '}';
    }

    // Builder pattern for easier object creation
    public static class Builder {
        private Feedback feedback;

        public Builder() {
            feedback = new Feedback();
        }

        public Builder feedbackID(int feedbackID) {
            feedback.setFeedbackID(feedbackID);
            return this;
        }

        public Builder bookingID(int bookingID) {
            feedback.setBookingID(bookingID);
            return this;
        }

        public Builder userID(int userID) {
            feedback.setUserID(userID);
            return this;
        }

        public Builder roomTypeID(int roomTypeID) {
            feedback.setRoomTypeID(roomTypeID);
            return this;
        }

        public Builder rating(int rating) {
            feedback.setRating(rating);
            return this;
        }

        public Builder comment(String comment) {
            feedback.setComment(comment);
            return this;
        }

        public Builder feedbackDate(Timestamp feedbackDate) {
            feedback.setFeedbackDate(feedbackDate);
            return this;
        }

        public Builder anonymous(boolean anonymous) {
            feedback.setAnonymous(anonymous);
            return this;
        }

        public Builder userName(String userName) {
            feedback.setUserName(userName);
            return this;
        }

        public Builder userEmail(String userEmail) {
            feedback.setUserEmail(userEmail);
            return this;
        }

        public Builder userAvatar(String userAvatar) {
            feedback.setUserAvatar(userAvatar);
            return this;
        }

        public Builder roomTypeName(String roomTypeName) {
            feedback.setRoomTypeName(roomTypeName);
            return this;
        }

        public Builder roomType(RoomType roomType) {
            feedback.setRoomType(roomType);
            return this;
        }

        public Feedback build() {
            if (!feedback.isValid()) {
                throw new IllegalStateException("Invalid feedback data");
            }
            return feedback;
        }
    }
}
