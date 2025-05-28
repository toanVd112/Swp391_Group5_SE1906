/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Admin
 */
public class CustomerQuestion {

    int QuestionID;
    String CustomerName, Email, setQuestion, AdminReply;
    Timestamp CreateAt, RepliedAt;

    public int getQuestionID() {
        return QuestionID;
    }

    public void setQuestionID(int QuestionID) {
        this.QuestionID = QuestionID;
    }

    public String getCustomerName() {
        return CustomerName;
    }

    public void setCustomerName(String CustomerName) {
        this.CustomerName = CustomerName;
    }

    public String getEmail() {
        return Email;
    }

    public void SetEmail(String setEmail) {
        this.Email = setEmail;
    }

    public String getQuestion() {
        return setQuestion;
    }

    public void SetQuestion(String setQuestion) {
        this.setQuestion = setQuestion;
    }

    public String getAdminReply() {
        return AdminReply;
    }

    public void setAdminReply(String AdminReply) {
        this.AdminReply = AdminReply;
    }

    public Timestamp getCreateAt() {
        return CreateAt;
    }

    public void setCreateAt(Timestamp CreateAt) {
        this.CreateAt = CreateAt;
    }

    public Timestamp getRepliedAt() {
        return RepliedAt;
    }

    public void setRepliedAt(Timestamp RepliedAt) {
        this.RepliedAt = RepliedAt;
    }

    public CustomerQuestion() {
    }

    public CustomerQuestion(int QuestionID, String CustomerName, String setEmail, String setQuestion, String AdminReply, Timestamp CreateAt, Timestamp RepliedAt) {
        this.QuestionID = QuestionID;
        this.CustomerName = CustomerName;
        this.Email = setEmail;
        this.setQuestion = setQuestion;
        this.AdminReply = AdminReply;
        this.CreateAt = CreateAt;
        this.RepliedAt = RepliedAt;
    }

}
