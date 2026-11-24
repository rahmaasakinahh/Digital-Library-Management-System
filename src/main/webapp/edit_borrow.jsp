<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.user or sessionScope.role ne 'student'}">
    <c:redirect url="login.jsp"/>
</c:if>
<jsp:useBean id="bookDAO" class="com.library.dao.BookDAO"/>
<c:set var="availableBooks" value="${bookDAO.findAvailable()}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Borrow Request - Digital Library</title>
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
                    <a href="student_dashboard.jsp" class="hover:text-blue-200">Dashboard</a>
                    <a href="logout" class="bg-red-600 hover:bg-red-700 px-4 py-2 rounded transition">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-800">Edit Borrow Request</h1>
            <p class="text-gray-600 mt-2">Update your borrowing request details</p>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                ${error}
            </div>
        </c:if>

        <!-- Edit Form -->
        <div class="bg-white rounded-lg shadow-md p-8">
            <form action="borrow" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="requestId" value="${request.requestId}">

                <div class="space-y-6">
                    <div>
                        <label for="bookId" class="block text-gray-700 font-semibold mb-2">Select Book *</label>
                        <select id="bookId" name="bookId" required
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="">-- Select a book --</option>
                            <c:forEach var="book" items="${availableBooks}">
                                <option value="${book.bookId}" ${request.bookId eq book.bookId ? 'selected' : ''}>
                                    ${book.title} by ${book.author} (Stock: ${book.stock})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="grid md:grid-cols-2 gap-6">
                        <div>
                            <label for="borrowDate" class="block text-gray-700 font-semibold mb-2">Borrow Date *</label>
                            <input type="date" id="borrowDate" name="borrowDate" required
                                   value="${request.borrowDate}"
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                        </div>

                        <div>
                            <label for="returnDate" class="block text-gray-700 font-semibold mb-2">Expected Return Date *</label>
                            <input type="date" id="returnDate" name="returnDate" required
                                   value="${request.returnDate}"
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                        </div>
                    </div>

                    <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                        <p class="text-sm text-yellow-800">
                            <strong>Note:</strong> You can only edit requests with "Pending" status.
                        </p>
                    </div>
                </div>

                <div class="flex gap-4 mt-6">
                    <button type="submit"
                            class="bg-blue-900 hover:bg-blue-800 text-white font-bold py-2 px-6 rounded transition">
                        Update Request
                    </button>
                    <a href="borrow?action=list"
                       class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-6 rounded transition">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Set minimum dates
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('borrowDate').setAttribute('min', today);
        
        // Update return date minimum when borrow date changes
        document.getElementById('borrowDate').addEventListener('change', function() {
            const borrowDate = new Date(this.value);
            const nextDay = new Date(borrowDate);
            nextDay.setDate(borrowDate.getDate() + 1);
            document.getElementById('returnDate').setAttribute('min', nextDay.toISOString().split('T')[0]);
        });
    </script>
</body>
</html>
