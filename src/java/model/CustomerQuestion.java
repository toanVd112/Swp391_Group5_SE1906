package model;

import java.sql.Timestamp;

public class CustomerQuestion {

    private int questionID;
    private String customerName;
    private String phone;
    private String question;
    private String adminReply;
    private Timestamp createdAt;
    private Timestamp repliedAt;

    /* ----- GETTERS & SETTERS ----- */
    public int getQuestionID()                { return questionID; }
    public void setQuestionID(int questionID) { this.questionID = questionID; }

    public String getCustomerName()                 { return customerName; }
    public void setCustomerName(String customerName){ this.customerName = customerName; }

    public String getPhone()               { return phone; }
    public void setPhone(String phone)     { this.phone = phone; }

    public String getQuestion()            { return question; }
    public void setQuestion(String question){ this.question = question; }

    public String getAdminReply()                { return adminReply; }
    public void setAdminReply(String adminReply)  { this.adminReply = adminReply; }

    public Timestamp getCreatedAt()              { return createdAt; }
    public void setCreatedAt(Timestamp createdAt){ this.createdAt = createdAt; }

    public Timestamp getRepliedAt()               { return repliedAt; }
    public void setRepliedAt(Timestamp repliedAt) { this.repliedAt = repliedAt; }

    @Override
    public String toString() {
        return "CustomerQuestion{" +
               "questionID=" + questionID +
               ", customerName='" + customerName + '\'' +
               ", phone='" + phone + '\'' +
               ", question='" + question + '\'' +
               ", adminReply='" + adminReply + '\'' +
               ", createdAt=" + createdAt +
               ", repliedAt=" + repliedAt +
               '}';
    }
}
