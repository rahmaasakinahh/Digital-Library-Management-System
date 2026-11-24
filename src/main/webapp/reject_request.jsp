<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.user or sessionScope.role ne 'admin'}">
    <c:redirect url="login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reject Request - Digital Library</title>
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

    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-800">Reject Borrow Request</h1>
            <p class="text-gray-600 mt-2">Provide a reason for rejection</p>
        </div>

        <!-- Request Details -->
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-xl font-bold text-gray-800 mb-4">Request Details</h2>
            <div class="grid md:grid-cols-2 gap-4">
                <div>
                    <p class="text-sm text-gray-600">Student</p>
                    <p class="font-semibold">${request.userFullName}</p>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Book</p>
                    <p class="font-semibold">${request.bookTitle}</p>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Borrow Date</p>
                    <p class="font-semibold">${request.borrowDate}</p>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Return Date</p>
                    <p class="font-semibold">${request.returnDate}</p>
                </div>
            </div>
        </div>

        <!-- Rejection Form -->
        <div class="bg-white rounded-lg shadow-md p-8">
            <form action="admin" method="post">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="requestId" value="${request.requestId}">

                <div class="mb-6">
                    <label for="adminNotes" class="block text-gray-700 font-semibold mb-2">
                        Reason for Rejection *
                    </label>
                    <textarea id="adminNotes" name="adminNotes" required rows="4"
                              placeholder="Provide a clear reason for rejecting this request..."
                              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                    <p class="text-sm text-gray-600 mt-2">
                        This message will be visible to the student.
                    </p>
                </div>

                <div class="flex gap-4">
                    <button type="submit"
                            class="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-6 rounded transition">
                        Reject Request
                    </button>
                    <a href="admin?action=pending"
                       class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-6 rounded transition">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
