package com.library.servlet;

import com.library.dao.BorrowRequestDAO;
import com.library.model.BorrowRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * API Servlet for AJAX requests to get borrow requests
 */
public class BorrowRequestApiServlet extends HttpServlet {
    private BorrowRequestDAO borrowRequestDAO;
    private Gson gson;

    @Override
    public void init() {
        borrowRequestDAO = new BorrowRequestDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check authentication
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");
        
        if ("admin".equals(role)) {
            handleAdminRequest(request, response);
        } else if ("student".equals(role)) {
            handleStudentRequest(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        }
    }

    private void handleAdminRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String status = request.getParameter("status");
        List<BorrowRequest> requests;
        
        if (status != null && !status.trim().isEmpty() && !"all".equals(status)) {
            requests = borrowRequestDAO.findByStatus(status);
        } else {
            requests = borrowRequestDAO.findAll();
        }
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(requests));
        out.flush();
    }

    private void handleStudentRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        String status = request.getParameter("status");
        List<BorrowRequest> requests;
        
        if (status != null && !status.trim().isEmpty() && !"all".equals(status)) {
            requests = borrowRequestDAO.findByUserIdAndStatus(userId, status);
        } else {
            requests = borrowRequestDAO.findByUserId(userId);
        }
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(requests));
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String role = (String) session.getAttribute("role");
        
        JsonObject result = new JsonObject();
        
        if ("updateStatus".equals(action) && "admin".equals(role)) {
            handleStatusUpdate(request, response, result);
        } else {
            result.addProperty("success", false);
            result.addProperty("message", "Invalid action");
        }
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }

    private void handleStatusUpdate(HttpServletRequest request, HttpServletResponse response, JsonObject result) {
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String newStatus = request.getParameter("status");
            String adminNotes = request.getParameter("adminNotes");
            
            boolean success = borrowRequestDAO.updateStatus(requestId, newStatus, adminNotes);
            
            result.addProperty("success", success);
            if (success) {
                result.addProperty("message", "Status updated successfully");
            } else {
                result.addProperty("message", "Failed to update status");
            }
        } catch (Exception e) {
            result.addProperty("success", false);
            result.addProperty("message", "Error: " + e.getMessage());
        }
    }
}
