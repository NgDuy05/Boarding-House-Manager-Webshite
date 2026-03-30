<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/notification?action=list"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-bell-plus me-2"></i>New Notification</h4>
    </div>

    <div class="card shadow-sm border-0" style="max-width:600px;">
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/notification">
                <input type="hidden" name="action" value="create">
                <input type="hidden" name="createdBy" value="${sessionScope.user.userId}">

                <div class="mb-3">
                    <label class="form-label fw-semibold">Title <span class="text-danger">*</span></label>
                    <input type="text" name="title" class="form-control" required
                           placeholder="Notification title">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Content <span class="text-danger">*</span></label>
                    <textarea name="content" class="form-control" rows="4" required
                              placeholder="Notification content…"></textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold">Target Contract ID
                        <span class="text-muted small fw-normal">(leave blank to send as general to all)</span>
                    </label>
                    <input type="number" name="targetContractId" class="form-control"
                           placeholder="e.g. 12">
                    <div class="form-text"><i class="bi bi-info-circle me-1"></i>
                        Enter a contract ID to send a private notification. Leave blank to broadcast to all tenants.
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-send me-1"></i>Send
                    </button>
                    <a href="${pageContext.request.contextPath}/notification?action=list"
                       class="btn btn-outline-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

</t:layout>
