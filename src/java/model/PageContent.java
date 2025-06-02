/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Arcueid
 */
public class PageContent {
    private int contentId;
    private Room room; // Liên kết đến đối tượng Room (tùy chọn)
    private String pageSection;
    private String title;
    private String content;

    public PageContent() {}

    public PageContent(int contentId, Room room, String pageSection, String title, String content) {
        this.contentId = contentId;
        this.room = room;
        this.pageSection = pageSection;
        this.title = title;
        this.content = content;
    }

    public int getContentId() {
        return contentId;
    }

    public void setContentId(int contentId) {
        this.contentId = contentId;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public String getPageSection() {
        return pageSection;
    }

    public void setPageSection(String pageSection) {
        this.pageSection = pageSection;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    @Override
    public String toString() {
        return "PageContent{" +
                "contentId=" + contentId +
                ", room=" + (room != null ? room.getRoomnumber() : "General") +
                ", pageSection='" + pageSection + '\'' +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                '}';
    }
}
