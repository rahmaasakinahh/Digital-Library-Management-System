package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.dao.BorrowRequestDAO;
import com.library.model.Book;
import com.library.model.BorrowRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Servlet for handling borrow request operations (Student CRUD)
 */
public class BorrowServlet extends HttpServlet {
    private BorrowRequestDAO borrowRequestDAO;
    private BookDAO bookDAO;

    @Override
    public void init() {
        borrowRequestDAO = new BorrowRequestDAO();
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
                listUserRequests(request, response);
                break;
            case "new":
                showBorrowForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteRequest(request, response);
                break;
            default:
                listUserRequests(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/borrow?action=list");
            return;
        }

        switch (action) {
            case "create":
                createBorrowRequest(request, response);
                break;
            case "update":
                updateBorrowRequest(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/borrow?action=list");
        }
    }

    private void listUserRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        List<BorrowRequest> requests = borrowRequestDAO.findByUserId(userId);

        request.setAttribute("requests", requests);
        request.getRequestDispatcher("/student_requests.jsp").forward(request, response);
    }

    private void showBorrowForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String bookIdStr = request.getParameter("bookId");
        if (bookIdStr != null) {
            int bookId = Integer.parseInt(bookIdStr);
            Book book = bookDAO.findById(bookId);
            request.setAttribute("book", book);
        }

        List<Book> availableBooks = bookDAO.findAvailable();
        request.setAttribute("availableBooks", availableBooks);
        request.getRequestDispatcher("/borrow_form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int requestId = Integer.parseInt(request.getParameter("id"));
        BorrowRequest borrowRequest = borrowRequestDAO.findById(requestId);
        
        // Check if request belongs to user and is pending
        int userId = (Integer) session.getAttribute("userId");
        if (borrowRequest == null || borrowRequest.getUserId() != userId || !borrowRequest.isPending()) {
            response.sendRedirect(request.getContextPath() + "/borrow?action=list");
            return;
        }

        List<Book> availableBooks = bookDAO.findAvailable();
        request.setAttribute("request", borrowRequest);
        request.setAttribute("availableBooks", availableBooks);
        request.getRequestDispatcher("/edit_borrow.jsp").forward(request, response);
    }

    private void createBorrowRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("userId");
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            String borrowDateStr = request.getParameter("borrowDate");
            String returnDateStr = request.getParameter("returnDate");

            // Validate book availability
            Book book = bookDAO.findById(bookId);
            if (book == null || !book.isAvailable()) {
                request.setAttribute("error", "Selected book is not available");
                showBorrowForm(request, response);
                return;
            }

            BorrowRequest borrowRequest = new BorrowRequest();
            borrowRequest.setUserId(userId);
            borrowRequest.setBookId(bookId);
            borrowRequest.setBorrowDate(Date.valueOf(borrowDateStr));
            borrowRequest.setReturnDate(Date.valueOf(returnDateStr));
            borrowRequest.setStatus("pending");

            if (borrowRequestDAO.create(borrowRequest)) {
                session.setAttribute("success", "Borrow request submitted successfully!");
                response.sendRedirect(request.getContextPath() + "/student_dashboard.jsp");
            } else {
                request.setAttribute("error", "Failed to submit borrow request");
                showBorrowForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            showBorrowForm(request, response);
        }
    }

    private void updateBorrowRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("userId");
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            
            // Verify ownership
            BorrowRequest existingRequest = borrowRequestDAO.findById(requestId);
            if (existingRequest == null || existingRequest.getUserId() != userId || !existingRequest.isPending()) {
                response.sendRedirect(request.getContextPath() + "/borrow?action=list");
                return;
            }

            int bookId = Integer.parseInt(request.getParameter("bookId"));
            String borrowDateStr = request.getParameter("borrowDate");
            String returnDateStr = request.getParameter("returnDate");

            BorrowRequest borrowRequest = new BorrowRequest();
            borrowRequest.setRequestId(requestId);
            borrowRequest.setUserId(userId);
            borrowRequest.setBookId(bookId);
            borrowRequest.setBorrowDate(Date.valueOf(borrowDateStr));
            borrowRequest.setReturnDate(Date.valueOf(returnDateStr));
            borrowRequest.setStatus("pending");

            if (borrowRequestDAO.update(borrowRequest)) {
                session.setAttribute("success", "Borrow request updated successfully!");
                response.sendRedirect(request.getContextPath() + "/student_dashboard.jsp");
            } else {
                request.setAttribute("error", "Failed to update borrow request");
                showEditForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            showEditForm(request, response);
        }
    }

    private void deleteRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        int requestId = Integer.parseInt(request.getParameter("id"));
        
        // Verify ownership and status
        BorrowRequest borrowRequest = borrowRequestDAO.findById(requestId);
        if (borrowRequest != null && borrowRequest.getUserId() == userId && borrowRequest.isPending()) {
            if (borrowRequestDAO.delete(requestId)) {
                session.setAttribute("success", "Borrow request cancelled successfully!");
            } else {
                session.setAttribute("error", "Failed to cancel borrow request");
            }
        } else {
            session.setAttribute("error", "Cannot cancel this request");
        }

        response.sendRedirect(request.getContextPath() + "/borrow?action=list");
    }
}
