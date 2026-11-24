<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Digital Library System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4">
    <div class="max-w-4xl w-full">
        <!-- Hero Section -->
        <div class="text-center mb-8">
            <div class="bg-white rounded-full w-24 h-24 flex items-center justify-center mx-auto mb-6 shadow-xl">
                <svg class="w-12 h-12 text-blue-900" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                </svg>
            </div>
            <h1 class="text-5xl font-bold text-white mb-4">Digital Library System</h1>
            <p class="text-xl text-blue-100 mb-8">Your Gateway to Knowledge and Learning</p>
        </div>

        <!-- Features Cards -->
        <div class="grid md:grid-cols-3 gap-6 mb-8">
            <div class="bg-white rounded-lg shadow-lg p-6 text-center transform hover:scale-105 transition">
                <div class="text-4xl mb-4">📚</div>
                <h3 class="font-bold text-lg text-gray-800 mb-2">Browse Books</h3>
                <p class="text-gray-600">Explore our extensive collection of academic books</p>
            </div>
            <div class="bg-white rounded-lg shadow-lg p-6 text-center transform hover:scale-105 transition">
                <div class="text-4xl mb-4">🔖</div>
                <h3 class="font-bold text-lg text-gray-800 mb-2">Easy Borrowing</h3>
                <p class="text-gray-600">Request books online with just a few clicks</p>
            </div>
            <div class="bg-white rounded-lg shadow-lg p-6 text-center transform hover:scale-105 transition">
                <div class="text-4xl mb-4">📊</div>
                <h3 class="font-bold text-lg text-gray-800 mb-2">Track Requests</h3>
                <p class="text-gray-600">Monitor your borrowing history and status</p>
            </div>
        </div>

        <!-- CTA Buttons -->
        <div class="bg-white rounded-xl shadow-2xl p-8">
            <div class="text-center mb-6">
                <h2 class="text-2xl font-bold text-gray-800 mb-2">Get Started</h2>
                <p class="text-gray-600">Login to access the library system</p>
            </div>
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="login.jsp" class="bg-blue-900 hover:bg-blue-800 text-white font-bold py-4 px-8 rounded-lg text-center transition transform hover:scale-105 shadow-lg">
                    Login
                </a>
                <a href="register.jsp" class="bg-green-700 hover:bg-green-600 text-white font-bold py-4 px-8 rounded-lg text-center transition transform hover:scale-105 shadow-lg">
                    Register
                </a>
                <a href="books?action=list" class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-4 px-8 rounded-lg text-center transition transform hover:scale-105 shadow-lg">
                    Browse Books
                </a>
            </div>
        </div>

        <!-- Footer -->
        <div class="text-center mt-8 text-blue-100">
            <p>&copy; 2025 Digital Library System - Informatics Engineering</p>
        </div>
    </div>
</body>
</html>
