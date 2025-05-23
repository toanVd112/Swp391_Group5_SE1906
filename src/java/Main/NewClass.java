/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Main;

import DAO.AccountDAO;
import model.Account;

/**
 *
 * @author Admin
 */
public class NewClass {

    public static void main(String[] args) {
        // Tạo một đối tượng Account mới để test
        Account acc = new Account();
        acc.setUsername("testuser");
        acc.setPassword("testpass123");
        acc.setEmail("test@example.com");
        acc.setRole("Customer");

        // Gọi DAO
        AccountDAO dao = new AccountDAO();
        boolean result = dao.insertAccount(acc);

        // In kết quả
        if (result) {
            System.out.println("✅ Insert account thành công!");
        } else {
            System.out.println("❌ Insert account thất bại!");
        }
    }

}
