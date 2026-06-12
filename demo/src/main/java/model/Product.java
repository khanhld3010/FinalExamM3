package model;

public class Product {
    private int id;
    private String name;
    private double price;
    private int discount;
    private int stock;
    private String description;

    // 1. Constructor rỗng (Chuẩn Java Bean)
    public Product() {
    }

    // 2. Constructor đầy đủ tham số (Dùng khi map dữ liệu từ ResultSet của JDBC)
    public Product(int id, String name, double price, int discount, int stock, String description) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.discount = discount;
        this.stock = stock;
        this.description = description;
    }

    // 3. Constructor không có ID (Dùng khi nhận dữ liệu từ Form Thêm mới sản phẩm)
    public Product(String name, double price, int discount, int stock, String description) {
        this.name = name;
        this.price = price;
        this.discount = discount;
        this.stock = stock;
        this.description = description;
    }

    // --- Getters và Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getDiscount() {
        return discount;
    }

    public void setDiscount(int discount) {
        this.discount = discount;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // Ghi đè phương thức toString để hỗ trợ in ra Console khi cần debug (rất quan trọng)
    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", discount=" + discount +
                ", stock=" + stock +
                '}';
    }
}
