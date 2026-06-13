package review.board;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import common.JDBConnect;

public class OrderDAO extends JDBConnect {
    
    public OrderDAO() {}
    
    // 특정 사용자의 주문 내역 조회 (주문별로 그룹화)(UserDetail.jsp)
    public List<OrderDTO> getUserOrders(int userIdx) {
        List<OrderDTO> orders = new ArrayList<>();
        Map<Integer, OrderDTO> orderMap = new HashMap<>();
        
        String query = 
            "SELECT o.order_idx, o.total_price, " +                    // 주문.주문_idx, 주문.총계,
            "oi.total_quantity, oi.product_idx, " +                    // 주문_아이템.총갯수, 주문_아이템.상품_idx
            "p.name, p.price " +                                       // 상품.이름, 상품.가격
            "FROM orders o " +
            "JOIN order_item oi ON o.order_idx = oi.order_idx " +      // 주문 + 주문아이템 연결
            "JOIN product p ON oi.product_idx = p.product_idx " +      // 주문아이템 + 상품 연결
            "WHERE o.user_idx = ? " +                                  // 해당 사용자의 주문만
            "ORDER BY o.order_idx DESC, oi.product_idx";               // 최신 주문순, 상품별 정렬
        
        try {
            pstmt = getConnection().prepareStatement(query);
            pstmt.setInt(1, userIdx);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                int orderIdx = rs.getInt("order_idx");
                
                // 기존 주문이 있으면 상품만 추가, 없으면 새 주문 생성(사실상 그룹화)
                OrderDTO order = orderMap.get(orderIdx);
                if (order == null) {
                    order = new OrderDTO();
                    order.setOrder_idx(orderIdx);
                    order.setTotal_price(rs.getInt("total_price"));
                    order.setItems(new ArrayList<>());
                    
                    orderMap.put(orderIdx, order);
                    orders.add(order);
                }
                
                // 주문 아이템 추가
                OrderItemDTO item = new OrderItemDTO();
                item.setProduct_idx(rs.getString("product_idx"));
                item.setProduct_name(rs.getString("name"));
                item.setQuantity(rs.getInt("total_quantity"));
                item.setUnit_price(rs.getInt("price"));
                
                order.getItems().add(item);
            }
        } catch (Exception e) {
            System.out.println("Exception[getUserOrders]: " + e.getMessage());
            e.printStackTrace();
        }
        
