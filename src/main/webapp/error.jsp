<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Digital Library</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gradient-to-br from-blue-900 to-blue-600 flex items-center justify-center p-4">
    <div class="max-w-md w-full bg-white rounded-xl shadow-2xl p-8 text-center">
        <div class="text-6xl mb-4">⚠️</div>
        <h1 class="text-3xl font-bold text-gray-800 mb-4">Oops! Something went wrong</h1>
        <p class="text-gray-600 mb-6">
            <c:choose>
                <c:when test="${not empty pageContext.errorData.statusCode}">
                    Error ${pageContext.errorData.statusCode}
                </c:when>
                <c:otherwise>
                    An unexpected error occurred
                </c:otherwise>
            </c:choose>
        </p>
        <a href="index.jsp" class="inline-block bg-blue-900 hover:bg-blue-800 text-white font-bold py-3 px-6 rounded transition">
            Go to Home
        </a>
    </div>
</body>
</html>
