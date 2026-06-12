package service;

import DAO.ProductDAO;
import DTO.TopProductDTO;
import model.Product;

import java.util.List;

public class ProductService {
    private ProductDAO productDAO;

    public ProductService() {
        this.productDAO = new ProductDAO();
    }

    /**
     * Lấy danh sách toàn bộ sản phẩm từ DAO.
     * Tương lai có thể bổ sung thêm các logic kiểm tra quyền, hoặc lọc dữ liệu rác tại đây.
     */
    public List<Product> getAllProducts() {
        return productDAO.getAllProducts();
    }

    public void addProduct(Product product) {
        productDAO.insertProduct(product);
    }

    public List<TopProductDTO> getTopSellingProducts(int limit) {
        return productDAO.getTopSellingProducts(limit);
    }

    public List<TopProductDTO> getProductsOrderedBetweenDates(String fromDate, String toDate) {
        return productDAO.getProductsOrderedBetweenDates(fromDate, toDate);
    }
}