        return orders;
    }
    
    // *** 새로 추가된 메서드: 리뷰 작성 가능한 상품만 조회 ***
    public List<OrderDTO> getReviewableProducts(int userIdx) {
        List<OrderDTO> products = new ArrayList<>();
        
        String query = 
            "SELECT DISTINCT oi.product_idx, p.name, " +                   // 중복 제거된 상품 정보
            "o.order_idx " +                                               // 주문 번호
            "FROM orders o " +
            "JOIN order_item oi ON o.user_idx = oi.user_idx " +          // 주문 + 주문아이템 연결
            "JOIN product p ON oi.product_idx = p.product_idx " +          // 주문아이템 + 상품 연결
            "WHERE o.user_idx = ? " +                                      // 해당 사용자의 주문만
            "AND NOT EXISTS (" +                                           // 리뷰 작성하지 않은 상품만
            "    SELECT 1 FROM review r " +                                // 리뷰 테이블에서
            "    WHERE r.user_idx = ? " +                                  // 같은 사용자가
            "    AND r.product_idx = oi.product_idx" +                     // 같은 상품에 대해 작성한 리뷰가 없을 때
            ") " +
            "ORDER BY o.order_idx DESC";                                   // 최신 주문순으로 정렬
        
        try {
            pstmt = getConnection().prepareStatement(query);
            pstmt.setInt(1, userIdx);
            pstmt.setInt(2, userIdx); // NOT EXISTS 절의 두 번째 user_idx
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                OrderDTO product = new OrderDTO();
                product.setProduct_idx(rs.getString("product_idx"));
                product.setProduct_name(rs.getString("name"));
                product.setOrder_idx(rs.getInt("order_idx"));
                product.setReviewable(true); // 리뷰 작성 가능
                
                products.add(product);
            }
            
            System.out.println("리뷰 작성 가능한 상품 개수: " + products.size());
            
        } catch (Exception e) {
            System.out.println("Exception[getReviewableProducts]: " + e.getMessage());
            e.printStackTrace();
        }
        
        return products;
    }
    
    // 특정 사용자의 총 주문 건수 조회
    public int getTotalOrderCount(int userIdx) {
        int count = 0;
        String query = 
            "SELECT COUNT(DISTINCT o.order_idx) " +                       // 중복 제거된 주문 개수
            "FROM orders o " +
            "WHERE o.user_idx = ?";                                        // 해당 사용자의 주문만
        
        try {
            pstmt = getConnection().prepareStatement(query);
            pstmt.setInt(1, userIdx);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Exception[getTotalOrderCount]: " + e.getMessage());
        }
        
        return count;
    }
    
    // 특정 사용자의 총 주문 금액 조회
    public int getTotalOrderAmount(int userIdx) {
        int totalAmount = 0;
        String query = 
            "SELECT SUM(total_price) " +                                  // 총 주문 금액 합계
            "FROM orders " +
            "WHERE user_idx = ?";                                          // 해당 사용자의 주문만
        
        try {
            pstmt = getConnection().prepareStatement(query);
            pstmt.setInt(1, userIdx);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                totalAmount = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Exception[getTotalOrderAmount]: " + e.getMessage());
        }
        
        return totalAmount;
    }
    
    // 특정 주문 상세 정보 조회
    public OrderDTO getOrderDetail(int orderIdx) {
        OrderDTO order = null;
        
        String query = 
            "SELECT o.order_idx, o.total_price, " +                       // 주문 기본 정보
            "oi.total_quantity, oi.product_idx, " +                       // 주문 아이템 정보
            "p.name, p.price " +                                          // 상품 정보
            "FROM orders o " +
            "JOIN order_item oi ON o.order_idx = oi.order_idx " +         // 주문 + 주문아이템 연결
            "JOIN product p ON oi.product_idx = p.product_idx " +         // 주문아이템 + 상품 연결
            "WHERE o.order_idx = ? " +                                    // 특정 주문만
            "ORDER BY oi.product_idx";                                    // 상품별 정렬
        
        try {
            pstmt = getConnection().prepareStatement(query);
            pstmt.setInt(1, orderIdx);
            rs = pstmt.executeQuery();
            
            List<OrderItemDTO> items = new ArrayList<>();
            
            while (rs.next()) {
                if (order == null) {
                    // 첫 번째 row에서 주문 정보 설정
                    order = new OrderDTO();
                    order.setOrder_idx(rs.getInt("order_idx"));
                    order.setTotal_price(rs.getInt("total_price"));
                }
                
                // 주문 아이템 추가
                OrderItemDTO item = new OrderItemDTO();
                item.setProduct_idx(rs.getString("product_idx"));
                item.setProduct_name(rs.getString("name"));
                item.setQuantity(rs.getInt("total_quantity"));
                item.setUnit_price(rs.getInt("price"));
                
                items.add(item);
            }
            
            if (order != null) {
                order.setItems(items);
            }
            
        } catch (Exception e) {
            System.out.println("Exception[getOrderDetail]: " + e.getMessage());
        }
        
        return order;
    }
    
    // 주문 삭제 (관리자용)
    public boolean deleteOrder(int orderIdx) {
        boolean success = false;
        
        try {
            // 트랜잭션 시작
            getConnection().setAutoCommit(false);
            
            // 1. order_item 먼저 삭제
            String deleteOrderItemQuery = 
                "DELETE FROM order_item " +                               // 주문 아이템 삭제
                "WHERE order_idx = ?";                                    // 특정 주문의 모든 아이템
            pstmt = getConnection().prepareStatement(deleteOrderItemQuery);
            pstmt.setInt(1, orderIdx);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 2. orders 삭제
            String deleteOrderQuery = 
                "DELETE FROM orders " +                                   // 주문 삭제
                "WHERE order_idx = ?";                                    // 특정 주문만
            pstmt = getConnection().prepareStatement(deleteOrderQuery);
            pstmt.setInt(1, orderIdx);
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                getConnection().commit();
                success = true;
            } else {
                getConnection().rollback();
            }
            
        } catch (Exception e) {
            try {
                getConnection().rollback();
            } catch (SQLException se) {
                System.out.println("Rollback failed: " + se.getMessage());
            }
            System.out.println("Exception[deleteOrder]: " + e.getMessage());
        } finally {
            try {
                getConnection().setAutoCommit(true);
            } catch (SQLException e) {
                System.out.println("AutoCommit reset failed: " + e.getMessage());
            }
        }
        
        return success;
    }
}