package com.library.dao;

import com.library.model.Book;
import com.library.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Book operations
 */
public class BookDAO {

    /**
     * Find book by ID
     * @param bookId Book ID to search for
     * @return Book object or null if not found
     */
    public Book findById(int bookId) {
        String sql = "SELECT * FROM books WHERE book_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractBookFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Create a new book
     * @param book Book object to create
     * @return true if creation successful
     */
    public boolean create(Book book) {
        String sql = "INSERT INTO books (title, author, category, stock, status, isbn, publisher, publication_year, description) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setString(3, book.getCategory());
            stmt.setInt(4, book.getStock());
            stmt.setString(5, book.getStatus());
            stmt.setString(6, book.getIsbn());
            stmt.setString(7, book.getPublisher());
            
            if (book.getPublicationYear() != null) {
                stmt.setInt(8, book.getPublicationYear());
            } else {
                stmt.setNull(8, Types.INTEGER);
            }
            
            stmt.setString(9, book.getDescription());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    book.setBookId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update an existing book
     * @param book Book object with updated data
     * @return true if update successful
     */
    public boolean update(Book book) {
        String sql = "UPDATE books SET title = ?, author = ?, category = ?, stock = ?, status = ?, " +
                     "isbn = ?, publisher = ?, publication_year = ?, description = ? WHERE book_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setString(3, book.getCategory());
            stmt.setInt(4, book.getStock());
            stmt.setString(5, book.getStatus());
            stmt.setString(6, book.getIsbn());
            stmt.setString(7, book.getPublisher());
            
            if (book.getPublicationYear() != null) {
                stmt.setInt(8, book.getPublicationYear());
            } else {
                stmt.setNull(8, Types.INTEGER);
            }
            
            stmt.setString(9, book.getDescription());
            stmt.setInt(10, book.getBookId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete a book by ID
     * @param bookId Book ID to delete
     * @return true if deletion successful
     */
    public boolean delete(int bookId) {
        String sql = "DELETE FROM books WHERE book_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all books
     * @return List of all books
     */
    public List<Book> findAll() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY book_id DESC";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * Get available books (status = 'available' and stock > 0)
     * @return List of available books
     */
    public List<Book> findAvailable() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE status = 'available' AND stock > 0 ORDER BY title";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * Search books by title or author
     * @param keyword Keyword to search for
     * @return List of matching books
     */
    public List<Book> search(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE LOWER(title) LIKE LOWER(?) OR LOWER(author) LIKE LOWER(?) ORDER BY title";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * Get books by category
     * @param category Category to filter by
     * @return List of books in the specified category
     */
    public List<Book> findByCategory(String category) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE category = ? ORDER BY title";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * Get all unique categories
     * @return List of category names
     */
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM books WHERE category IS NOT NULL ORDER BY category";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Update book stock
     * @param bookId Book ID
     * @param newStock New stock value
     * @return true if update successful
     */
    public boolean updateStock(int bookId, int newStock) {
        String sql = "UPDATE books SET stock = ?, status = ? WHERE book_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, newStock);
            stmt.setString(2, newStock > 0 ? "available" : "unavailable");
            stmt.setInt(3, bookId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Decrease book stock by 1 (when borrowed)
     * @param bookId Book ID
     * @return true if update successful
     */
    public boolean decreaseStock(int bookId) {
        String sql = "UPDATE books SET stock = stock - 1, " +
                     "status = CASE WHEN stock - 1 <= 0 THEN 'unavailable' ELSE status END " +
                     "WHERE book_id = ? AND stock > 0";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Increase book stock by 1 (when returned)
     * @param bookId Book ID
     * @return true if update successful
     */
    public boolean increaseStock(int bookId) {
        String sql = "UPDATE books SET stock = stock + 1, status = 'available' WHERE book_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Extract Book object from ResultSet
     * @param rs ResultSet
     * @return Book object
     * @throws SQLException if extraction fails
     */
    private Book extractBookFromResultSet(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("book_id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setCategory(rs.getString("category"));
        book.setStock(rs.getInt("stock"));
        book.setStatus(rs.getString("status"));
        book.setIsbn(rs.getString("isbn"));
        book.setPublisher(rs.getString("publisher"));
        
        int year = rs.getInt("publication_year");
        if (!rs.wasNull()) {
            book.setPublicationYear(year);
        }
        
        book.setDescription(rs.getString("description"));
        book.setCreatedAt(rs.getTimestamp("created_at"));
        book.setUpdatedAt(rs.getTimestamp("updated_at"));
        return book;
    }
}
