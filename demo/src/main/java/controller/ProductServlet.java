package controller;

import DTO.TopProductDTO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import service.ProductService;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "ProductServlet", urlPatterns = {"/product"})
public class ProductServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Mặc định là hiển thị danh sách nếu không có action
        }

        try {
            switch (action) {
                case "create":
                    showCreateForm(request, response);
                    break;
                case "top-selling":
                    showTopSellingProducts(request, response);
                    break;
                case "ordered-by-date":
                    showProductsByDate(request, response);
                    break;
                default:
                    // Luồng cơ bản: Hiển thị toàn bộ danh sách
                    listProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra trong quá trình xử lý!");
        }
    }

    private void showProductsByDate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        // Gọi Service lấy danh sách
        List<TopProductDTO> listProduct = productService.getProductsOrderedBetweenDates(fromDate, toDate);

        // Đẩy dữ liệu ra giao diện
        request.setAttribute("listProduct", listProduct);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    private void showTopSellingProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int limit = 10; // Mặc định là Top 10
        try {
            // Lấy tham số limit từ giao diện người dùng (Select box: 3, 5, 10)
            String limitStr = request.getParameter("limit");
            if (limitStr != null && !limitStr.isEmpty()) {
                limit = Integer.parseInt(limitStr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        // Gọi Service lấy danh sách DTO
        List<TopProductDTO> listProduct = productService.getTopSellingProducts(limit);

        // Vẫn set attribute tên là "listProduct" để tương thích ngược với file JSP cũ
        request.setAttribute("listProduct", listProduct);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/add-product.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            insertProduct(request, response);
        }
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String discountStr = request.getParameter("discount");

        // Khởi tạo các biến để ép kiểu
        double price = 0;
        int stock = 0;
        int discount = 0;
        String errorMessage = "";

        try {
            // Ép kiểu dữ liệu (Nếu user truyền chữ vào ô số, sẽ nhảy xuống catch)
            price = Double.parseDouble(priceStr);
            stock = Integer.parseInt(stockStr);
            discount = Integer.parseInt(discountStr);

            // Bắt đầu Validation đúng theo yêu cầu của bạn
            if (name == null || name.trim().isEmpty()) {
                errorMessage = "Tên sản phẩm không được để trống!";
            } else if (price <= 100) {
                errorMessage = "Giá sản phẩm phải lớn hơn 100!";
            } else if (stock <= 10) {
                errorMessage = "Số lượng tồn kho phải lớn hơn 10!";
            } else if (discount != 5 && discount != 10 && discount != 15 && discount != 20) {
                errorMessage = "Mức giảm giá không hợp lệ (Chỉ nhận 5, 10, 15, 20)!";
            }

        } catch (NumberFormatException e) {
            errorMessage = "Vui lòng nhập đúng định dạng số cho Giá, Tồn kho và Mức giảm giá!";
        }

        // Tạo sẵn đối tượng Product với dữ liệu người dùng vừa nhập (để bảo toàn dữ liệu nếu lỗi)
        Product newProduct = new Product(name, price, discount, stock, "");

        // Kiểm tra xem có lỗi Validation hay không
        if (!errorMessage.isEmpty()) {
            // CÓ LỖI: Trả lại thông báo lỗi và dữ liệu cũ về form
            request.setAttribute("errorMessage", errorMessage);
            request.setAttribute("product", newProduct);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/add-product.jsp");
            dispatcher.forward(request, response);
        } else {
            // HỢP LỆ: Lưu xuống Database
            productService.addProduct(newProduct);

            // Vì bạn chọn Phương án B (dùng forward), tôi sẽ lấy lại list và đẩy về dashboard
            List<Product> listProduct = productService.getAllProducts();
            request.setAttribute("listProduct", listProduct);
            request.setAttribute("successMessage", "Thêm mới sản phẩm thành công!");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/dashboard.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Gọi tầng Service để lấy dữ liệu
        List<Product> listProduct = productService.getAllProducts();

        // 2. Gắn dữ liệu vào request attribute để truyền sang JSP
        request.setAttribute("listProduct", listProduct);

        // 3. Điều hướng sang giao diện dashboard (Đảm bảo file dashboard.jsp nằm đúng đường dẫn)
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
