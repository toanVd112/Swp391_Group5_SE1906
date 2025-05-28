/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Arcueid
 */
public class RoomImage {
    private int imageID;
    private int roomID;
    private String imageUrl;

    public RoomImage() {
    }

    public RoomImage(int imageID, int roomID, String imageUrl, boolean isPrimary) {
        this.imageID = imageID;
        this.roomID = roomID;
        this.imageUrl = imageUrl;
    }

    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }


    
    @Override
    public String toString() {
        return "RoomImage{" +
                "imageID=" + imageID +
                ", roomID=" + roomID +
                ", imageUrl='" + imageUrl + '\'' 
                ;
    }
}

