CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DOUBLE NOT NULL,
    discount INT DEFAULT 0, -- % Giảm giá
    stock INT NOT NULL,
    description TEXT
);

-- 2. Bảng Nhân viên (employees)
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE, -- Ngày sinh
    address VARCHAR(255),
    phone VARCHAR(15),
    role VARCHAR(50) DEFAULT 'Staff' -- Vai trò quản trị
);

-- 3. Bảng Khách hàng (customers)
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    phone VARCHAR(15),
    address VARCHAR(255),
    email VARCHAR(100) UNIQUE
);

-- 4. Bảng Đơn hàng (orders)
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    delivery_date DATETIME,
    shipping_address VARCHAR(255),
    payment_method VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL
);

-- 5. Bảng Chi tiết đơn hàng (order_details) - Giải quyết mối quan hệ Nhiều-Nhiều
CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price_at_purchase DOUBLE NOT NULL, -- Lưu giá tại thời điểm mua đề phòng sản phẩm đổi giá sau này
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO products (name, price, discount, stock, description) VALUES
('Laptop Dell XPS 13', 25000000, 5, 20, 'Laptop cao cấp mỏng nhẹ'),
('Chuột Logitech MX Master', 2500000, 10, 50, 'Chuột không dây công thái học'),
('Màn hình LG 27 inch', 5000000, 0, 15, 'Màn hình IPS 4K'),
('Bàn phím cơ Keychron', 2000000, 5, 30, 'Bàn phím cơ bluetooth'),
('Tai nghe Sony WH-1000XM5', 8000000, 8, 10, 'Tai nghe chống ồn chủ động'),
('Sạc dự phòng Anker', 800000, 15, 100, 'Sạc nhanh 20W'),
('Loa Bluetooth JBL', 1500000, 10, 40, 'Loa chống nước'),
('Ổ cứng SSD Samsung 1TB', 3000000, 5, 25, 'SSD tốc độ cao'),
('Webcam Logitech C920', 1800000, 0, 12, 'Webcam Full HD'),
('Giá đỡ laptop nhôm', 500000, 20, 60, 'Giá đỡ tản nhiệt');

-- 2. Chèn 10 khách hàng
INSERT INTO customers (name, dob, phone, address, email) VALUES
('Nguyễn Văn A', '1995-05-10', '0901234567', 'Cầu Giấy, Hà Nội', 'a.nguyen@email.com'),
('Trần Thị B', '1998-08-20', '0912345678', 'Hoài Đức, Hà Nội', 'b.tran@email.com'),
('Lê Văn C', '1992-12-05', '0923456789', 'Hòa Lạc, Hà Nội', 'c.le@email.com'),
('Phạm Thị D', '2000-01-15', '0934567890', 'Đống Đa, Hà Nội', 'd.pham@email.com'),
('Hoàng Văn E', '1996-03-25', '0945678901', 'Ba Đình, Hà Nội', 'e.hoang@email.com'),
('Đặng Thị F', '1999-07-30', '0956789012', 'Thanh Xuân, Hà Nội', 'f.dang@email.com'),
('Bùi Văn G', '1994-09-12', '0967890123', 'Hai Bà Trưng, Hà Nội', 'g.bui@email.com'),
('Đỗ Thị H', '1997-11-02', '0978901234', 'Tây Hồ, Hà Nội', 'h.do@email.com'),
('Vũ Văn I', '1993-02-18', '0989012345', 'Long Biên, Hà Nội', 'i.vu@email.com'),
('Phan Thị K', '1991-06-22', '0990123456', 'Hoàng Mai, Hà Nội', 'k.phan@email.com');

-- 3. Chèn 10 nhân viên
INSERT INTO employees (name, dob, address, phone, role) VALUES
('Trần Quản Lý', '1985-01-01', 'Hà Nội', '0900000001', 'Manager'),
('Lê Nhân Viên 1', '1995-02-02', 'Hà Nội', '0900000002', 'Staff'),
('Nguyễn Nhân Viên 2', '1996-03-03', 'Hà Nội', '0900000003', 'Staff'),
('Phạm Nhân Viên 3', '1994-04-04', 'Hà Nội', '0900000004', 'Staff'),
('Hoàng Nhân Viên 4', '1997-05-05', 'Hà Nội', '0900000005', 'Staff'),
('Đặng Nhân Viên 5', '1993-06-06', 'Hà Nội', '0900000006', 'Staff'),
('Bùi Nhân Viên 6', '1998-07-07', 'Hà Nội', '0900000007', 'Staff'),
('Đỗ Nhân Viên 7', '1992-08-08', 'Hà Nội', '0900000008', 'Staff'),
('Vũ Nhân Viên 8', '1999-09-09', 'Hà Nội', '0900000009', 'Staff'),
('Phan Nhân Viên 9', '1990-10-10', 'Hà Nội', '0900000010', 'Staff');

-- 4. Chèn 10 đơn hàng (Lưu ý: giả định IDs từ 1-10 tồn tại trong bảng customers & employees)
INSERT INTO orders (customer_id, employee_id, order_date, delivery_date, shipping_address, payment_method) VALUES
(1, 2, NOW(), NULL, 'Cầu Giấy, Hà Nội', 'COD'),
(2, 3, NOW(), NULL, 'Hoài Đức, Hà Nội', 'Credit Card'),
(3, 4, NOW(), NULL, 'Hòa Lạc, Hà Nội', 'Banking'),
(4, 5, NOW(), NULL, 'Đống Đa, Hà Nội', 'COD'),
(5, 6, NOW(), NULL, 'Ba Đình, Hà Nội', 'Banking'),
(6, 7, NOW(), NULL, 'Thanh Xuân, Hà Nội', 'Credit Card'),
(7, 8, NOW(), NULL, 'Hai Bà Trưng, Hà Nội', 'COD'),
(8, 9, NOW(), NULL, 'Tây Hồ, Hà Nội', 'Banking'),
(9, 10, NOW(), NULL, 'Long Biên, Hà Nội', 'Credit Card'),
(10, 2, NOW(), NULL, 'Hoàng Mai, Hà Nội', 'COD');

-- 5. Chèn 10 chi tiết đơn hàng (Mỗi đơn hàng 1 sản phẩm để test)
INSERT INTO order_details (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 25000000), (2, 2, 2, 2500000), (3, 3, 1, 5000000),
(4, 4, 1, 2000000), (5, 5, 1, 8000000), (6, 6, 5, 800000),
(7, 7, 1, 1500000), (8, 8, 1, 3000000), (9, 9, 1, 1800000),
(10, 10, 2, 500000);

