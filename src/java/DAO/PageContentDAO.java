/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import model.PageContent;
import java.sql.ResultSet;

/**
 *
 * @author Arcueid
 */
public class PageContentDAO {

    public List<PageContent> getPageContentsForGeneralUse() {
    List<PageContent> list = new ArrayList<>();
    String sql = "SELECT * FROM pagecontents WHERE RoomID IS NULL";

    try (java.sql.Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            PageContent pc = new PageContent(
                rs.getInt("ContentID"),
                null,
                rs.getString("PageSection"),
                rs.getString("Title"),
                rs.getString("Content")
            );
            list.add(pc);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
}