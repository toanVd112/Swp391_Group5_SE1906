/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.util.ArrayList;
import java.util.List;
import model.BooKinglist;
import java.util.*;
import java.sql.*;

import model.BookingDetail;
import model.CartRoom;
import model.MaintenanceRequest;
import model.Room;
import model.RoomInspectionReport;
import model.RoomType;
import model.ServiceUsage;

/**
 *
 * @author Admin
 */
public class BookingDAOStaff {

    public List<BooKinglist> getAllBookings() {
        List<BooKinglist> list = new ArrayList<>();
        String sql = """
                SELECT 
                    b.BookingID, b.BookingDate, b.CheckInDate, b.CheckOutDate, b.Status,
                    b.ContactEmail, b.ContactPhone,
                    u.FullName,
                    bd.RoomTypeID, rt.Name AS RoomTypeName,
                    r.RoomNumber,
                    bd.Quantity, bd.GuestsCount, bd.Notes,
                    d.Code AS DiscountCode
                FROM bookings b
               LEFT  JOIN users u ON b.UserID = u.UserID
                JOIN bookingdetails bd ON b.BookingID = bd.BookingID
                JOIN roomtypes rt ON bd.RoomTypeID = rt.RoomTypeID
                LEFT JOIN rooms r ON bd.RoomID = r.RoomID
                LEFT JOIN discountcodes d ON b.DiscountCodeID = d.DiscountCodeID
                ORDER BY b.BookingDate DESC
                """;
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BooKinglist b = new BooKinglist();
                b.setBookingID(rs.getInt("BookingID"));
                b.setBookingDate(rs.getTimestamp("BookingDate"));
                b.setCheckInDate(rs.getDate("CheckInDate"));
                b.setCheckOutDate(rs.getDate("CheckOutDate"));
                b.setStatus(rs.getString("Status"));
                b.setContactEmail(rs.getString("ContactEmail"));
                b.setContactPhone(rs.getString("ContactPhone"));
                String fullName = rs.getString("FullName");
                if (fullName == null || fullName.trim().isEmpty()) {
                    fullName = "Guest";
                }
                b.setFullName(fullName);

                b.setRoomTypeName(rs.getString("RoomTypeName"));
                b.setRoomNumber(rs.getString("RoomNumber"));
                b.setQuantity(rs.getInt("Quantity"));
                b.setGuestsCount(rs.getInt("GuestsCount"));
                b.setNotes(rs.getString("Notes"));
                b.setDiscountCode(rs.getString("DiscountCode"));

                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void main(String[] args) {
        BookingDAOStaff dao = new BookingDAOStaff();
        List<BooKinglist> bookings = dao.getAllBookings();

        for (BooKinglist b : bookings) {
            System.out.println("BookingID: " + b.getBookingID());
            System.out.println("BookingDate: " + b.getBookingDate());
            System.out.println("CheckInDate: " + b.getCheckInDate());
            System.out.println("CheckOutDate: " + b.getCheckOutDate());
            System.out.println("Customer: " + b.getFullName());
            System.out.println("RoomType: " + b.getRoomTypeName());
            System.out.println("RoomNumber: " + b.getRoomNumber());
            System.out.println("Guests: " + b.getGuestsCount());
            System.out.println("Notes: " + b.getNotes());
            System.out.println("---------------------------");
        }
    }
}
