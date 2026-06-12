package DAO;

import DTO.TopProductDTO;
import model.Product;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private static final String SELECT_ALL_PRODUCTS = "SELECT * FROM products ORDER BY id DESC";
    private static final String INSERT_PRODUCT = "INSERT INTO products (name, price, discount, stock, description) VALUES (?, ?, ?, ?, ?)";
    private String querySelectTop = "SELECT p.*, COUNT(od.order_id) AS total_orders " +
            "FROM products p " +
            "JOIN order_details od ON p.id = od.product_id " +
            "GROUP BY p.id " +
            "ORDER BY total_orders DESC " +
            "LIMIT ?";

    String querySearchByDate = "SELECT p.*, SUM(od.quantity) AS total_quantity " +
            "FROM products p " +
            "JOIN order_details od ON p.id = od.product_id " +
            "JOIN orders o ON od.order_id = o.id " +
            "WHERE DATE(o.order_date) BETWEEN ? AND ? " +
            "GROUP BY p.id " +
            "ORDER BY total_quantity DESC";

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();

        // Sử dụng try-with-resources để tự động đóng các kết nối (AutoCloseable)
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_PRODUCTS);
             ResultSet rs = preparedStatement.executeQuery()) {

            // Duyệt qua từng dòng dữ liệu lấy được từ MySQL
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                double price = rs.getDouble("price");
                int discount = rs.getInt("discount");
                int stock = rs.getInt("stock");
                String description = rs.getString("description");

                // Tạo đối tượng Product và thêm vào danh sách
                products.add(new Product(id, name, price, discount, stock, description));
            }
        } catch (SQLException e) {
            // Trong thực tế sẽ dùng Logger để ghi lỗi, với bài tập ta in ra console để dễ debug
            System.err.println("Lỗi khi lấy danh sách sản phẩm: " + e.getMessage());
            e.printStackTrace();
        }

        return products;
    }

    public void insertProduct(Product product) {
        // Vẫn tiếp tục dùng try-with-resources để tự động đóng kết nối
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_PRODUCT)) {

            preparedStatement.setString(1, product.getName());
            preparedStatement.setDouble(2, product.getPrice());
            preparedStatement.setInt(3, product.getDiscount());
            preparedStatement.setInt(4, product.getStock());
            preparedStatement.setString(5, "Chưa có mô tả"); // Tạm gán mặc định vì form của bạn không có ô này

            // Thực thi lệnh INSERT
            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm mới sản phẩm: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<TopProductDTO> getTopSellingProducts(int limit) {
        List<TopProductDTO> products = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(querySelectTop)) {

            // Truyền tham số limit (ví dụ: 3, 5, 10)
            preparedStatement.setInt(1, limit);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                double price = rs.getDouble("price");
                int discount = rs.getInt("discount");
                int stock = rs.getInt("stock");
                String description = rs.getString("description");
                int totalOrders = rs.getInt("total_orders"); // Lấy thêm cột kết quả từ hàm COUNT

                // Tạo đối tượng DTO thay vì Product thường
                products.add(new TopProductDTO(id, name, price, discount, stock, description, totalOrders));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy top sản phẩm bán chạy: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public List<TopProductDTO> getProductsOrderedBetweenDates(String fromDate, String toDate) {
        List<TopProductDTO> products = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(querySearchByDate)) {

            // Truyền tham số ngày (Định dạng yyyy-MM-dd từ input HTML5)
            preparedStatement.setString(1, fromDate);
            preparedStatement.setString(2, toDate);

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                double price = rs.getDouble("price");
                int discount = rs.getInt("discount");
                int stock = rs.getInt("stock");
                String description = rs.getString("description");
                int totalQuantity = rs.getInt("total_quantity");

                // Truyền 0 cho totalOrders vì ta không dùng đến ở chức năng này
                products.add(new TopProductDTO(id, name, price, discount, stock, description, 0, totalQuantity));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lọc sản phẩm theo ngày: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }


}
