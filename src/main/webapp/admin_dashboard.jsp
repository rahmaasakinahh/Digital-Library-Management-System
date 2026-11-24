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
    <title>Admin Dashboard - Digital Library</title>
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
                    <span>Welcome, <strong>${sessionScope.fullName}</strong></span>
                    <a href="logout" class="bg-red-600 hover:bg-red-700 px-4 py-2 rounded transition">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                ${sessionScope.success}
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                ${sessionScope.error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-800">Admin Dashboard</h1>
            <p class="text-gray-600 mt-2">Manage books and borrowing requests</p>
        </div>

        <!-- Quick Actions -->
        <div class="grid md:grid-cols-4 gap-6 mb-8">
            <a href="books?action=add" class="bg-white rounded-lg shadow-md p-6 hover:shadow-xl transition transform hover:scale-105">
                <div class="flex items-center">
                    <div class="bg-green-100 rounded-full p-3 mr-4">
                        <svg class="w-8 h-8 text-green-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-bold text-lg text-gray-800">Add Book</h3>
                        <p class="text-gray-600 text-sm">New book</p>
                    </div>
                </div>
            </a>

            <a href="books?action=list" class="bg-white rounded-lg shadow-md p-6 hover:shadow-xl transition transform hover:scale-105">
                <div class="flex items-center">
                    <div class="bg-blue-100 rounded-full p-3 mr-4">
                        <svg class="w-8 h-8 text-blue-900" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-bold text-lg text-gray-800">All Books</h3>
                        <p class="text-gray-600 text-sm">Manage books</p>
                    </div>
                </div>
            </a>

            <a href="admin?action=pending" class="bg-white rounded-lg shadow-md p-6 hover:shadow-xl transition transform hover:scale-105">
                <div class="flex items-center">
                    <div class="bg-yellow-100 rounded-full p-3 mr-4">
                        <svg class="w-8 h-8 text-yellow-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-bold text-lg text-gray-800">Pending</h3>
                        <p class="text-gray-600 text-sm">Review requests</p>
                    </div>
                </div>
            </a>

            <a href="admin?action=list" class="bg-white rounded-lg shadow-md p-6 hover:shadow-xl transition transform hover:scale-105">
                <div class="flex items-center">
                    <div class="bg-purple-100 rounded-full p-3 mr-4">
                        <svg class="w-8 h-8 text-purple-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-bold text-lg text-gray-800">All Requests</h3>
                        <p class="text-gray-600 text-sm">View all</p>
                    </div>
                </div>
            </a>
        </div>

        <!-- Management Sections -->
        <div class="grid md:grid-cols-2 gap-6">
            <!-- Book Management -->
            <div class="bg-white rounded-lg shadow-md p-6">
                <h2 class="text-2xl font-bold text-gray-800 mb-4">Book Management</h2>
                <p class="text-gray-600 mb-4">Add, edit, or delete books from the library collection</p>
                <div class="space-y-2">
                    <a href="books?action=add" class="block bg-blue-900 hover:bg-blue-800 text-white font-bold py-2 px-4 rounded text-center transition">
                        Add New Book
                    </a>
                    <a href="books?action=list" class="block bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded text-center transition">
                        View All Books
                    </a>
                </div>
            </div>

            <!-- Request Management -->
            <div class="bg-white rounded-lg shadow-md p-6">
                <h2 class="text-2xl font-bold text-gray-800 mb-4">Request Management</h2>
                <p class="text-gray-600 mb-4">Approve or reject student borrowing requests</p>
                <div class="space-y-2">
                    <a href="admin_borrow_list.jsp?status=pending" class="block bg-yellow-600 hover:bg-yellow-700 text-white font-bold py-2 px-4 rounded text-center transition">
                        Pending Requests
                    </a>
                    <a href="admin_borrow_list.jsp" class="block bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded text-center transition">
                        All Requests
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
