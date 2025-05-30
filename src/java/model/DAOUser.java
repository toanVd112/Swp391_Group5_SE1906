/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import DAO.DBConnect;
import org.apache.catalina.User;

/**
 *
 * @author AD
 */
public class DAOUser extends DBConnect{
    //check email ton tai
    DAOUser daoUser = new DAOUser();
    public User getUserByEmail(String email){
        String sql = "Select * from [Accounts] where email = ?";
        return null;
    }
}
