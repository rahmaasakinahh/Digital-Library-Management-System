package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet for handling book operations (CRUD)
 */
public class BookServlet extends HttpServlet {
    private BookDAO bookDAO;

    @Override
    public void init() {
        bookDAO = new BookDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listBooks(request, response);
                break;
            case "view":
                viewBook(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBook(request, response);
                break;
            case "search":
                searchBooks(request, response);
                break;
            default:
                listBooks(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/books?action=list");
            return;
        }

        switch (action) {
            case "create":
                createBook(request, response);
                break;
            case "update":
                updateBook(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/books?action=list");
        }
    }

    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");
        List<Book> books;

        if (category != null && !category.trim().isEmpty()) {
            books = bookDAO.findByCategory(category);
            request.setAttribute("selectedCategory", category);
        } else {
            books = bookDAO.findAll();
        }

        List<String> categories = bookDAO.getAllCategories();
        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/book_list.jsp").forward(request, response);
    }

    private void viewBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.findById(bookId);

        if (book != null) {
            request.setAttribute("book", book);
            request.getRequestDispatcher("/book_detail.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/books?action=list");
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.getRequestDispatcher("/add_book.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int bookId = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.findById(bookId);

        if (book != null) {
            request.setAttribute("book", book);
            request.getRequestDispatcher("/edit_book.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/books?action=list");
        }
    }

    private void createBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Book book = new Book();
            book.setTitle(request.getParameter("title"));
            book.setAuthor(request.getParameter("author"));
            book.setCategory(request.getParameter("category"));
            book.setStock(Integer.parseInt(request.getParameter("stock")));
            book.setStatus(request.getParameter("status"));
            book.setIsbn(request.getParameter("isbn"));
            book.setPublisher(request.getParameter("publisher"));

            String yearStr = request.getParameter("publicationYear");
            if (yearStr != null && !yearStr.trim().isEmpty()) {
                book.setPublicationYear(Integer.parseInt(yearStr));
            }

            book.setDescription(request.getParameter("description"));

            if (bookDAO.create(book)) {
                request.getSession().setAttribute("success", "Book added successfully!");
                response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
            } else {
                request.setAttribute("error", "Failed to add book");
                request.getRequestDispatcher("/add_book.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/add_book.jsp").forward(request, response);
        }
    }

    private void updateBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Book book = new Book();
            book.setBookId(Integer.parseInt(request.getParameter("bookId")));
            book.setTitle(request.getParameter("title"));
            book.setAuthor(request.getParameter("author"));
            book.setCategory(request.getParameter("category"));
            book.setStock(Integer.parseInt(request.getParameter("stock")));
            book.setStatus(request.getParameter("status"));
            book.setIsbn(request.getParameter("isbn"));
            book.setPublisher(request.getParameter("publisher"));

            String yearStr = request.getParameter("publicationYear");
            if (yearStr != null && !yearStr.trim().isEmpty()) {
                book.setPublicationYear(Integer.parseInt(yearStr));
            }

            book.setDescription(request.getParameter("description"));

            if (bookDAO.update(book)) {
                request.getSession().setAttribute("success", "Book updated successfully!");
                response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
            } else {
                request.setAttribute("error", "Failed to update book");
                request.setAttribute("book", book);
                request.getRequestDispatcher("/edit_book.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/edit_book.jsp").forward(request, response);
        }
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int bookId = Integer.parseInt(request.getParameter("id"));

        if (bookDAO.delete(bookId)) {
            request.getSession().setAttribute("success", "Book deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to delete book");
        }

        response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
    }

    private void searchBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Book> books;

        if (keyword != null && !keyword.trim().isEmpty()) {
            books = bookDAO.search(keyword);
            request.setAttribute("keyword", keyword);
        } else {
            books = bookDAO.findAll();
        }

        List<String> categories = bookDAO.getAllCategories();
        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/book_list.jsp").forward(request, response);
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            String role = (String) session.getAttribute("role");
            return "admin".equalsIgnoreCase(role);
        }
        return false;
    }
}
