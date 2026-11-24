<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.user or sessionScope.role ne 'admin'}">
    <c:redirect url="login.jsp"/>
</c:if>
<jsp:useBean id="borrowRequestDAO" class="com.library.dao.BorrowRequestDAO"/>
<c:choose>
    <c:when test="${not empty param.status}">
        <c:set var="requests" value="${borrowRequestDAO.findByStatus(param.status)}"/>
    </c:when>
    <c:otherwise>
        <c:set var="requests" value="${borrowRequestDAO.findAll()}"/>
    </c:otherwise>
</c:choose>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Requests - Digital Library</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">
    <!-- Navigation -->
    <nav class="bg-blue-900 text-white shadow-lg">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center">
                    <svg class="w-8 h-8 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                    </svg>
                    <span class="font-bold text-xl">Digital Library - Admin</span>
                </div>
                <div class="flex items-center space-x-4">
                    <a href="admin_dashboard.jsp" class="hover:text-blue-200">Dashboard</a>
                    <a href="logout" class="bg-red-600 hover:bg-red-700 px-4 py-2 rounded transition">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div id="successMsg" class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                ${sessionScope.success}
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div id="errorMsg" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                ${sessionScope.error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-800">Borrowing Requests</h1>
            <p class="text-gray-600 mt-2">Manage student borrowing requests</p>
        </div>

        <!-- Filter Buttons -->
        <div class="mb-6 flex flex-wrap gap-2">
            <a href="admin_borrow_list.jsp" 
               class="px-4 py-2 rounded ${empty param.status ? 'bg-blue-900 text-white' : 'bg-gray-200 text-gray-800 hover:bg-gray-300'} transition">
                All
            </a>
            <a href="admin_borrow_list.jsp?status=pending" 
               class="px-4 py-2 rounded ${param.status eq 'pending' ? 'bg-yellow-600 text-white' : 'bg-gray-200 text-gray-800 hover:bg-gray-300'} transition">
                Pending
            </a>
            <a href="admin_borrow_list.jsp?status=approved" 
               class="px-4 py-2 rounded ${param.status eq 'approved' ? 'bg-green-600 text-white' : 'bg-gray-200 text-gray-800 hover:bg-gray-300'} transition">
                Approved
            </a>
            <a href="admin_borrow_list.jsp?status=rejected" 
               class="px-4 py-2 rounded ${param.status eq 'rejected' ? 'bg-red-600 text-white' : 'bg-gray-200 text-gray-800 hover:bg-gray-300'} transition">
                Rejected
            </a>
            <a href="admin_borrow_list.jsp?status=returned" 
               class="px-4 py-2 rounded ${param.status eq 'returned' ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-800 hover:bg-gray-300'} transition">
                Returned
            </a>
        </div>

        <!-- Requests Table -->
        <div id="requestsContainer" class="bg-white rounded-lg shadow-md overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Student</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Book</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Dates</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="request" items="${requests}">
                            <tr>
                                <td class="px-6 py-4">
                                    <div class="text-sm font-medium text-gray-900">${request.userFullName}</div>
                                    <div class="text-sm text-gray-500">${request.userName}</div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-sm font-medium text-gray-900">${request.bookTitle}</div>
                                    <div class="text-sm text-gray-500">by ${request.bookAuthor}</div>
                                </td>
                                <td class="px-6 py-4 text-sm text-gray-900">
                                    <div>Borrow: ${request.borrowDate}</div>
                                    <div>Return: ${request.returnDate}</div>
                                </td>
                                <td class="px-6 py-4">
                                    <c:choose>
                                        <c:when test="${request.status eq 'pending'}">
                                            <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">Pending</span>
                                        </c:when>
                                        <c:when test="${request.status eq 'approved'}">
                                            <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">Approved</span>
                                        </c:when>
                                        <c:when test="${request.status eq 'rejected'}">
                                            <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">Rejected</span>
                                        </c:when>
                                        <c:when test="${request.status eq 'returned'}">
                                            <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">Returned</span>
                                        </c:when>
                                    </c:choose>
                                    <c:if test="${not empty request.adminNotes}">
                                        <div class="text-xs text-gray-500 mt-1">${request.adminNotes}</div>
                                    </c:if>
                                </td>
                                <td class="px-6 py-4 text-sm">
                                    <c:if test="${request.status eq 'pending'}">
                                        <div class="flex flex-col space-y-2">
                                            <a href="admin?action=approve&id=${request.requestId}" 
                                               class="text-green-600 hover:text-green-900 font-semibold">Approve</a>
                                            <a href="admin?action=reject&id=${request.requestId}" 
                                               class="text-red-600 hover:text-red-900 font-semibold">Reject</a>
                                        </div>
                                    </c:if>
                                    <c:if test="${request.status eq 'approved'}">
                                        <form action="admin" method="post" class="inline">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="requestId" value="${request.requestId}">
                                            <input type="hidden" name="status" value="returned">
                                            <button type="submit" class="text-blue-600 hover:text-blue-900 font-semibold">
                                                Mark Returned
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty requests}">
                <div class="p-12 text-center">
                    <p class="text-gray-600 text-lg">No requests found</p>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        // Auto-hide success/error messages after 5 seconds
        setTimeout(() => {
            const successMsg = document.getElementById('successMsg');
            const errorMsg = document.getElementById('errorMsg');
            if (successMsg) successMsg.style.display = 'none';
            if (errorMsg) errorMsg.style.display = 'none';
        }, 5000);
    </script>
</body>
</html>
