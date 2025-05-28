/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
public class Validation {

    public static boolean validateUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false; // Không được null hoặc rỗng
        }
        // Có thể thêm điều kiện khác như độ dài, ký tự đặc biệt
        if (username.length() < 4 || username.length() > 20) {
            return false; // Độ dài phù hợp
        }
        return true;
    }

    // Kiểm tra mật khẩu (password)
    public static boolean validatePassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return false; // Không được null hoặc rỗng
        }
        // Độ dài tối thiểu 6 ký tự
        if (password.length() < 6) {
            return false;
        }
        // Có ít nhất một chữ hoa, một chữ thường, một số, ký tự đặc biệt
        return true;
    }
}
