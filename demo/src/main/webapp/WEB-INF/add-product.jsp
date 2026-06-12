<%--
  Created by IntelliJ IDEA.
  User: luudu
  Date: 6/12/2026
  Time: 10:53 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thêm Mới Sản Phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .form-container {
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            padding: 30px;
            margin-top: 50px;
            margin-bottom: 50px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="form-container">
                <h2 class="mb-4 text-center text-primary"><i class="fa-solid fa-box-open me-2"></i>Thêm Mới Sản Phẩm
                </h2>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i><strong>Lỗi!</strong> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="product" method="post" class="needs-validation">

                    <input type="hidden" name="action" value="create">

                    <div class="mb-3">
                        <label for="name" class="form-label fw-bold">Tên sản phẩm <span
                                class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" name="name" value="${product.name}" required
                               placeholder="VD: Laptop Dell XPS 13">
                        <div class="form-text text-muted">Tên sản phẩm là bắt buộc.</div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="price" class="form-label fw-bold">Giá niêm yết <span
                                    class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="price" name="price"
                                       value="${product.price}" required min="101" step="0.01"
                                       placeholder="Nhập giá...">
                                <span class="input-group-text fw-bold">đ</span>
                            </div>
                            <div class="form-text text-muted">Bắt buộc và phải lớn hơn 100.</div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="stock" class="form-label fw-bold">Tồn kho <span
                                    class="text-danger">*</span></label>
                            <input type="number" class="form-control" id="stock" name="stock" value="${product.stock}"
                                   required min="11" placeholder="Số lượng...">
                            <div class="form-text text-muted">Bắt buộc và phải lớn hơn 10.</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="discount" class="form-label fw-bold">Mức giảm giá <span class="text-danger">*</span></label>
                        <select class="form-select" id="discount" name="discount" required>
                            <option value="" disabled ${empty product.discount ? 'selected' : ''}>-- Chọn mức giảm giá
                                --
                            </option>
                            <option value="5" ${product.discount == 5 ? 'selected' : ''}>5%</option>
                            <option value="10" ${product.discount == 10 ? 'selected' : ''}>10%</option>
                            <option value="15" ${product.discount == 15 ? 'selected' : ''}>15%</option>
                            <option value="20" ${product.discount == 20 ? 'selected' : ''}>20%</option>
                        </select>
                        <div class="form-text text-muted">Bắt buộc chọn một trong các mức có sẵn.</div>
                    </div>

                    <hr class="my-4">
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="product" class="btn btn-light border shadow-sm me-md-2">
                            <i class="fa-solid fa-arrow-left me-1"></i> Trở về danh sách
                        </a>
                        <button type="submit" class="btn btn-primary shadow-sm">
                            <i class="fa-solid fa-plus me-1"></i> Thêm sản phẩm
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
