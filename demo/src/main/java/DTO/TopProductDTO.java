package DTO;

import model.Product;

public class TopProductDTO extends Product {
    private int totalOrders; // Số lần sản phẩm này xuất hiện trong các đơn hàng
    private int totalQuantity;

    public TopProductDTO() {
        super();
    }

    public TopProductDTO(int id, String name, double price, int discount, int stock, String description, int totalOrders) {
        super(id, name, price, discount, stock, description);
        this.totalOrders = totalOrders;
    }
    public TopProductDTO(int id, String name, double price, int discount, int stock, String description, int totalOrders, int totalQuantity) {
        super(id, name, price, discount, stock, description);
        this.totalOrders = totalOrders;
        this.totalQuantity = totalQuantity;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }
}
