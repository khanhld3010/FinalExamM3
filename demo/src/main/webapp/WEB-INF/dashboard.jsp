<%--
  Created by IntelliJ IDEA.
  User: luudu
  Date: 6/12/2026
  Time: 10:23 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Bảng Điều Khiển Quản Trị - Hệ Thống eCommerce</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .card-filter {
            background: #ffffff;
            border: none;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .table-container {
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            padding: 20px;
        }

        .page-header {
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 15px;
        }
    </style>
</head>
<body>

<div class="container-fluid px-4 py-5">
    <div class="d-flex justify-content-between align-items-center page-header mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">Quản Lý Hệ Thống</h1>
            <p class="text-muted mb-0">Báo cáo tổng quan và danh sách sản phẩm</p>
        </div>
        <a href="product?action=create" class="btn btn-primary btn-lg shadow-sm">
            <i class="fa-solid fa-plus me-2"></i>Thêm mới sản phẩm
        </a>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-12 col-md-5">
            <div class="card card-filter h-100 p-3">
                <form action="product" method="get" class="mb-0">
                    <input type="hidden" name="action" value="top-selling">
                    <label class="form-label fw-bold text-secondary text-uppercase small">Sản phẩm bán chạy nhất</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="fa-solid fa-fire text-danger"></i></span>
                        <select name="limit" class="form-select">
                            <option value="5" ${param.limit == '5' ? 'selected' : ''}>Top 5 sản phẩm</option>
                            <option value="10" ${param.limit == '10' ? 'selected' : (param.limit == null ? 'selected' : '')}>
                                Top 10 sản phẩm
                            </option>
                            <option value="20" ${param.limit == '20' ? 'selected' : ''}>Top 20 sản phẩm</option>
                        </select>
                        <button type="submit" class="btn btn-danger">Xem kết quả</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="col-12 col-md-7">
            <div class="card card-filter h-100 p-3">
                <form action="product" method="get" class="mb-0">
                    <input type="hidden" name="action" value="ordered-by-date">
                    <label class="form-label fw-bold text-secondary text-uppercase small">Sản phẩm được đặt hàng theo
                        thời gian</label>
                    <div class="row g-2">
                        <div class="col-5">
                            <select name="month" class="form-select" required>
                                <option value="">Chọn Tháng...</option>
                                <c:forEach var="m" begin="1" end="12">
                                    <option value="${m}" ${param.month == m ? 'selected' : ''}>Tháng ${m}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-4">
                            <input type="number" name="year" class="form-control" placeholder="Năm..." min="2000"
                                   max="2100" value="${param.year != null ? param.year : '2026'}" required>
                        </div>
                        <div class="col-3">
                            <button type="submit" class="btn btn-success w-100"><i class="fa-solid fa-filter me-1"></i>Lọc
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="mb-3">
        <h4 class="text-dark h5">
            <c:choose>
                <c:when test="${param.action == 'top-selling'}">
                    <i class="fa-solid fa-list-ol me-2 text-danger"></i>Danh sách ${param.limit} sản phẩm bán chạy nhất
                </c:when>
                <c:when test="${param.action == 'ordered-by-date'}">
                    <i class="fa-solid fa-calendar-check me-2 text-success"></i>Danh sách sản phẩm được đặt hàng trong: Tháng ${param.month} / Năm ${param.year}
                </c:when>
                <c:otherwise>
                    <i class="fa-solid fa-boxes-stacked me-2 text-primary"></i>Danh sách toàn bộ sản phẩm hiện có
                </c:otherwise>
            </c:choose>
        </h4>
    </div>

    <div class="table-container">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light text-uppercase fs-7 text-secondary">
                <tr>
                    <th style="width: 80px;" class="text-center">STT</th>
                    <th>Tên sản phẩm</th>
                    <th class="text-end">Giá niêm yết</th>
                    <th class="text-center">Mức giảm giá</th>
                    <th class="text-center">Số lượng tồn kho</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty listProduct}">
                        <c:forEach var="product" items="${listProduct}" varStatus="status">
                            <tr>
                                <td class="text-center fw-bold text-muted">${status.index + 1}</td>
                                <td class="fw-semibold text-dark">${product.name}</td>
                                <td class="text-end text-primary fw-bold">
                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="đ"
                                                      maxFractionDigits="0"/>
                                </td>
                                <td class="text-center">
                                    <c:if test="${product.discount > 0}">
                                            <span class="badge bg-danger-subtle text-danger px-2.5 py-1.5 rounded">
                                                <i class="fa-solid fa-arrow-down-long me-1"></i>-${product.discount}%
                                            </span>
                                    </c:if>
                                    <c:if test="${product.discount == 0}">
                                        <span class="text-muted">-</span>
                                    </c:if>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${product.stock <= 5}">
                                            <span class="badge bg-danger text-white rounded-pill px-3">${product.stock} (Sắp hết)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-dark fw-medium">${product.stock}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" class="text-center py-5 text-muted">
                                <i class="fa-solid fa-inbox fa-3x mb-3 text-light"></i>
                                <p class="mb-0">Không có dữ liệu hiển thị cho điều kiện lọc hiện tại.</p>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
