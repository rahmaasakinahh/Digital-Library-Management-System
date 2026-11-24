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
import java.util.List;

/**
 * Servlet for handling admin operations on borrow requests
 */
public class AdminServlet extends HttpServlet {
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
        
        // Check if user is admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listAllRequests(request, response);
                break;
            case "pending":
                listPendingRequests(request, response);
                break;
            case "approve":
                approveRequest(request, response);
                break;
            case "reject":
                showRejectForm(request, response);
                break;
            default:
                listAllRequests(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin?action=list");
            return;
        }

        switch (action) {
            case "reject":
                rejectRequest(request, response);
                break;
            case "updateStatus":
                updateRequestStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin?action=list");
        }
    }

    private void listAllRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        List<BorrowRequest> requests;

        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            requests = borrowRequestDAO.findByStatus(statusFilter);
            request.setAttribute("statusFilter", statusFilter);
        } else {
            requests = borrowRequestDAO.findAll();
        }

        request.setAttribute("requests", requests);
        request.getRequestDispatcher("/admin_borrow_list.jsp").forward(request, response);
    }

    private void listPendingRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<BorrowRequest> requests = borrowRequestDAO.findPending();
        request.setAttribute("requests", requests);
        request.setAttribute("statusFilter", "pending");
        request.getRequestDispatcher("/admin_borrow_list.jsp").forward(request, response);
    }

    private void approveRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int requestId = Integer.parseInt(request.getParameter("id"));
        BorrowRequest borrowRequest = borrowRequestDAO.findById(requestId);

        if (borrowRequest != null && borrowRequest.isPending()) {
            // Check if book is still available
            Book book = bookDAO.findById(borrowRequest.getBookId());
            
            if (book != null && book.isAvailable()) {
                // Update request status to approved
                if (borrowRequestDAO.updateStatus(requestId, "approved", "Approved by admin")) {
                    // Decrease book stock
                    bookDAO.decreaseStock(borrowRequest.getBookId());
                    request.getSession().setAttribute("success", "Request approved successfully!");
                } else {
                    request.getSession().setAttribute("error", "Failed to approve request");
                }
            } else {
                request.getSession().setAttribute("error", "Book is no longer available");
            }
        } else {
            request.getSession().setAttribute("error", "Invalid request or already processed");
        }

        response.sendRedirect(request.getContextPath() + "/admin?action=pending");
    }

    private void showRejectForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int requestId = Integer.parseInt(request.getParameter("id"));
        BorrowRequest borrowRequest = borrowRequestDAO.findById(requestId);

        if (borrowRequest != null && borrowRequest.isPending()) {
            request.setAttribute("request", borrowRequest);
            request.getRequestDispatcher("/reject_request.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin?action=pending");
        }
    }

    private void rejectRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String adminNotes = request.getParameter("adminNotes");

        BorrowRequest borrowRequest = borrowRequestDAO.findById(requestId);

        if (borrowRequest != null && borrowRequest.isPending()) {
            if (borrowRequestDAO.updateStatus(requestId, "rejected", adminNotes)) {
                request.getSession().setAttribute("success", "Request rejected successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to reject request");
            }
        } else {
            request.getSession().setAttribute("error", "Invalid request or already processed");
        }

        response.sendRedirect(request.getContextPath() + "/admin?action=pending");
    }

    private void updateRequestStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String newStatus = request.getParameter("status");
        String adminNotes = request.getParameter("adminNotes");

        BorrowRequest borrowRequest = borrowRequestDAO.findById(requestId);

        if (borrowRequest != null) {
            // Handle stock changes based on status transitions
            if ("approved".equals(newStatus) && !borrowRequest.isApproved()) {
                Book book = bookDAO.findById(borrowRequest.getBookId());
                if (book != null && book.isAvailable()) {
                    bookDAO.decreaseStock(borrowRequest.getBookId());
                } else {
                    request.getSession().setAttribute("error", "Book is no longer available");
                    response.sendRedirect(request.getContextPath() + "/admin?action=list");
                    return;
                }
            } else if ("returned".equals(newStatus) && borrowRequest.isApproved()) {
                bookDAO.increaseStock(borrowRequest.getBookId());
            }

            if (borrowRequestDAO.updateStatus(requestId, newStatus, adminNotes)) {
                request.getSession().setAttribute("success", "Request status updated successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to update request status");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin?action=list");
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
