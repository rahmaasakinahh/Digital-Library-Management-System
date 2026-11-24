<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="bookDAO" class="com.library.dao.BookDAO"/>
<c:set var="books" value="${bookDAO.findAll()}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Books - Digital Library</title>
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
                    <span class="font-bold text-xl">Digital Library</span>
                </div>
                <div class="flex items-center space-x-4">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <c:if test="${sessionScope.role eq 'admin'}">
                                <a href="admin_dashboard.jsp" class="hover:text-blue-200">Dashboard</a>
                            </c:if>
                            <c:if test="${sessionScope.role eq 'student'}">
                                <a href="student_dashboard.jsp" class="hover:text-blue-200">Dashboard</a>
                            </c:if>
                            <a href="logout" class="bg-red-600 hover:bg-red-700 px-4 py-2 rounded transition">Logout</a>
                        </c:when>
                        <c:otherwise>
                            <a href="login.jsp" class="bg-blue-700 hover:bg-blue-600 px-4 py-2 rounded transition">Login</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-800">Book Collection</h1>
            <p class="text-gray-600 mt-2">Browse our extensive library collection</p>
        </div>

        <!-- Search and Filter -->
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <form action="books" method="get" class="grid md:grid-cols-3 gap-4">
                <input type="hidden" name="action" value="search">
                <div class="md:col-span-2">
                    <input type="text" name="keyword" placeholder="Search by title or author..."
                           value="${keyword}"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <button type="submit" class="bg-blue-900 hover:bg-blue-800 text-white font-bold py-2 px-4 rounded transition">
                    Search
                </button>
            </form>
        </div>

        <!-- Books Grid -->
        <div class="grid md:grid-cols-3 lg:grid-cols-4 gap-6">
            <c:forEach var="book" items="${books}">
                <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-xl transition">
                    <div class="p-6">
                        <div class="mb-4">
                            <c:choose>
                                <c:when test="${book.status eq 'available' and book.stock > 0}">
                                    <span class="inline-block bg-green-100 text-green-800 text-xs px-2 py-1 rounded-full">Available</span>
                                    <span class="text-xs text-gray-600 ml-2">Stock: ${book.stock}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="inline-block bg-red-100 text-red-800 text-xs px-2 py-1 rounded-full">Unavailable</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h3 class="font-bold text-lg text-gray-800 mb-2 line-clamp-2">${book.title}</h3>
                        <p class="text-gray-600 text-sm mb-1">by ${book.author}</p>
                        <p class="text-gray-500 text-xs mb-4">${book.category}</p>
                        
                        <div class="flex flex-col gap-2">
                            <c:if test="${sessionScope.role eq 'student' and book.available}">
                                <a href="borrow?action=new&bookId=${book.bookId}" 
                                   class="bg-blue-900 hover:bg-blue-800 text-white text-sm font-bold py-2 px-4 rounded text-center transition">
                                    Borrow
                                </a>
                            </c:if>
                            <c:if test="${sessionScope.role eq 'admin'}">
                                <a href="books?action=edit&id=${book.bookId}" 
                                   class="bg-yellow-600 hover:bg-yellow-700 text-white text-sm font-bold py-2 px-4 rounded text-center transition">
                                    Edit
                                </a>
                                <a href="books?action=delete&id=${book.bookId}" 
                                   onclick="return confirm('Are you sure you want to delete this book?')"
                                   class="bg-red-600 hover:bg-red-700 text-white text-sm font-bold py-2 px-4 rounded text-center transition">
                                    Delete
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty books}">
            <div class="bg-white rounded-lg shadow-md p-12 text-center">
                <p class="text-gray-600 text-lg">No books found</p>
            </div>
        </c:if>
    </div>
</body>
</html>
