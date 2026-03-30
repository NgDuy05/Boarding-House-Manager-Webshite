<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Create Bill - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="../../navbar.jsp" %>

<div class="container-fluid">
<div class="row flex-nowrap admin-layout-row">
<%@ include file="../sidebar.jsp" %>
<main class="col admin-main px-4 py-4">

<div style="max-width:700px;">
    <h4 class="mb-4"><i class="bi bi-plus-circle me-2"></i>Create Bill</h4>

    <div class="card shadow-sm border-0">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/bill" method="post">
                <input type="hidden" name="action" value="create">

                <%-- Contract --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Contract</label>
                    <select name="contractId" class="form-select" required>
                        <option value="">-- Select Contract --</option>
                        <c:forEach var="c" items="${contracts}">
                            <option value="${c.contractId}">Contract #${c.contractId} — Room ${c.roomId}</option>
                        </c:forEach>
                    </select>
                </div>

                <%-- Period & Due Date --%>
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Period (billing month)</label>
                        <input type="month" name="period" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Due Date</label>
                        <input type="date" name="dueDate" class="form-control" required>
                    </div>
                </div>

                <%-- Bill Items --%>
                <div class="mb-3">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <label class="form-label fw-semibold mb-0">Bill Items</label>
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="addItem()">
                            <i class="bi bi-plus-lg me-1"></i>Add Item
                        </button>
                    </div>
                    <%-- Build category options string for JS reuse --%>
                    <script>
                        const categoryOptions = `<option value="">-- Category --</option>`
                            + [<c:forEach var="cat" items="${categories}" varStatus="s">
                                `<option value="${cat.categoryId}">${cat.categoryCode}</option>`${!s.last ? ',' : ''}
                               </c:forEach>].join('');
                    </script>
                    <div id="items-container">
                        <%-- Initial row --%>
                        <div class="item-row row g-2 mb-2 align-items-center">
                            <div class="col-3">
                                <select name="itemCategoryId[]" class="form-select form-select-sm" required>
                                    <option value="">-- Category --</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.categoryId}">${cat.categoryCode}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-4">
                                <input type="text" name="itemDesc[]" class="form-control form-control-sm"
                                       placeholder="Description" required>
                            </div>
                            <div class="col-2">
                                <input type="number" name="itemQty[]" class="form-control form-control-sm item-qty"
                                       placeholder="Qty" min="1" step="any" value="1" required onchange="calcTotal()">
                            </div>
                            <div class="col-2">
                                <input type="number" name="itemPrice[]" class="form-control form-control-sm item-price"
                                       placeholder="Unit Price" min="0" step="any" required onchange="calcTotal()">
                            </div>
                            <div class="col-1 text-center">
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(this)">
                                    <i class="bi bi-x-lg"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Total (read-only preview) --%>
                <div class="mb-4 d-flex justify-content-end">
                    <div class="fw-bold fs-5">
                        Total: <span id="total-preview">0</span>&#8363;
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-save me-1"></i>Save Bill
                    </button>
                    <a href="${pageContext.request.contextPath}/bill?action=list" class="btn btn-outline-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function addItem() {
        const container = document.getElementById('items-container');
        const row = document.createElement('div');
        row.className = 'item-row row g-2 mb-2 align-items-center';
        row.innerHTML = `
            <div class="col-3">
                <select name="itemCategoryId[]" class="form-select form-select-sm" required>
                    ${categoryOptions}
                </select>
            </div>
            <div class="col-4">
                <input type="text" name="itemDesc[]" class="form-control form-control-sm"
                       placeholder="Description" required>
            </div>
            <div class="col-2">
                <input type="number" name="itemQty[]" class="form-control form-control-sm item-qty"
                       placeholder="Qty" min="1" step="any" value="1" required onchange="calcTotal()">
            </div>
            <div class="col-2">
                <input type="number" name="itemPrice[]" class="form-control form-control-sm item-price"
                       placeholder="Unit Price" min="0" step="any" required onchange="calcTotal()">
            </div>
            <div class="col-1 text-center">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(this)">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>`;
        container.appendChild(row);
    }
        container.appendChild(row);
    }

    function removeItem(btn) {
        const rows = document.querySelectorAll('.item-row');
        if (rows.length > 1) {
            btn.closest('.item-row').remove();
            calcTotal();
        }
    }

    function calcTotal() {
        let total = 0;
        document.querySelectorAll('.item-row').forEach(row => {
            const qty   = parseFloat(row.querySelector('.item-qty')?.value)   || 0;
            const price = parseFloat(row.querySelector('.item-price')?.value) || 0;
            total += qty * price;
        });
        document.getElementById('total-preview').textContent = total.toLocaleString('vi-VN');
    }
</script>
<%@ include file="../../footer.jsp" %>
</main>
</div>
</div>
</body>
</html>
