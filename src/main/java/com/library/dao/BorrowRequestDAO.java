package com.library.dao;

import com.library.model.BorrowRequest;
import com.library.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for BorrowRequest operations
 */
public class BorrowRequestDAO {

    /**
     * Find borrow request by ID
     * @param requestId Request ID to search for
     * @return BorrowRequest object or null if not found
     */
    public BorrowRequest findById(int requestId) {
        String sql = "SELECT br.*, u.username, u.full_name, b.title, b.author " +
                     "FROM borrow_requests br " +
                     "JOIN users u ON br.user_id = u.user_id " +
                     "JOIN books b ON br.book_id = b.book_id " +
                     "WHERE br.request_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, requestId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractBorrowRequestFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Create a new borrow request
     * @param request BorrowRequest object to create
     * @return true if creation successful
     */
    public boolean create(BorrowRequest request) {
        String sql = "INSERT INTO borrow_requests (user_id, book_id, borrow_date, return_date, status, admin_notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, request.getUserId());
            stmt.setInt(2, request.getBookId());
            stmt.setDate(3, request.getBorrowDate());
            stmt.setDate(4, request.getReturnDate());
            stmt.setString(5, request.getStatus());
            stmt.setString(6, request.getAdminNotes());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    request.setRequestId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update an existing borrow request
     * @param request BorrowRequest object with updated data
     * @return true if update successful
     */
    public boolean update(BorrowRequest request) {
        String sql = "UPDATE borrow_requests SET user_id = ?, book_id = ?, borrow_date = ?, " +
                     "return_date = ?, status = ?, admin_notes = ? WHERE request_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, request.getUserId());
            stmt.setInt(2, request.getBookId());
            stmt.setDate(3, request.getBorrowDate());
            stmt.setDate(4, request.getReturnDate());
            stmt.setString(5, request.getStatus());
            stmt.setString(6, request.getAdminNotes());
            stmt.setInt(7, request.getRequestId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update request status and admin notes
     * @param requestId Request ID
     * @param status New status
     * @param adminNotes Admin notes
     * @return true if update successful
     */
    public boolean updateStatus(int requestId, String status, String adminNotes) {
        String sql = "UPDATE borrow_requests SET status = ?, admin_notes = ? WHERE request_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setString(2, adminNotes);
            stmt.setInt(3, requestId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete a borrow request by ID
     * @param requestId Request ID to delete
     * @return true if deletion successful
     */
    public boolean delete(int requestId) {
        String sql = "DELETE FROM borrow_requests WHERE request_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, requestId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all borrow requests
     * @return List of all borrow requests
     */
    public List<BorrowRequest> findAll() {
        List<BorrowRequest> requests = new ArrayList<>();
        String sql = "SELECT br.*, u.username, u.full_name, b.title, b.author " +
                     "FROM borrow_requests br " +
                     "JOIN users u ON br.user_id = u.user_id " +
                     "JOIN books b ON br.book_id = b.book_id " +
                     "ORDER BY br.created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                requests.add(extractBorrowRequestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }

    /**
     * Get borrow requests by user ID
     * @param userId User ID to filter by
     * @return List of borrow requests for the specified user
     */
    public List<BorrowRequest> findByUserId(int userId) {
        List<BorrowRequest> requests = new ArrayList<>();
        String sql = "SELECT br.*, u.username, u.full_name, b.title, b.author " +
                     "FROM borrow_requests br " +
                     "JOIN users u ON br.user_id = u.user_id " +
                     "JOIN books b ON br.book_id = b.book_id " +
                     "WHERE br.user_id = ? " +
                     "ORDER BY br.created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                requests.add(extractBorrowRequestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }

    /**
     * Get borrow requests by status
     * @param status Status to filter by
     * @return List of borrow requests with the specified status
     */
    public List<BorrowRequest> findByStatus(String status) {
        List<BorrowRequest> requests = new ArrayList<>();
        String sql = "SELECT br.*, u.username, u.full_name, b.title, b.author " +
                     "FROM borrow_requests br " +
                     "JOIN users u ON br.user_id = u.user_id " +
                     "JOIN books b ON br.book_id = b.book_id " +
                     "WHERE br.status = ? " +
                     "ORDER BY br.created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                requests.add(extractBorrowRequestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }

    /**
     * Get pending borrow requests
     * @return List of pending borrow requests
     */
    public List<BorrowRequest> findPending() {
        return findByStatus("pending");
    }

    /**
     * Get borrow requests by user ID and status
     * @param userId User ID
     * @param status Status
     * @return List of matching borrow requests
     */
    public List<BorrowRequest> findByUserIdAndStatus(int userId, String status) {
        List<BorrowRequest> requests = new ArrayList<>();
        String sql = "SELECT br.*, u.username, u.full_name, b.title, b.author " +
                     "FROM borrow_requests br " +
                     "JOIN users u ON br.user_id = u.user_id " +
                     "JOIN books b ON br.book_id = b.book_id " +
                     "WHERE br.user_id = ? AND br.status = ? " +
                     "ORDER BY br.created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                requests.add(extractBorrowRequestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }

    /**
     * Count requests by status
     * @param status Status to count
     * @return Number of requests with the specified status
     */
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM borrow_requests WHERE status = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Extract BorrowRequest object from ResultSet
     * @param rs ResultSet
     * @return BorrowRequest object
     * @throws SQLException if extraction fails
     */
    private BorrowRequest extractBorrowRequestFromResultSet(ResultSet rs) throws SQLException {
        BorrowRequest request = new BorrowRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setUserId(rs.getInt("user_id"));
        request.setBookId(rs.getInt("book_id"));
        request.setBorrowDate(rs.getDate("borrow_date"));
        request.setReturnDate(rs.getDate("return_date"));
        request.setStatus(rs.getString("status"));
        request.setAdminNotes(rs.getString("admin_notes"));
        request.setCreatedAt(rs.getTimestamp("created_at"));
        request.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Set joined fields if available
        try {
            request.setUserName(rs.getString("username"));
            request.setUserFullName(rs.getString("full_name"));
            request.setBookTitle(rs.getString("title"));
            request.setBookAuthor(rs.getString("author"));
        } catch (SQLException e) {
            // These fields might not be present in all queries
        }
        
        return request;
    }
}
