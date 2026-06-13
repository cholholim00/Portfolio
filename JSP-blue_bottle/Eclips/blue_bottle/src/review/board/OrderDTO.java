package review.board;

import java.sql.Date;
import java.util.List;

public class OrderDTO {
    private int order_idx;
    private int total_price;
    private List<OrderItemDTO> items; // 주문에 포함된 상품들
    
    // 리뷰 작성용 추가 필드
    private String product_idx;
    private String product_name;
    private Date order_date;
    private boolean reviewable; // 리뷰 작성 가능 여부
    
    // 기본 생성자
    public OrderDTO() {}
    
    // Getter, Setter 메소드들
    public int getOrder_idx() {
        return order_idx;
    }
    
    public void setOrder_idx(int order_idx) {
        this.order_idx = order_idx;
    }
    
    public int getTotal_price() {
        return total_price;
    }
    
    public void setTotal_price(int total_price) {
        this.total_price = total_price;
    }
    
    public Date getOrder_date() {
        return order_date;
    }
    
    public void setOrder_date(Date order_date) {
        this.order_date = order_date;
    }
    
    public List<OrderItemDTO> getItems() {
        return items;
    }
    
    public void setItems(List<OrderItemDTO> items) {
        this.items = items;
    }
    
    public String getProduct_idx() {
        return product_idx;
    }
    
    public void setProduct_idx(String product_idx) {
        this.product_idx = product_idx;
    }
    
    public String getProduct_name() {
        return product_name;
    }
    
    public void setProduct_name(String product_name) {
        this.product_name = product_name;
    }
    
    public boolean isReviewable() {
        return reviewable;
    }
    
    public void setReviewable(boolean reviewable) {
        this.reviewable = reviewable;
    }
    
    // 헬퍼 메소드들
    public String getFormattedTotalPrice() {
        return String.format("%,d", total_price);
    }
    
    public int getItemCount() {
        return items != null ? items.size() : 0;
    }
    
    public String getFirstProductName() {
        if (items != null && !items.isEmpty()) {
            return items.get(0).getProduct_name();
        }
        return product_name != null ? product_name : "상품 없음";
    }
    
    public String getOrderSummary() {
        if (items == null || items.isEmpty()) {
            return product_name != null ? product_name : "상품 없음";
        }
        
        if (items.size() == 1) {
            return items.get(0).getProduct_name();
        } else {
            return items.get(0).getProduct_name() + " 외 " + (items.size() - 1) + "개";
        }
    }
}