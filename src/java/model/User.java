package model;

/**
 * Model class representing a User in the system.
 */
public class User {
    private int userId;
    private int accountId;
    private String fullName;
    private String email;
    private String phone;
    private String dateOfBirth;  // Định dạng lưu: dd/MM/yyyy
    private String address;

    public User() {
    }

    public User(int userId, int accountId, String fullName, String email, String phone, String dateOfBirth, String address) {
        this.userId = userId;
        this.accountId = accountId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getFullName() {
        return fullName;
    }

    /** Tên chỉ chứa chữ và khoảng trắng, tối đa 30 ký tự */
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    /** Email hợp lệ */
    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    /** Số điện thoại đúng 10 chữ số */
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    /** Định dạng dd/MM/yyyy, chỉ số và dấu '/' */
    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getAddress() {
        return address;
    }

    /** Địa chỉ tối đa 30 ký tự */
    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "User{"
            + "userId=" + userId
            + ", accountId=" + accountId
            + ", fullName='" + fullName + '\''
            + ", email='" + email + '\''
            + ", phone='" + phone + '\''
            + ", dateOfBirth='" + dateOfBirth + '\''
            + ", address='" + address + '\''
            + '}';
    }
}
